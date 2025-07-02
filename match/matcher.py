import re
import json
import torch
import logging
import subprocess
from transformers import AutoTokenizer, AutoModelForCausalLM
from typing import Dict, Any, Optional

from django.conf import settings


class ResumeJobMatcher:
    DEFAULT_MODEL_PATH = settings.MATCHER_MODEL_PATH

    def _get_free_gpu(self) -> str:
        try:
            result = subprocess.run(
                [
                    "nvidia-smi",
                    "--query-gpu=memory.free,index",
                    "--format=csv,nounits,noheader",
                ],
                stdout=subprocess.PIPE,
                encoding="utf-8",
                check=True,
            )
            gpu_infos = result.stdout.strip().split("\n")

            free_memories = []
            for info in gpu_infos:
                free_mem, idx = info.split(",")
                free_memories.append((int(free_mem), int(idx)))

            # 按剩余显存降序排列
            free_memories.sort(reverse=True, key=lambda x: x[0])

            if free_memories:
                return f"cuda:{free_memories[0][1]}"
            else:
                return "cpu"
        except Exception as e:
            logging.warning(f"获取空闲GPU失败，使用CPU：{e}")
            return "cpu"

    def __init__(self, model_path: Optional[str] = None, device: Optional[str] = None):
        self.model_path = model_path or self.DEFAULT_MODEL_PATH
        self.device = device or self._get_free_gpu()
        self.tokenizer = AutoTokenizer.from_pretrained(self.model_path)
        self.model = AutoModelForCausalLM.from_pretrained(
            self.model_path,
            torch_dtype=torch.float16 if "cuda" in self.device else torch.float32,
            low_cpu_mem_usage=True,
            trust_remote_code=True,
        ).to(self.device)
        self.model.eval()

        # 修正：使用单行字符串并转义花括号
        self.output_format = '{{"resume_id": "{resume_id}", "job_id": "{job_id}", "initial_score": null, "reason": "", "strengths": [], "weaknesses": [], "suggestions": []}}'

    def load_json(self, file_path: str) -> Dict[str, Any]:
        try:
            with open(file_path, "r", encoding="utf-8") as f:
                data = json.load(f)
                return data[0] if isinstance(data, list) else data
        except Exception as e:
            logging.debug(f"加载文件失败: {file_path}, 错误: {e}")
            return {}

    def generate_prompt(self, resume: Dict[str, Any], job: Dict[str, Any]) -> str:
        resume_id = resume.get("resume_id", "未知")
        job_id = job.get("job_id", "未知")

        # 提取关键信息并结构化展示
        job_skills = ", ".join(job.get("requirements", [])) + ", ".join(
            job.get("responsibilities", [])
        )
        resume_skills = ", ".join(resume.get("skills", []))

        # NOTE: 仅考虑最高学历?
        education_list = resume.get("education", [])
        education = education_list[0] if education_list else "未知"

        # TODO: 在 prompt 中加入具体的工作/项目经历
        experience = f"工作经验: {len(resume.get('work_experience', []))}段, 项目经验: {len(resume.get('project_experience', []))}段"

        # TODO: 加入城市、教育背景、语言能力的筛选条件，提前筛掉不符合硬性条件的候选人，避免
        #       直接调用 API

        # 构建强引导提示词
        prompt = f"""
        请根据以下信息评估求职者与岗位的匹配度：

        ### 岗位核心要求
        - 技能要求: {job_skills}
        - 学历要求: {job.get("education", "不限")}
        - 经验要求: {job.get("years_of_working", "不限")}年以上相关经验

        ### 求职者核心信息
        - 姓名: {resume.get("name", "未知")}
        - 学历: {education}
        - 技能: {resume_skills}
        - 求职状态: {resume.get("status", "未知")}
        - 经验: {experience}
        - 期望岗位: {resume.get("expectation", ["未知"])}

        ### 评估要求
        1. 匹配度评分（0-10分，需说明理由）
        2. 必须列出3-5项具体优势（基于岗位要求），格式为"具备XX能力/经验，能够XX"
        3. 必须列出3-5项具体劣势（基于岗位要求），格式为"缺乏XX能力/经验，无法满足XX要求"
        4. 针对劣势给出可行建议，格式为"建议XX，以提升XX能力"
        5. 严格遵循以下JSON格式（禁止使用模板中的占位符）：
        {self.output_format.format(resume_id=resume_id, job_id=job_id)}
        """
        return prompt.strip()

    def generate_response(self, prompt: str) -> str:
        inputs = self.tokenizer(
            prompt, return_tensors="pt", max_length=2048, truncation=True
        ).to(self.device)
        with torch.no_grad():
            outputs = self.model.generate(
                **inputs,
                max_new_tokens=1024,
                temperature=0.7,  # 调整温度以获得更稳定的输出
                top_p=0.95,
                num_return_sequences=1,
                # 强制结束符，避免生成多余内容
                eos_token_id=self.tokenizer.eos_token_id,
                pad_token_id=self.tokenizer.pad_token_id,
            )
        return self.tokenizer.decode(outputs[0], skip_special_tokens=True).strip()

    def extract_json_response(self, response: str) -> Dict[str, Any]:
        try:
            # 移除可能的自然语言前缀
            json_str = self._clean_json_string(response)
            return json.loads(json_str)
        except Exception:
            return self._enhanced_extract(response)

    def _clean_json_string(self, response: str) -> str:
        """清理AI生成文本中的非JSON部分"""
        # 查找JSON对象的开始和结束位置
        start_idx = response.find("{")
        end_idx = response.rfind("}")

        if start_idx == -1 or end_idx == -1:
            raise ValueError("未找到有效的JSON结构")

        return response[start_idx : end_idx + 1]

    def _enhanced_extract(self, response: str) -> Dict[str, Any]:
        """增强解析，处理非标准JSON格式"""
        try:
            # 提取核心字段
            score = self._extract_score(response)
            reason = self._extract_reason(response)
            strengths = self._extract_list(response, "strengths")
            weaknesses = self._extract_list(response, "weaknesses")
            suggestions = self._extract_list(response, "suggestions")

            # 获取简历和职位ID
            resume_id = re.search(r'"resume_id":\s*"([^"]+)"', response)
            job_id = re.search(r'"job_id":\s*"([^"]+)"', response)

            return {
                "resume_id": resume_id.group(1) if resume_id else "未知",
                "job_id": job_id.group(1) if job_id else "未知",
                "initial_score": score,
                "reason": reason,
                "strengths": strengths,
                "weaknesses": weaknesses,
                "suggestions": suggestions,
            }
        except Exception as e:
            logging.debug(f"增强解析失败: {e}")
            return {"error": "无法解析结果", "response": response[:500]}

    def _extract_score(self, response: str) -> float:
        """提取评分"""
        score_match = re.search(r'"initial_score":\s*(\d+\.?\d*)', response)
        if not score_match:
            score_match = re.search(r'"score":\s*(\d+\.?\d*)', response)

        return float(score_match.group(1)) if score_match else 0.0

    def _extract_reason(self, response: str) -> str:
        """提取原因"""
        reason_match = re.search(r'"reason":\s*"([^"]+)"', response)
        return reason_match.group(1) if reason_match else ""

    def _extract_list(self, response: str, field_name: str) -> list:
        """提取列表字段"""
        # 尝试匹配标准JSON数组
        list_match = re.search(
            rf'"{field_name}":\s*\[\s*([^\]]+)\s*\]', response, re.DOTALL
        )

        if list_match:
            items_text = list_match.group(1)
            # 简单的项分割，处理引号内的逗号
            items = []
            current_item = ""
            in_quote = False
            for char in items_text:
                if char == '"':
                    in_quote = not in_quote
                if char == "," and not in_quote:
                    items.append(current_item.strip())
                    current_item = ""
                else:
                    current_item += char
            if current_item:
                items.append(current_item.strip())

            # 清理引号和多余字符
            cleaned_items = []
            for item in items:
                # 处理对象格式的项
                if item.startswith("{") and item.endswith("}"):
                    # 提取description字段
                    desc_match = re.search(r'"description":\s*"([^"]+)"', item)
                    if desc_match:
                        cleaned_items.append(desc_match.group(1))
                else:
                    # 直接清理引号
                    cleaned_items.append(item.strip('" '))

            return cleaned_items

        return []

    def evaluate_match(
        self, resume: Dict[str, Any], job: Dict[str, Any]
    ) -> Dict[str, Any]:
        prompt = self.generate_prompt(resume, job)
        response = self.generate_response(prompt)
        return self.extract_json_response(response)

    def evaluate_from_files(self, resume_file: str, job_file: str) -> Dict[str, Any]:
        resume = self.load_json(resume_file)
        job = self.load_json(job_file)
        if not resume or not job:
            return {"error": "文件加载失败"}
        return self.evaluate_match(resume, job)

    def cleanup(self):
        """释放显存资源，适用于任务结束后调用"""
        del self.model
        del self.tokenizer
        torch.cuda.empty_cache()
