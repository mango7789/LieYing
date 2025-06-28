import logging
from datetime import datetime
from resumes.models import Resume
from jobs.models import JobPosition
from .models import Matching, JobMatchTask
from .matcher import ResumeJobMatcher
from django.db import transaction

logger = logging.getLogger("match")
handler = logging.FileHandler("./logs/matcher.log", encoding="utf-8")
formatter = logging.Formatter("[%(asctime)s] %(levelname)s: %(message)s")
handler.setFormatter(formatter)
logger.setLevel(logging.INFO)
logger.addHandler(handler)


def run_resume_job_matching(job_id: int, overwrite_existing: bool = False) -> dict:
    # Use closure variable to cache the `matcher`
    if not hasattr(run_resume_job_matching, "_matcher"):
        run_resume_job_matching._matcher = ResumeJobMatcher()

    matcher = run_resume_job_matching._matcher

    resumes = Resume.objects.all()
    job = JobPosition.objects.all().filter(id=job_id).first()

    total_attempted = 0
    total_created = 0
    total_skipped = 0
    total_failed = 0

    for resume in resumes:
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


def run_matching_for_job(job_id: int, overwrite_existing=False):
    job = JobPosition.objects.get(id=job_id)
    task, created = JobMatchTask.objects.get_or_create(job=job)

    if task.status == "匹配中" and task.last_processed_resume_id:
        resumes = Resume.objects.filter(
            resume_id__gt=task.last_processed_resume_id
        ).order_by("resume_id")
    else:
        # 新任务
        with transaction.atomic():
            task.status = "匹配中"
            task.last_processed_resume_id = None
            task.save()
            for resume in resumes:
                Matching.objects.get_or_create(
                    resume=resume,
                    job=job,
                    defaults={
                        "score_source": "自动打分器",
                    },
                )

    if not hasattr(run_resume_job_matching, "_matcher"):
        run_resume_job_matching._matcher = ResumeJobMatcher()

    matcher = run_resume_job_matching._matcher

    matcher = ResumeJobMatcher()
    total = resumes.count()
    processed_count = 0
    failed_count = 0

    for resume in resumes:
        try:
            existing = Matching.objects.filter(resume=resume, job=job).first()
            if existing and not overwrite_existing:
                if (
                    resume.updated_at <= existing.updated_at
                    and job.updated_at <= existing.updated_at
                ):
                    continue

            existing.task_status = "匹配中"
            existing.save()

            result = matcher.evaluate_match(resume.to_json(), job.to_json())
            score = result.get("initial_score", None)

            with transaction.atomic():
                existing.score = score
                existing.score_source = "自动打分器"
                existing.status = "进入初筛" if score and score > 5 else "未过分数筛选"
                existing.task_status = "已完成" if score is not None else "匹配中"
                existing.save()

                task.last_processed_resume_id = resume.resume_id
                task.save()

            processed_count += 1
        except Exception as e:
            existing.task_status = "失败"
            existing.save()
            logger.error(f"匹配简历 {resume.resume_id} 出错：{e}")
            failed_count += 1

    # 匹配完毕
    task.status = "已完成"
    task.last_processed_resume_id = None
    task.save()

    logger.info(
        f"岗位 {job.name} 匹配完成，处理 {processed_count} 条，失败 {failed_count} 条，总共 {total} 条"
    )

    return {
        "total": total,
        "processed": processed_count,
        "failed": failed_count,
        "status": task.status,
    }
