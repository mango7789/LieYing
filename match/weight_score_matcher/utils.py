import json
import os
from datetime import datetime
from typing import List, Dict, Any


def save_results(results: List[Dict[str, Any]], output_file: str) -> None:
    try:
        os.makedirs(os.path.dirname(output_file) or ".", exist_ok=True)
        with open(output_file, "w", encoding="utf-8") as f:
            json.dump(results, f, ensure_ascii=False, indent=2)
        print(f"✅ 结果已保存到 {output_file}")
    except Exception as e:
        print(f"❌ 结果保存失败: {str(e)}")


def print_result_summary(results: List[Dict[str, Any]], limit: int = 5) -> None:
    print("\n📊 部分匹配结果示例:")
    for match in results[:limit]:
        resume_id = match.get("resume_id", "未知简历ID")
        job_id = match.get("job_id", "未知岗位ID")
        category = match.get("category", "分类未知")

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
            f"💡 简历 {resume_id} 与岗位 {job_id} 得分: {score_str} | 分类: {category} | 推荐理由: {reason_short}"
        )


def setup_logging() -> str:
    log_dir = "logs"
    os.makedirs(log_dir, exist_ok=True)
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    log_path = os.path.join(log_dir, f"run_{timestamp}.log")
    return log_path
