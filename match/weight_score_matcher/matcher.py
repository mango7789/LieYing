import re
import os
import json
import time
import requests
from datetime import datetime
from typing import Dict, Any, List, Tuple
from tqdm import tqdm
from openai import OpenAI


class ResumeJobMatcher:
    def __init__(self):
        """初始化简历-岗位匹配器，加载配置和数据"""
        self._load_config()
        self.resume_data, self.valid_jobs = self._load_and_validate_data()
        self.client = OpenAI(
            api_key=self.DEEPSEEK_API_KEY, base_url=self.DEEPSEEK_API_URL
        )

    def _load_config(self) -> None:
        """加载配置参数"""
        self.DEEPSEEK_API_KEY = "sk-32b86dfd76b544c6b8272774ef0e1936"
        self.DEEPSEEK_API_URL = "https://dashscope.aliyuncs.com/compatible-mode/v1"
        self.API_TIMEOUT = 60
        self.BATCH_SIZE = 5
        self.MAX_SEQ_LENGTH = 4096
        self.OUTPUT_FILE = "match_scores_result_example.json"
        self.RESUME_PATH = "example_data/quant.json"
        self.JOB_PATH = "example_data/job_posting.json"

        os.environ.pop("HTTP_PROXY", None)
        os.environ.pop("HTTPS_PROXY", None)
        os.environ.pop("ALL_PROXY", None)

    def _load_and_validate_data(
        self,
    ) -> Tuple[List[Dict[str, Any]], List[Dict[str, Any]]]:
        """加载并验证简历和岗位数据"""
        resume_data = self._load_json(self.RESUME_PATH)
        valid_jobs, invalid_jobs = self._validate_job_file(self.JOB_PATH)

        print(
            f"共加载 {len(resume_data)} 份简历和 {len(valid_jobs) + len(invalid_jobs)} 个岗位"
        )
        if invalid_jobs:
            print(f"⚠️ 发现 {len(invalid_jobs)} 个无效岗位配置，将被忽略")
            for job_info in invalid_jobs:
                job_id = job_info["job"].get("id", "未知ID")
                print(f"  - 岗位 {job_id}:")
                for error in job_info["errors"]:
                    print(f"    - {error}")

        return resume_data, valid_jobs

    def _load_json(self, file_path: str) -> Any:
        """加载JSON文件"""
        try:
            with open(file_path, "r", encoding="utf-8") as f:
                return json.load(f)
        except FileNotFoundError:
            raise FileNotFoundError(f"数据文件不存在: {file_path}")
        except json.JSONDecodeError:
            raise ValueError(f"JSON解析错误: {file_path}")

    def _validate_dimension_config(
        self, custom_dimensions: Dict[str, Any]
    ) -> Tuple[bool, List[str]]:
        errors = []
        if not isinstance(custom_dimensions, dict):
            errors.append("custom_dimensions 必须是字典类型（键为类别，如'基础条件'）")
            return False, errors

        for category, dimension_list in custom_dimensions.items():
            if not isinstance(dimension_list, list):
                errors.append(
                    f"类别 '{category}' 的值必须是列表，当前类型：{type(dimension_list).__name__}"
                )
                continue

            for idx, dimension in enumerate(dimension_list):
                dimension_index = idx + 1
                if not isinstance(dimension, dict):
                    errors.append(
                        f"类别 '{category}' 的第 {dimension_index} 个维度必须是字典，当前类型：{type(dimension).__name__}"
                    )
                    continue

                required_fields = ["name", "weight", "criteria"]
                for field in required_fields:
                    if field not in dimension:
                        errors.append(
                            f"类别 '{category}' 的第 {dimension_index} 个维度缺少必要字段：'{field}'"
                        )

                if "weight" in dimension and not isinstance(
                    dimension["weight"], (int, float)
                ):
                    errors.append(
                        f"类别 '{category}' 的第 {dimension_index} 个维度的 'weight' 必须是数字，当前类型：{type(dimension['weight']).__name__}"
                    )

                if "name" in dimension and not isinstance(dimension["name"], str):
                    errors.append(
                        f"类别 '{category}' 的第 {dimension_index} 个维度的 'name' 必须是字符串，当前类型：{type(dimension['name']).__name__}"
                    )

                if "criteria" in dimension and not isinstance(
                    dimension["criteria"], str
                ):
                    errors.append(
                        f"类别 '{category}' 的第 {dimension_index} 个维度的 'criteria' 必须是字符串，当前类型：{type(dimension['criteria']).__name__}"
                    )

        return len(errors) == 0, errors

    def _validate_job_config(self, job: Dict[str, Any]) -> Tuple[bool, List[str]]:
        errors = []
        job_id = job.get("id", "未知ID")
        if "custom_dimensions" not in job:
            return True, []

        custom_dimensions = job["custom_dimensions"]
        is_valid, dim_errors = self._validate_dimension_config(custom_dimensions)
        if not is_valid:
            errors = [f"岗位 {job_id} 的配置错误：{err}" for err in dim_errors]

        return is_valid, errors

    def _validate_job_file(
        self, file_path: str
    ) -> Tuple[List[Dict[str, Any]], List[Dict[str, Any]]]:
        try:
            with open(file_path, "r", encoding="utf-8") as f:
                job_data = json.load(f)

            valid_jobs = []
            invalid_jobs = []
            for job in job_data:
                is_valid, errors = self._validate_job_config(job)
                if is_valid:
                    valid_jobs.append(job)
                else:
                    invalid_jobs.append({"job": job, "errors": errors})

            return valid_jobs, invalid_jobs
        except Exception as e:
            print(f"加载岗位配置文件出错：{str(e)}")
            return [], []

    def process_matches(self) -> List[Dict[str, Any]]:
        """处理所有简历-岗位匹配"""
        all_matches = []
        total_tasks = len(self.resume_data) * len(self.valid_jobs)
        print(f"总任务数: {total_tasks}")
        progress_bar = tqdm(total=total_tasks, desc="匹配进度")

        for resume in self.resume_data:
            if not isinstance(resume, dict):
                print(f"⚠️ 跳过无效简历（非字典类型）：{resume}")
                continue

            for job in self.valid_jobs:
                if not isinstance(job, dict):
                    print(f"⚠️ 跳过无效岗位（非字典类型）：{job}")
                    progress_bar.update(1)
                    continue

                result = self._process_single_match(resume, job)
                all_matches.append(result)
                progress_bar.update(1)

        progress_bar.close()
        self.save_results(all_matches)
        self.print_result_summary(all_matches)
        return all_matches

    def _process_single_match(
        self, resume: Dict[str, Any], job: Dict[str, Any]
    ) -> Dict[str, Any]:
        """处理单个简历-岗位匹配"""
        prompt = self._create_prompt(resume, job)
        time.sleep(0.5)
        output = self._call_api(prompt)
        return self._parse_assessment(output, resume, job)

    def _create_prompt(self, resume: Dict[str, Any], job: Dict[str, Any]) -> str:
        """生成匹配Prompt"""
        custom_dimensions = job.get("custom_dimensions", {})
        dimension_text = self._build_dimension_text(custom_dimensions)
        resume_text = self._format_resume_text(resume)
        job_text = self._format_job_text(job)

        default_prompt = """
你是专业的人力资源评估专家，必须严格按照以下要求评估简历与岗位的匹配度：

1. 评分要求：
   - 必须为岗位配置中的每个维度单独评分（如“年龄得分”“学历得分”等）
   - 每个维度的得分必须明确写出，格式为“维度名称：X分”（例如“年龄得分：3分；学历得分：4分”）
   - 总分必须等于各维度得分之和

2. 输出格式（必须严格遵守，只返回JSON，无其他内容）：
{
    "score": "总分（数字）",
    "reason": "所有维度得分（用分号分隔）；综合评价（简要说明匹配度）"
}

示例输出（必须包含所有维度）：
{
    "score": "28",
    "reason": "年龄得分：3分；性别得分：2分；学历得分：4分；院校背景加分：1分；专业得分：2分；综合评价：求职者学历和专业匹配度较高，年龄符合要求。"
}
    """.strip()

        full_prompt = f"""
{default_prompt}

{dimension_text}

{job_text}

{resume_text}
        """.strip()
        return full_prompt

    def _build_dimension_text(self, dimensions: Dict[str, Any]) -> str:
        """构建维度评分文本"""
        dimension_text = "请严格按照以下维度和权重进行评分：\n\n"
        total_weight = 0

        for category, dimension_list in dimensions.items():
            dimension_text += f"{category}：\n"
            for dimension in dimension_list:
                name = dimension["name"]
                weight = dimension["weight"]
                criteria = dimension["criteria"]
                dimension_text += f"• {name}（权重：{weight}分）：{criteria}\n"
                total_weight += weight
            dimension_text += "\n"

        dimension_text += f"总权重：{total_weight}分\n\n"
        dimension_text += (
            "请按照以下严格格式输出评分结果（示例仅供参考，必须根据实际情况评分）：\n"
        )
        dimension_text += "```\n"
        dimension_text += "匹配评分：\n"

        for category, dimension_list in dimensions.items():
            dimension_text += f"- {category}：\n"
            for dimension in dimension_list:
                name = dimension["name"]
                weight = dimension["weight"]
                dimension_text += (
                    f"  - {name}（{weight}分）：[得分]/[权重]，理由：[具体理由]\n"
                )

        dimension_text += "- 总分：[各维度得分之和]/[总权重]\n"
        dimension_text += "- 综合评价：[对匹配度的简要总结]\n"
        dimension_text += "```\n\n"
        dimension_text += "示例评分结果：\n"
        dimension_text += "```\n"
        dimension_text += "匹配评分：\n"
        dimension_text += "- 基础条件：\n"
        dimension_text += (
            "  - 年龄得分（10分）：8/10，理由：求职者29岁，符合28-31岁最佳区间\n"
        )
        dimension_text += "  - 学历得分（8分）：6/8，理由：求职者为硕士学历\n"
        dimension_text += "- 职业履历：\n"
        dimension_text += "  - 量化交易经验（25分）：15/25，理由：有回测系统开发经验，但无高频交易系统开发经验\n"
        dimension_text += "- 总分：29/43\n"
        dimension_text += "- 综合评价：求职者年龄和学历匹配度较高，但量化交易经验有限，总体匹配度良好。\n"
        dimension_text += "```\n\n"
        dimension_text += "请严格按照上述格式进行评分，确保包含所有维度和总分。"

        return dimension_text

    def _format_resume_text(self, resume: Dict[str, Any]) -> str:
        """格式化简历文本"""
        resume_text = "求职者简历：\n"
        key_sections = ["skills", "work_experience", "education", "project_experience"]

        for key in key_sections:
            if key in resume:
                resume_text += f"\n{key.upper()}：\n"
                resume_text += (
                    self._format_nested_data(resume[key], indent_level=1) + "\n"
                )

        other_sections = [
            k for k in resume if k not in key_sections and k != "resume_id"
        ]
        if other_sections:
            resume_text += "\n其他信息：\n"
            for key in other_sections:
                resume_text += f"- {key}：{self._clean_text(str(resume[key]))}\n"

        return resume_text

    def _format_job_text(self, job: Dict[str, Any]) -> str:
        """格式化岗位文本"""
        job_text = "岗位信息：\n"
        if "description" in job:
            job_text += "\n岗位职责与要求：\n"
            job_text += self._clean_text(str(job["description"])) + "\n"

        other_job_keys = [
            k for k in job if k not in ["id", "custom_dimensions", "description"]
        ]
        if other_job_keys:
            job_text += "\n其他岗位信息：\n"
            for key in other_job_keys:
                job_text += f"- {key}：{self._clean_text(str(job[key]))}\n"

        return job_text

    def _clean_text(self, text: str) -> str:
        """清理文本"""
        text = re.sub(r"[^\w\s\u4e00-\u9fff(),.+-/:%\n]", " ", text)
        text = re.sub(r"[ \t]+", " ", text)
        return text.strip()

    def _format_nested_data(self, data, indent_level=0) -> str:
        """格式化嵌套数据"""
        indent = "  " * indent_level
        if isinstance(data, list):
            if not data:
                return f"{indent}[]"
            return "\n".join(
                [
                    f"{indent}- {self._format_nested_data(item, indent_level+1)}"
                    for item in data
                ]
            )
        elif isinstance(data, dict):
            if not data:
                return f"{indent}{{}}"
            return "\n".join(
                [
                    f"{indent}{k}: {self._format_nested_data(v, indent_level+1)}"
                    for k, v in data.items()
                ]
            )
        else:
            return str(data)

    def _call_api(self, prompt: str) -> str:
        try:
            response = self.client.chat.completions.create(
                model="deepseek-r1-distill-llama-70b",
                messages=[{"role": "user", "content": prompt}],
                max_tokens=3000,
                temperature=0.1,
                top_p=0.8,
                frequency_penalty=0.2,
                presence_penalty=0.1,
            )
            return response.choices[0].message.content.strip()
        except Exception as e:
            print(f"API调用失败: {str(e)}")
            return f"ERROR: {str(e)}"

    def _parse_assessment(
        self, output: str, resume: Dict[str, Any], job: Dict[str, Any]
    ) -> Dict[str, Any]:
        result = {
            "resume_id": resume.get("resume_id", f"resume_{id(resume)}"),
            "job_id": job.get("id"),
            "scores": {},
            "total_score": None,
            "max_total_score": None,
            "recommendation_reason": "",
            "dimension_reasons": {},
        }

        try:
            dimensions = self._extract_dimensions_from_config(job)
            if not dimensions:
                result["parse_error"] = "岗位配置中未找到有效维度"
                return result

            # 提取模型输出的JSON
            json_match = re.search(r"(\{.*\})", output, re.DOTALL)
            if not json_match:
                result["parse_error"] = "未找到JSON格式输出"
                return result
            json_str = json_match.group(1)
            try:
                model_output = json.loads(json_str)
            except json.JSONDecodeError:
                result["parse_error"] = "JSON格式错误"
                return result

            # 提取总分
            if "score" in model_output:
                try:
                    result["total_score"] = int(model_output["score"])
                    result["max_total_score"] = sum(
                        dim["weight"] for dim in dimensions.values()
                    )
                except ValueError:
                    result["parse_error"] += "总分格式错误；"

            # 解析各维度得分
            reason_text = model_output.get("reason", "")
            resume_info = self._extract_resume_key_info(resume)

            for dim_id, dim_info in dimensions.items():
                dim_name = dim_info["name"]
                weight = dim_info["weight"]
                criteria = dim_info["criteria"]

                # 匹配维度得分
                score = None
                patterns = self._generate_dimension_patterns(dim_name)
                for pattern in patterns:
                    match = pattern.search(reason_text)
                    if match:
                        try:
                            score = int(match.group(1))
                            break
                        except (ValueError, IndexError):
                            continue

                if score is None:
                    reason_snippet = reason_text[:50]
                    result["scores"][dim_name] = {
                        "score": None,
                        "max_score": weight,
                        "reason": f"未找到{dim_name}的得分（模型输出片段：{reason_snippet}...）",
                    }
                    continue

                # 生成维度解释
                dim_explanation = self._generate_dimension_explanation(
                    dim_name=dim_name,
                    score=score,
                    max_score=weight,
                    criteria=criteria,
                    resume_info=resume_info,
                )

                result["scores"][dim_name] = {
                    "score": score,
                    "max_score": weight,
                    "reason": dim_explanation,
                }
                result["dimension_reasons"][dim_name] = dim_explanation

            # 生成总体推荐理由
            result["recommendation_reason"] = self._generate_overall_reason(
                dimension_reasons=result["dimension_reasons"],
                total_score=result["total_score"],
                max_total_score=result["max_total_score"],
            )

        except Exception as e:
            result["parse_error"] = f"解析失败：{str(e)}"

        return result

    def _extract_dimensions_from_config(
        self, job: Dict[str, Any]
    ) -> Dict[str, Dict[str, Any]]:
        """提取岗位维度配置"""
        dimensions = {}
        job_config = job
        if "custom_dimensions" not in job_config:
            return dimensions

        for category, dimension_list in job_config["custom_dimensions"].items():
            for dim in dimension_list:
                apply_when = dim.get("apply_when", "")
                if apply_when == "管理岗" and not self._is_management_job(job):
                    continue

                dim_id = f"{category}_{dim['name']}"
                dimensions[dim_id] = {
                    "name": dim["name"],
                    "weight": dim["weight"],
                    "criteria": dim["criteria"],
                    "category": category,
                }
        return dimensions

    def _is_management_job(self, job: Dict[str, Any]) -> bool:
        """判断是否为管理岗"""
        title = job.get("title", "").lower()
        description = job.get("description", "").lower()
        management_keywords = [
            "管理",
            "总监",
            "经理",
            "vp",
            "主管",
            "负责人",
            "团队管理",
        ]
        return any(kw in title or kw in description for kw in management_keywords)

    def _extract_resume_key_info(self, resume: Dict[str, Any]) -> Dict[str, Any]:
        """提取简历关键信息"""
        info = {}
        info_text = resume.get("information", "")
        age_match = re.search(r"(\d+)\s*岁", info_text)
        info["age"] = int(age_match.group(1)) if age_match else None

        # 提取学历
        education = resume.get("education", [])
        if education:
            edu_text = (
                education[0] if isinstance(education[0], str) else str(education[0])
            )
            if "博士" in edu_text:
                info["education"] = "博士"
            elif "硕士" in edu_text:
                info["education"] = "硕士"
            elif "本科" in edu_text:
                info["education"] = "本科"
            else:
                info["education"] = edu_text
        else:
            info["education"] = None

        # 提取工作经验和技能
        info["work_experience"] = resume.get("work_experience", [])
        info["skills"] = resume.get("skills", [])

        # 提取团队管理信息
        team_sizes = []
        for exp in info["work_experience"]:
            resp = exp.get("responsibilities", "")
            match = re.search(r"管理\s*(\d+)\s*人", resp) or re.search(
                r"带队\s*(\d+)\s*人", resp
            )
            if match:
                team_sizes.append(int(match.group(1)))
        info["team_sizes"] = team_sizes

        # 提取晋升趋势
        titles = [exp.get("job_name", "") for exp in info["work_experience"]]
        info["promotion_path"] = "→".join(titles)

        return info

    def _generate_dimension_explanation(
        self,
        dim_name: str,
        score: int,
        max_score: int,
        criteria: str,
        resume_info: Dict[str, Any],
    ) -> str:
        """生成维度得分解释"""
        if "年龄" in dim_name:
            age = resume_info.get("age")
            if age is None:
                return f"未明确年龄，根据评分标准（{criteria}）给出得分"
            return f"年龄{age}岁，{'' if score == max_score else '基本'}符合评分标准（{criteria}），故得{score}分"

        if "学历" in dim_name:
            edu = resume_info.get("education")
            if edu is None:
                return f"未明确学历，根据评分标准（{criteria}）给出得分"
            return f"学历为{edu}，{'' if score == max_score else '基本'}符合评分标准（{criteria}），故得{score}分"

        if "技术栈" in dim_name or "任职资格" in dim_name:
            skills = resume_info.get("skills", [])
            skills_str = ", ".join(skills) if skills else "未明确技能"
            return f"技能为{skills_str}，{'' if score == max_score else '部分'}符合评分标准（{criteria}），故得{score}分"

        if "团队管理" in dim_name:
            team_sizes = resume_info.get("team_sizes", [])
            if not team_sizes:
                return f"未明确团队管理规模，根据标准（{criteria}）得{score}分"
            max_size = max(team_sizes) if team_sizes else 0
            return f"最大管理团队规模为{max_size}人，{'' if score == max_score else '基本'}符合标准（{criteria}），得{score}分"

        if "晋升趋势" in dim_name:
            promotion_path = resume_info.get("promotion_path", "未知")
            return f"晋升路径为{promotion_path}，{'' if score == max_score else '部分'}符合标准（{criteria}），得{score}分"

        if "汇报对象" in dim_name:
            has_boss = any(
                "对接老板" in exp.get("responsibilities", "")
                for exp in resume_info.get("work_experience", [])
            )
            reason = "有对接老板经历" if has_boss else "无明确高层对接经历"
            return f"{reason}，{'' if score == max_score else '基本'}符合标准（{criteria}），得{score}分"

        return f"根据评分标准（{criteria}）和简历情况，综合评估得{score}分"

    def _generate_overall_reason(
        self,
        dimension_reasons: Dict[str, str],
        total_score: int = None,
        max_total_score: int = None,
    ) -> str:
        """生成总体推荐理由"""
        if not dimension_reasons:
            return "未找到有效维度评估信息"

        # 按类别分组
        category_groups = {}
        for dim_name, reason in dimension_reasons.items():
            category = ""
            if (
                "年龄" in dim_name
                or "学历" in dim_name
                or "专业" in dim_name
                or "性别" in dim_name
                or "院校" in dim_name
            ):
                category = "基础条件"
            elif (
                "岗位" in dim_name
                or "任职资格" in dim_name
                or "平台" in dim_name
                or "公司" in dim_name
            ):
                category = "职业履历"
            elif "素质" in dim_name or "稳定性" in dim_name:
                category = "能力素质"
            else:
                category = "其他"

            reason_no_score = re.sub(r"，故得\d+分", "", reason)
            if category not in category_groups:
                category_groups[category] = []
            category_groups[category].append(f"{dim_name}：{reason_no_score}")

        # 构建详细理由
        detailed_reason = []
        for category, dim_reasons in category_groups.items():
            category_text = f"{category}方面：" + "；".join(dim_reasons) + "。"
            detailed_reason.append(category_text)

        overall_reason = "\n\n".join(detailed_reason)

        # 添加总分结论
        if (
            total_score is not None
            and max_total_score is not None
            and max_total_score != 0
        ):
            try:
                match_rate = total_score / max_total_score
                if match_rate >= 0.8:
                    overall_reason += "\n\n总体而言，求职者在各方面表现出色，与岗位要求高度匹配，推荐优先考虑。"
                elif match_rate >= 0.6:
                    overall_reason += "\n\n总体而言，求职者基本满足岗位要求，部分维度有提升空间，可进一步沟通。"
                else:
                    overall_reason += (
                        "\n\n总体而言，求职者与岗位要求存在一定差距，需谨慎评估。"
                    )
            except (TypeError, ZeroDivisionError):
                overall_reason += "\n\n总体评估完成，未明确匹配度等级。"
        else:
            overall_reason += "\n\n总体评估完成，未获取有效总分信息。"

        return overall_reason

    def _generate_dimension_patterns(self, dim_name: str) -> List[re.Pattern]:
        """生成维度得分匹配模式"""
        base_name = re.sub(r"\([^)]*\)", "", dim_name).strip()
        patterns = [
            re.compile(rf"{base_name}\s*[:：=]\s*(\d+)\s*分?", re.IGNORECASE),
            re.compile(rf"{base_name}\s*[是为]\s*(\d+)\s*分?", re.IGNORECASE),
            re.compile(rf"{base_name}\s+(\d+)\s*分?", re.IGNORECASE),
            re.compile(rf"(\d+)\s*分?\s*\(\s*{base_name}\s*\)", re.IGNORECASE),
        ]
        return patterns

    def save_results(self, results: List[Dict[str, Any]]) -> None:
        """保存匹配结果"""
        try:
            os.makedirs(os.path.dirname(self.OUTPUT_FILE) or ".", exist_ok=True)
            with open(self.OUTPUT_FILE, "w", encoding="utf-8") as f:
                json.dump(results, f, ensure_ascii=False, indent=2)
            print(f"✅ 结果已保存到 {self.OUTPUT_FILE}")
        except Exception as e:
            print(f"❌ 结果保存失败: {str(e)}")

    def print_result_summary(
        self, results: List[Dict[str, Any]], limit: int = 5
    ) -> None:
        """打印结果摘要"""
        print("\n📊 部分匹配结果示例:")
        for match in results[:limit]:
            resume_id = match.get("resume_id", "未知简历ID")
            job_id = match.get("job_id", "未知岗位ID")

            if match.get("parse_error"):
                print(
                    f"❌ 简历 {resume_id} 与岗位 {job_id} (解析错误): {match['parse_error'][:100]}"
                )
                continue

            total_score = match.get("total_score")
            max_total = match.get("max_total_score")
            score_str = (
                f"{total_score}/{max_total}"
                if (total_score is not None and max_total is not None)
                else "无法解析分数"
            )

            reason = match.get("recommendation_reason", "无推荐理由")
            reason_short = reason[:50] + "..." if len(reason) > 50 else reason

            print(
                f"💡 简历 {resume_id} 与岗位 {job_id} 得分: {score_str} | 推荐理由: {reason_short}"
            )

    def setup_logging(self) -> str:
        """设置日志路径"""
        log_dir = "logs"
        os.makedirs(log_dir, exist_ok=True)
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        log_path = os.path.join(log_dir, f"run_{timestamp}.log")
        return log_path


# 运行示例
if __name__ == "__main__":
    matcher = ResumeJobMatcher()
    matcher.process_matches()
