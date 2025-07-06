import ast
import logging
from django.shortcuts import render, redirect, get_object_or_404
from django.db.models import Count, Max, Q
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.http import JsonResponse
from django.views.decorators.http import require_POST, require_GET
from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger
from django.utils import timezone

from .models import JobPosition, UserScore
from .forms import JobForm
from .constants import CITY_CHOICES, EDUCATION_CHOICES, WORK_EXPERIENCE_CHOICES
from match.models import Matching, JobMatchTask
from match.services import async_run_matching_for_job
from resumes.models import Resume


###########################################################
#                         List                            #
###########################################################


@login_required
def company_list(request):
    company_jobs = JobPosition.objects.order_by("-created_at").values(
        "company", "id", "name", "created_at"
    )

    company_dict = {}
    for job in company_jobs:
        company = job["company"]
        if company not in company_dict:
            company_dict[company] = {
                "company": company,
                "job_count": 0,
                "latest_created": job["created_at"],
                "jobs": [],
            }
        if len(company_dict[company]["jobs"]) < 3:
            company_dict[company]["jobs"].append(job)

        company_dict[company]["job_count"] += 1
        company_dict[company]["latest_created"] = max(
            company_dict[company]["latest_created"], job["created_at"]
        )

        task_status, processing, total = get_job_match_status(job["id"])
        job["task_status"] = task_status
        # job["processing"] = processing
        # job["total"] = total
        job["percent"] = round(processing / total * 100, 2)

    companies = list(company_dict.values())
    return render(request, "jobs/company_list.html", {"companies": companies})


# TODO: 可以自定义配置打分权重
@login_required
def job_list(request, company):
    # 获取指定公司的所有职位
    jobs = JobPosition.objects.filter(company=company).order_by("-created_at")

    # 添加匹配状态逻辑
    # TODO: 对匹配中的岗位增加匹配进度的展示
    for job in jobs:
        task_status, processing, total = get_job_match_status(job.id)
        job.task_status = task_status
        job.processing = processing
        job.total = total
        job.percent = round(job.processing / job.total * 100, 2)

    return render(request, "jobs/job_list.html", {"jobs": jobs, "company": company})


def get_job_matching_summary(job_id):
    return Matching.objects.filter(job_id=job_id).aggregate(
        total=Count("id"),
        completed=Count("id", filter=Q(task_status="已完成")),
        processing=Count("id", filter=Q(task_status="匹配中")),
        failed=Count("id", filter=Q(task_status="失败")),
    )


def get_job_match_status(job_id):
    """
    获取职位的匹配状态
    TODO: 需要与match模块集成，查询实际的匹配状态
    """
    # 这里应该查询match模块的数据库表
    # 暂时返回模拟状态
    summary = get_job_matching_summary(job_id)
    if summary["completed"] == 0 and summary["processing"] == 0:
        if summary["failed"] == 0:
            status = "未开始"
        else:
            status = "失败"
    elif summary["processing"] > 0:
        status = "匹配中"
    elif summary["processing"] == 0:
        status = "已完成"
    else:
        status = "失败"

    # logging.debug(summary)
    # return status
    return status, summary["completed"], summary["total"]


@login_required
def match_status_api(request, company):
    """
    Used for providing match status(progress bar) for jobs within a given company.
    """
    jobs = JobPosition.objects.filter(company=company).values("id")
    data = []

    for job in jobs:
        task_status, processing, total = get_job_match_status(job["id"])
        task = JobMatchTask.objects.get(job_id=job["id"])
        now = timezone.now()
        delta_seconds = (now - task.updated_at).total_seconds()
        progress_fraction = min(delta_seconds / 30, 1)  # 30s 一个匹配

        percent = (
            round((processing + progress_fraction) * 100 / total, 2) if total else 0
        )
        data.append(
            {
                "id": job["id"],
                "status": task_status,
                "processing": processing,
                "total": total,
                "percent": percent,
            }
        )

    return JsonResponse({"jobs": data})


def safe_parse_list_str(s):
    if not s:
        return []
    if isinstance(s, list):
        return s
    try:
        return ast.literal_eval(s)
    except Exception:
        return []


@login_required
def get_matching_report(request, matching_id):
    # matching_id = request.GET.get("matching_id")
    try:
        matching = Matching.objects.get(id=matching_id)
        strengths = safe_parse_list_str(matching.strengths)
        weaknesses = safe_parse_list_str(matching.weaknesses)
        suggestions = safe_parse_list_str(matching.suggestions)
        return JsonResponse(
            {
                "reason": matching.reason,
                "strengths": strengths,
                "weaknesses": weaknesses,
                "suggestions": suggestions,
            }
        )
    except Matching.DoesNotExist:
        return JsonResponse({"error": "匹配记录不存在"}, status=404)


###########################################################
#                   Create/Update/Delete                  #
###########################################################


# TODO: 增加岗位负责人信息
@login_required
def job_create_general(request):
    """Floor1的通用新增岗位视图"""
    if request.method == "POST":
        print("POST数据:", request.POST)  # 调试信息
        form = JobForm(request.POST)
        print("表单是否有效:", form.is_valid())  # 调试信息
        if form.is_valid():
            try:
                job = form.save(commit=False)
                job.owner = request.user
                job.save()
                print("保存成功，职位ID:", job.id)  # 调试信息
                messages.success(request, "职位添加成功！")
                return redirect("jobs:company_list")
            except Exception as e:
                print("保存失败:", str(e))  # 调试信息
                messages.error(request, f"保存失败：{str(e)}")
        else:
            print("表单错误:", form.errors)  # 调试信息
            # 显示表单错误
            for field, errors in form.errors.items():
                for error in errors:
                    messages.error(request, f"{field}: {error}")
    else:
        form = JobForm()

    return render(
        request,
        "jobs/job_form_general.html",
        {
            "form": form,
            "company": None,
            "city_choices": CITY_CHOICES,
            "education_choices": EDUCATION_CHOICES,
            "work_experience_choices": WORK_EXPERIENCE_CHOICES,
        },
    )


@login_required
def job_create(request, company):
    """Floor2的指定公司新增岗位视图"""
    if request.method == "POST":
        form = JobForm(request.POST)
        if form.is_valid():
            try:
                job = form.save(commit=False)
                job.company = company  # 强制使用URL中的公司名
                job.owner = request.user
                job.save()
                messages.success(request, "职位添加成功！")
                return redirect("jobs:job_list", company=company)
            except Exception as e:
                messages.error(request, f"保存失败：{str(e)}")
        else:
            # 显示表单错误
            for field, errors in form.errors.items():
                for error in errors:
                    messages.error(request, f"{field}: {error}")
    else:
        form = JobForm(initial={"company": company})

    return render(
        request,
        "jobs/job_form.html",
        {
            "form": form,
            "company": company,
            "city_choices": CITY_CHOICES,
            "education_choices": EDUCATION_CHOICES,
            "work_experience_choices": WORK_EXPERIENCE_CHOICES,
        },
    )


@login_required
def job_update(request, pk):
    job = get_object_or_404(JobPosition, pk=pk)

    if request.method == "POST":
        form = JobForm(request.POST, instance=job)
        if form.is_valid():
            try:
                job = form.save(commit=False)
                job.owner = request.user
                job.save()
                messages.success(request, "职位信息更新成功！")
                return redirect("jobs:job_list", company=job.company)
            except Exception as e:
                messages.error(request, f"更新失败：{str(e)}")
        else:
            # 显示表单错误
            for field, errors in form.errors.items():
                for error in errors:
                    messages.error(request, f"{field}: {error}")
    else:
        form = JobForm(instance=job)

    return render(
        request,
        "jobs/job_form.html",
        {
            "form": form,
            "company": job.company,
            "city_choices": CITY_CHOICES,
            "education_choices": EDUCATION_CHOICES,
            "work_experience_choices": WORK_EXPERIENCE_CHOICES,
        },
    )


@login_required
@require_POST
def job_delete(request, pk):
    job = get_object_or_404(JobPosition, pk=pk)

    if request.method == "POST":
        company = job.company
        job_name = job.name
        job.delete()
        messages.success(request, f'职位"{job_name}"已成功删除！')
        return redirect("jobs:job_list", company=company)

    return render(request, "jobs/job_confirm_delete.html", {"job": job})


###########################################################
#                         Match                           #
###########################################################


@login_required
@require_POST
def start_matching(request, job_id):
    """开始匹配功能，直接处理POST请求启动任务"""
    job = get_object_or_404(JobPosition, pk=job_id)

    try:
        async_run_matching_for_job.delay(job_id)
        messages.success(request, f'岗位"{job.name}"匹配任务已启动。')
    except Exception as e:
        messages.error(request, f"启动匹配失败：{str(e)}")

    return redirect("jobs:job_list", company=job.company)


@login_required
def match_result(request, job_id):
    """查看匹配结果"""
    job = get_object_or_404(JobPosition, pk=job_id)

    try:
        matchings = Matching.objects.select_related("resume").filter(
            job=job, task_status="已完成"
        )

        resumes_data = []

        for m in matchings:
            resume = m.resume
            # 获取最新用户评分
            latest_user_score = (
                UserScore.objects.filter(job=m.job, resume=resume)
                .select_related("user")
                .order_by("-created_at")
                .first()
            )

            # 分数显示逻辑：优先用户评分，没有时显示机器评分
            if latest_user_score:
                display_score = latest_user_score.user_match_score
                score_source = latest_user_score.user.username
                score_source_type = "user"
            else:
                display_score = m.score
                score_source = "系统"
                score_source_type = "system"

            resumes_data.append(
                {
                    "resume_id": resume.resume_id,
                    "name": resume.name,
                    "match_score": round(display_score, 1) if display_score else None,
                    "match_score_percent": (
                        round((display_score or 0) * 10, 1) if display_score else 0
                    ),
                    "score_source": score_source,
                    "score_source_type": score_source_type,
                    "machine_score": m.score,  # 机器评分，用于历史记录
                    "user_score_count": UserScore.objects.filter(
                        job=m.job, resume=resume
                    ).count(),
                    "matching_id": m.id,
                    "status": resume.status,
                    "match_status": m.status,
                    "current_company": resume.company_name,
                    "current_position": resume.position,
                    "gender": resume.gender,
                    "age": resume.age,
                    "education_level": resume.education_level,
                    "work_years": resume.work_years,
                    "city": resume.city,
                    "project_experience": getattr(resume, "project_experiences", []),
                    "work_experience": getattr(resume, "working_experiences", []),
                }
            )

        # 按最新显示分数排序（降序）
        resumes_data.sort(key=lambda x: x["match_score"] or 0, reverse=True)

        # 分页逻辑
        paginator = Paginator(resumes_data, 8)
        page = request.GET.get("page")
        try:
            page_obj = paginator.page(page)
        except PageNotAnInteger:
            page_obj = paginator.page(1)
        except EmptyPage:
            page_obj = paginator.page(paginator.num_pages)

    except Exception as e:
        messages.error(request, f"获取匹配结果失败：{str(e)}")
        page_obj = []

    if request.headers.get("x-requested-with") == "XMLHttpRequest":
        return render(
            request, "jobs/match_result_table.html", {"page_obj": page_obj, "job": job}
        )
    else:
        return render(
            request, "jobs/match_result.html", {"job": job, "page_obj": page_obj}
        )


@login_required
@require_POST
def update_match_score(request):
    """更新匹配分数和分数来源"""
    matching_id = request.POST.get("matching_id")
    new_score = request.POST.get("score")
    try:
        matching = Matching.objects.get(id=matching_id)
        matching.score = float(new_score)
        matching.score_source = request.user.username
        matching.save()
        return JsonResponse(
            {
                "success": True,
                "score": matching.score,
                "score_source": matching.score_source,
            }
        )
    except Exception as e:
        return JsonResponse({"success": False, "error": str(e)})


@login_required
@require_GET
def get_user_score_history(request):
    """获取某岗位-简历的所有评分记录（包含机器评分和用户评分）"""
    job_id = request.GET.get("job_id")
    resume_id = request.GET.get("resume_id")

    # 获取机器评分
    try:
        machine_matching = Matching.objects.get(job_id=job_id, resume_id=resume_id)
        machine_score = machine_matching.score
        machine_scored_at = machine_matching.scored_at
    except Matching.DoesNotExist:
        machine_score = None
        machine_scored_at = None

    # 获取用户评分历史
    user_scores = (
        UserScore.objects.filter(job_id=job_id, resume_id=resume_id)
        .select_related("user")
        .order_by("-created_at")
    )

    history = []

    # 添加机器评分（如果存在）
    if machine_score is not None:
        history.append(
            {
                "user": "系统",
                "score": machine_score,
                "created_at": (
                    machine_scored_at.strftime("%Y-%m-%d %H:%M:%S")
                    if machine_scored_at
                    else "未知时间"
                ),
                "type": "system",
            }
        )

    # 添加用户评分
    for s in user_scores:
        history.append(
            {
                "user": s.user.username,
                "score": s.user_match_score,
                "created_at": s.created_at.strftime("%Y-%m-%d %H:%M:%S"),
                "type": "user",
            }
        )

    # 按时间倒序排列（最新的在前）
    history.sort(key=lambda x: x["created_at"], reverse=True)

    return JsonResponse({"history": history})


@login_required
@require_POST
def add_user_score(request):
    """为岗位-简历插入新评分"""
    job_id = request.POST.get("job_id")
    resume_id = request.POST.get("resume_id")
    score = request.POST.get("score")
    try:
        job = JobPosition.objects.get(id=job_id)
        resume = Resume.objects.get(resume_id=resume_id)
        UserScore.objects.create(
            user=request.user,
            job=job,
            resume=resume,
            user_match_score=float(score),
        )
        return JsonResponse({"success": True})
    except Exception as e:
        return JsonResponse({"success": False, "error": str(e)})
