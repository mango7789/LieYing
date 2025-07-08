import re
import json
import logging
import subprocess
from typing import Dict, Any, Optional
from django.conf import settings

try:
    import torch  # type: ignore
    from transformers import AutoTokenizer, AutoModelForCausalLM  # type: ignore
except ImportError:
    pass


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

    def _load_model(self):
        if not self._loaded:
            logging.info(f"加载匹配模型（设备：{self.device}）")
            self.tokenizer = AutoTokenizer.from_pretrained(self.model_path)
            self.model = AutoModelForCausalLM.from_pretrained(
                self.model_path,
                torch_dtype=torch.float16 if "cuda" in self.device else torch.float32,
                low_cpu_mem_usage=True,
                trust_remote_code=True,
            ).to(self.device)
            self.model.eval()
            self._loaded = True

    def __init__(self, model_path: Optional[str] = None, device: Optional[str] = None):
        self.model_path = model_path or self.DEFAULT_MODEL_PATH
        self.device = device or self._get_free_gpu()
        self.model = None
        self.tokenizer = None
        self._loaded = False

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
        work_exps = resume.get("working_experiences", [])
        project_exps = resume.get("project_experiences", [])
        work_desc = ""
        for exp in work_exps:
            company = exp.get("company", "未知公司")
            job_name = exp.get("job_name", "未知职位")
            period = exp.get("employment_period", "")
            desc = exp.get("职责业绩", "").strip().replace("\n", "；")
            work_desc += f"- {period} 在 {company} 担任 {job_name}，主要职责：{desc}\n"
        proj_desc = ""
        for proj in project_exps:
            name = proj.get("project_name", "未知项目")
            company = proj.get("所在公司", "未知公司")
            role = proj.get("项目职务", "")
            period = proj.get("employment_period", "")
            desc = proj.get("项目描述", "").strip().replace("\n", "；")
            proj_desc += f"- {period} 在 {company} 参与项目《{name}》担任{role}，项目描述：{desc}\n"

        experience = (
            f"工作经验: {len(work_exps)}段\n"
            f"{work_desc.strip()}\n"
            f"项目经验: {len(project_exps)}段\n"
            f"{proj_desc.strip()}"
        )

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
        self._load_model()
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
        # self.cleanup()
        return self.extract_json_response(response)

    def evaluate_from_files(self, resume_file: str, job_file: str) -> Dict[str, Any]:
        resume = self.load_json(resume_file)
        job = self.load_json(job_file)
        if not resume or not job:
            return {"error": "文件加载失败"}
        return self.evaluate_match(resume, job)

    def cleanup(self):
        """释放显存资源，适用于任务结束后调用"""
        if self.model:
            del self.model
        if self.tokenizer:
            del self.tokenizer
        self.model = None
        self.tokenizer = None
        self._loaded = False
        torch.cuda.empty_cache()


# 测试样例
def testmatcher():
    matcher = ResumeJobMatcher()

    # 示例岗位
    job = {
        "job_id": "job_12345",
        "requirements": ["SQL", "机器学习", "数据分析"],
        "responsibilities": ["构建推荐系统", "分析用户行为"],
        "education": "硕士",
        "years_of_working": 3,
        "city": "上海",
        "languages": ["英语"],
    }

    # 示例简历
    resume = {
        "resume_id": "8be599659cV971a5d7b4b10",
        "name": "方**",
        "age": 29,
        "gender": "男",
        "city": "上海",
        "status": "在职，急寻新工作",
        "education_level": "硕士",
        "education": ["硕士"],
        "work_years": "6年",
        "work_years_num": 6,
        "company_name": "Coupang",
        "position": "数据科学经理，搜索与推荐",
        "skills": ["sql", "咨询", "人工智能", "机器学习", "数据分析"],
        "expected_positions": [
            {"position": "产品经理", "location": "上海", "salary": "55-60k×15薪"}
        ],
        "self_evaluation": [
            "1. 互联网国际化出海行业及外企咨询背景，具备跨国团队协作与团队管理能力。",
            "2. 7年数据科学与管理咨询工作经验，在搜索推荐、用户增长、金融科技成功推动多个项目并取得显著成果。",
            "3. 在ToB企业服务领域有丰富的AI解决方案交付经验，领导从需求诊断、模型开发到客户关系维护的全周期管理。",
        ],
        "working_experiences": [
            {
                "company": "Coupang",
                "job_name": "数据科学经理，搜索与推荐",
                "employment_period": "（2024.03 - 至今, 1年3个月）",
                "职责业绩": "挖掘召回、相关性、排序模块的增量机会，为优化用户搜索体验提供数据洞察和落地建议，推动转化率提升30+%，线上相关性指标提升11+%。主导LLM相关性大模型的数据标注-抽样-评估的闭环流程设计和实施，提升训练数据质量，模型准确率提升10%，降低标注评估人力成本50%。开发搜索指标度量体系，主导70+ A/B实验的设计-多维分析-归因全流程管理，支持80%策略迭代决策，并推动建设实验分析SOP，降低人为误差10%。搭建搜索冷启动的指标体系、流量扶持和退出机制，通过动态流量控制和退出阈值计算（CTR/转化率预估），实现商品曝光效率提升15%，流量损耗降低20%。",
            },
            {
                "company": "Coupang",
                "job_name": "数据科学经理",
                "employment_period": "（2024.03 - 至今, 1年3个月）",
                "职责业绩": "- 负责搜索召回、相关性和排序模块策略分析\n- 跨团队合作优化流量分配机制和产品供给\n- LLM大模型数据标注和评估流程优化\n- 搜索产品指标体系设计及开发\n- AB实验方案设计和分析",
            },
            {
                "company": "字节跳动",
                "job_name": "数据科学家",
                "employment_period": "（2022.04 - 至今, 3年2个月）",
                "职责业绩": "负责Tiktok国际化电商搜索推荐产品和策略分析，搜索体验和治理，搜索供给和生态。",
            },
            {
                "company": "字节跳动",
                "job_name": "数据科学家，TikTok电商数据科学",
                "employment_period": "（2022.04 - 2024.02, 1年10个月）",
                "职责业绩": "领导国际化电商搜索生态和流量机制优化产品分析。通过用户行为分析、数据源探索和特征工程等分析手段，增加召回支路并优化排序模型，将搜索转化率opms提升6%。建设搜索词缺货识别和分级模型，提高了缺货商品的识别准确度和招商效率，将搜索缺货曝光占比降低5%。利用因果推断论证用户体验的表征指标和特征重要性，使用多因子模拟方法设计治理规则，将搜索差评率降低17%。建设搜索核心指标监控体系，开发数据看板和异动归因工具，有效支持业务团队进行问题分析和快速决策。",
            },
            {
                "company": "Opera Solutions",
                "job_name": "分析主管，数据科学",
                "employment_period": "（2018.08 - 2022.04, 3年8个月）",
                "职责业绩": "带领4人团队为FinTech、零售等世界500强企业提供端到端的AI解决方案，为客户增加千万级别的利润增长。领导大数据开发和机器学习建模平台的功能开发，并打造标准化的行业解决方案，推动与阿里云的战略合作。搭建信用卡APP用户行为模型，利用个性化推荐技术优化推荐功能，营销活动响应率提升3倍，激活10%的睡眠客户。为某国有四大行信用卡中心提供数字化转型咨询服务，针对数据管理、营销、风控和客服制定三年实施路线图。为欧洲电影院线开发票房预测模型，支持影院经理一键生成排片，为客户创造超过400万英镑的利润。",
            },
        ],
        "project_experiences": [
            {
                "project_name": "搜索推荐流量策略优化",
                "所在公司": "字节跳动",
                "employment_period": "（2023.05 - 至今）",
                "项目职务": "数据科学家",
                "项目描述": "1. 流量效率优化：通过用户行为分析、数据源探索和特征工程等分析手段，增加召回支路并优化排序模型，将搜索opms提升6%。2. 商品供给和成长方向：挖掘商品冷启动流量扶持的提升机会点，优化商品准入、流量分配和退出机制，将北极星指标提升7%。建设搜索词缺货识别和分级模型，提高了缺货商品的识别准确度和招商效率，将搜索缺货pv占比降低5%。3. 用户体验：利用因果推断论证用户体验的表征指标和特征重要性，使用多因子模拟方法设计治理规则，将搜索差评率降低17%。",
            },
            {
                "project_name": "搜索数据基建和产品分析",
                "所在公司": "字节跳动",
                "employment_period": "（2023.05 - 至今）",
                "项目职务": "数据科学家",
                "项目描述": "建设搜索核心指标监控体系，开发数据看板和异动归因工具，有效支持业务团队进行问题分析和快速决策。设计AB实验并分析实验结果，论证产品功能和算法策略的有效性。",
            },
        ],
        "languages": ["中文", "英语"],
    }

    matcher.generate_prompt(resume, job)
    # 执行匹配评估
    # result = matcher.evaluate_match(resume, job)
    # print(json.dumps(result, ensure_ascii=False, indent=2))
