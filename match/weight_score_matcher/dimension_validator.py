import json
from typing import Tuple, List, Dict, Any


def validate_dimension_config(
    custom_dimensions: Dict[str, Any]
) -> Tuple[bool, List[str]]:
    """验证岗位维度配置"""
    errors = []

    if not isinstance(custom_dimensions, dict):
        errors.append("custom_dimensions 必须是字典类型（键为类别，如'基础条件'）")
        return False, errors

    for category, dimension_list in custom_dimensions.items():
        if not isinstance(dimension_list, list):
            errors.append(
                f"类别 '{category}' 的值必须是列表（存储维度配置），当前类型：{type(dimension_list).__name__}"
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

            if "criteria" in dimension and not isinstance(dimension["criteria"], str):
                errors.append(
                    f"类别 '{category}' 的第 {dimension_index} 个维度的 'criteria' 必须是字符串，当前类型：{type(dimension['criteria']).__name__}"
                )

    return len(errors) == 0, errors


def validate_job_config(job: Dict[str, Any]) -> Tuple[bool, List[str]]:
    """验证单个岗位的完整配置"""
    errors = []
    job_id = job.get("id", "未知ID")

    if "custom_dimensions" not in job:
        return True, []

    custom_dimensions = job["custom_dimensions"]
    is_valid, dim_errors = validate_dimension_config(custom_dimensions)

    if not is_valid:
        errors = [f"岗位 {job_id} 的配置错误：{err}" for err in dim_errors]

    return is_valid, errors


def validate_job_file(
    file_path: str,
) -> Tuple[List[Dict[str, Any]], List[Dict[str, Any]]]:
    """加载并验证整个岗位配置文件"""
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            job_data = json.load(f)

        valid_jobs = []
        invalid_jobs = []

        for job in job_data:
            is_valid, errors = validate_job_config(job)
            if is_valid:
                valid_jobs.append(job)
            else:
                invalid_jobs.append({"job": job, "errors": errors})

        return valid_jobs, invalid_jobs

    except Exception as e:
        print(f"加载岗位配置文件出错：{str(e)}")
        return [], []
