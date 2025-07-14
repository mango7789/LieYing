from prompt_templates import DEFAULT_PROMPT
import re
from typing import Dict, Any


def build_dimension_text(dimensions: Dict[str, Any]) -> str:
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
    dimension_text += (
        "- 综合评价：求职者年龄和学历匹配度较高，但量化交易经验有限，总体匹配度良好。\n"
    )
    dimension_text += "```\n\n"

    dimension_text += "请严格按照上述格式进行评分，确保包含所有维度和总分。"

    return dimension_text


def clean_text(text: str) -> str:
    text = re.sub(r"[^\w\s\u4e00-\u9fff(),.+-/:%\n]", " ", text)
    text = re.sub(r"[ \t]+", " ", text)
    return text.strip()


def format_nested_data(data, indent_level=0) -> str:
    indent = "  " * indent_level
    if isinstance(data, list):
        if not data:
            return f"{indent}[]"
        return "\n".join(
            [f"{indent}- {format_nested_data(item, indent_level+1)}" for item in data]
        )
    elif isinstance(data, dict):
        if not data:
            return f"{indent}{{}}"
        return "\n".join(
            [
                f"{indent}{k}: {format_nested_data(v, indent_level+1)}"
                for k, v in data.items()
            ]
        )
    else:
        return str(data)


def create_prompt(resume: Dict[str, Any], job: Dict[str, Any]) -> str:
    custom_dimensions = job.get("custom_dimensions", {})
    dimension_text = build_dimension_text(custom_dimensions)
    resume_text = "求职者简历：\n"
    key_sections = ["skills", "work_experience", "education", "project_experience"]

    for key in key_sections:
        if key in resume:
            resume_text += f"\n{key.upper()}：\n"
            resume_text += format_nested_data(resume[key], indent_level=1) + "\n"

    other_sections = [k for k in resume if k not in key_sections and k != "resume_id"]
    if other_sections:
        resume_text += "\n其他信息：\n"
        for key in other_sections:
            resume_text += f"- {key}：{clean_text(str(resume[key]))}\n"

    job_text = "岗位信息：\n"

    if "description" in job:
        job_text += "\n岗位职责与要求：\n"
        job_text += clean_text(str(job["description"])) + "\n"

    other_job_keys = [
        k for k in job if k not in ["id", "custom_dimensions", "description"]
    ]
    if other_job_keys:
        job_text += "\n其他岗位信息：\n"
        for key in other_job_keys:
            job_text += f"- {key}：{clean_text(str(job[key]))}\n"
    full_prompt = f"""
{DEFAULT_PROMPT}

{dimension_text}

{job_text}

{resume_text}
"""

    return full_prompt.strip()
