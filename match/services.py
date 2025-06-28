import logging
from datetime import datetime
from resumes.models import Resume
from jobs.models import JobPosition
from .models import Matching
from .matcher import ResumeJobMatcher

logger = logging.getLogger("match")
handler = logging.FileHandler("./match/matcher.log", encoding="utf-8")
formatter = logging.Formatter("[%(asctime)s] %(levelname)s: %(message)s")
handler.setFormatter(formatter)
logger.setLevel(logging.INFO)
logger.addHandler(handler)


def run_resume_job_matching(overwrite_existing: bool = False) -> dict:
    # Use closure variable to cache the `matcher`
    if not hasattr(run_resume_job_matching, "_matcher"):
        run_resume_job_matching._matcher = ResumeJobMatcher()

    matcher = run_resume_job_matching._matcher

    resumes = Resume.objects.all()
    jobs = JobPosition.objects.all()

    total_attempted = 0
    total_created = 0
    total_skipped = 0
    total_failed = 0

    for resume in resumes:
        for job in jobs:
            total_attempted += 1

            try:
                existing = Matching.objects.filter(resume=resume, job=job).first()
                if existing and not overwrite_existing:
                    if (
                        resume.updated_at <= existing.updated_at
                        and job.updated_at <= existing.updated_at
                    ):
                        total_skipped += 1
                        continue

                resume_data = resume.to_json()
                job_data = job.to_json()
                result = matcher.evaluate_match(resume_data, job_data)

                if "error" not in result:
                    if not existing:
                        Matching.objects.create(
                            resume=resume,
                            job=job,
                            score=result.get("initial_score", 0),
                            score_source="自动打分器",
                            status=(
                                "进入初筛"
                                if result.get("initial_score", 0) > 5
                                else "未过分数筛选"
                            ),
                        )
                        total_created += 1
                    else:
                        # 可选：如果你想更新已有项
                        existing.score = result.get("initial_score", 0)
                        existing.score_source = "自动打分器"
                        existing.status = (
                            "进入初筛"
                            if result.get("initial_score", 0) > 5
                            else "未过分数筛选"
                        )
                        existing.save()
                        total_created += 1
                else:
                    total_failed += 1
                    logger.warning(
                        f"匹配失败：{resume.resume_id} - {job.name}，错误：{result.get('error')}"
                    )

            except Exception as e:
                total_failed += 1
                logger.exception(f"匹配异常：{resume.resume_id} - {job.name}：{e}")

    summary = {
        "time": datetime.now().isoformat(),
        "attempted": total_attempted,
        "created_or_updated": total_created,
        "skipped": total_skipped,
        "failed": total_failed,
    }

    logger.info(f"打分完成：{summary}")
    return summary
