import re
import os
import json
from typing import Dict, Any, List


def parse_assessment(
    output: str, resume: Dict[str, Any], job_id: Any, job_config: Dict[str, Any]
) -> Dict[str, Any]:
    result = {
        "resume_id": resume.get("resume_id", f"resume_{id(resume)}"),
        "job_id": job_id,
        "scores": {},
        "total_score": None,
        "max_total_score": None,
        "recommendation_reason": "",
        "dimension_reasons": {},
    }

    try:
        dimensions = extract_dimensions_from_config(job_config, job_config)
        if not dimensions:
            result["parse_error"] = "岗位配置中未找到有效维度"
            return result

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

        if "score" in model_output:
            try:
                result["total_score"] = int(model_output["score"])
                result["max_total_score"] = sum(
                    dim["weight"] for dim in dimensions.values()
                )
            except ValueError:
                result["parse_error"] += "总分格式错误；"

        reason_text = model_output.get("reason", "")
        resume_info = extract_resume_key_info(resume)

        for dim_id, dim_info in dimensions.items():
            dim_name = dim_info["name"]
            dim_category = dim_info["category"]
            weight = dim_info["weight"]
            criteria = dim_info["criteria"]

            score = None
            patterns = generate_dimension_patterns(dim_name)
            for pattern in patterns:
                match = pattern.search(reason_text)
                if match:
                    try:
                        score = int(match.group(1))
                        break
                    except (ValueError, IndexError):
                        continue

            if score is None:
                result["scores"][dim_name] = {
                    "score": None,
                    "max_score": weight,
                    "weight": weight,
                    "reason": f"未找到{dim_name}的得分",
                }
                continue

            dim_explanation = generate_dimension_explanation(
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

        result["recommendation_reason"] = generate_overall_reason(
            dimension_reasons=result["dimension_reasons"],
            total_score=result["total_score"],
            max_total_score=result["max_total_score"],
        )

    except Exception as e:
        result["parse_error"] = f"解析失败：{str(e)}"

    return result


def is_management_job(job: Dict[str, Any]) -> bool:
    title = job.get("title", "").lower()
    description = job.get("description", "").lower()
    management_keywords = ["管理", "总监", "经理", "vp", "主管", "负责人", "团队管理"]
    return any(kw in title or kw in description for kw in management_keywords)


def extract_dimensions_from_config(
    job_config: Dict[str, Any], job: Dict[str, Any]
) -> Dict[str, Dict[str, Any]]:
    dimensions = {}
    if "custom_dimensions" not in job_config:
        return dimensions

    for category, dimension_list in job_config["custom_dimensions"].items():
        for dim in dimension_list:
            apply_when = dim.get("apply_when", "")
            if apply_when == "管理岗" and not is_management_job(job):
                continue

            dim_id = f"{category}_{dim['name']}"
            dimensions[dim_id] = {
                "name": dim["name"],
                "weight": dim["weight"],
                "criteria": dim["criteria"],
                "category": category,
            }
    return dimensions


def extract_resume_key_info(resume: Dict[str, Any]) -> Dict[str, Any]:
    info = {}
    info_text = resume.get("information", "")
    age_match = re.search(r"(\d+)\s*岁", info_text)
    info["age"] = int(age_match.group(1)) if age_match else None

    education = resume.get("education", [])
    if education:
        edu_text = education[0] if isinstance(education[0], str) else str(education[0])
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

    info["work_experience"] = resume.get("work_experience", [])
    info["skills"] = resume.get("skills", [])

    team_sizes = []
    for exp in resume.get("work_experience", []):
        resp = exp.get("responsibilities", "")
        match = re.search(r"管理\s*(\d+)\s*人", resp) or re.search(
            r"带队\s*(\d+)\s*人", resp
        )
        if match:
            team_sizes.append(int(match.group(1)))
    info["team_sizes"] = team_sizes

    titles = [exp.get("job_name", "") for exp in resume.get("work_experience", [])]
    info["promotion_path"] = "→".join(titles)

    return info


def generate_dimension_explanation(
    dim_name: str,
    score: int,
    max_score: int,
    criteria: str,
    resume_info: Dict[str, Any],
) -> str:
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
        max_size = max(team_sizes)
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


def generate_overall_reason(
    dimension_reasons: Dict[str, str],
    total_score: int = None,
    max_total_score: int = None,
) -> str:
    if not dimension_reasons:
        return "未找到有效维度评估信息"
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

    detailed_reason = []
    for category, dim_reasons in category_groups.items():
        category_text = f"{category}方面：" + "；".join(dim_reasons) + "。"
        detailed_reason.append(category_text)

    overall_reason = "\n\n".join(detailed_reason)

    if total_score is not None and max_total_score is not None and max_total_score != 0:
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


def generate_dimension_patterns(dim_name: str) -> List[re.Pattern]:
    base_name = re.sub(r"\([^)]*\)", "", dim_name).strip()
    prefixes = ["", "维度", "评分", "得分"]
    suffixes = ["", "得分", "评分", "匹配度"]
    patterns = []
    for prefix in prefixes:
        for suffix in suffixes:
            full_name = f"{prefix}{base_name}{suffix}"
            if not full_name.strip():
                continue
            pattern = re.compile(
                rf"{full_name}\s*[:：\-=]?\s*(\d+)\s*分", re.IGNORECASE
            )
            patterns.append(pattern)
    return patterns
