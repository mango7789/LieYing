import json
from dimension_validator import validate_job_file


def load_json(file_path):
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            return json.load(f)
    except FileNotFoundError:
        raise FileNotFoundError(f"数据文件不存在: {file_path}")
    except json.JSONDecodeError:
        raise ValueError(f"JSON解析错误: {file_path}")


def load_resume_and_job_data(resume_path, job_path):
    resume_data = load_json(resume_path)
    valid_jobs, invalid_jobs = validate_job_file(job_path)
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
