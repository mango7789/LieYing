import logging
from django.shortcuts import render, redirect, get_object_or_404
from django.db.models import Count, Max, Q
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.http import JsonResponse
from django.views.decorators.http import require_POST

from .models import JobPosition
from .forms import JobForm
from .constants import CITY_CHOICES, EDUCATION_CHOICES, WORK_EXPERIENCE_CHOICES
from match.models import Matching
from match.services import async_run_matching_for_job


###########################################################
#                         List                            #
###########################################################


@login_required
def company_list(request):
    # 按公司分组，统计职位数量和最新创建时间
    companies = (
        JobPosition.objects.values("company")
        .annotate(job_count=Count("id"), latest_created=Max("created_at"))
        .order_by("-latest_created")
    )

    return render(request, "jobs/company_list.html", {"companies": companies})


# TODO: 可以自定义配置打分权重
@login_required
def job_list(request, company):
    # 获取指定公司的所有职位
    jobs = JobPosition.objects.filter(company=company).order_by("-created_at")

    # 添加匹配状态逻辑
    # TODO: 对匹配中的岗位增加匹配进度的展示
    for job in jobs:
        job.task_status = get_job_match_status(job.id)

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

    logging.debug(summary)
    return status
    return {"status": status, "summary": summary}


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
                job = form.save()
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
                form.save()
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
    """开始匹配功能"""
    job = get_object_or_404(JobPosition, pk=job_id)

    if request.method == "POST":
        try:
            async_run_matching_for_job.delay(job_id)
            messages.success(request, f'岗位"{job.name}"匹配任务已启动。')
        except Exception as e:
            messages.error(request, f"启动匹配失败：{str(e)}")

        return redirect("jobs:job_list", company=job.company)

    # GET请求显示确认页面
    return render(request, "jobs/start_matching_confirm.html", {"job": job})


@login_required
def match_result(request, job_id):
    """查看匹配结果"""
    job = get_object_or_404(JobPosition, pk=job_id)

    # 从match模块获取实际的匹配结果数据
    # 这里应该查询match模块的匹配结果
    try:
        matchings = (
            Matching.objects.select_related("resume").filter(job=job).order_by("-score")
        )

        resumes = [
            {
                "resume_id": m.resume.resume_id,
                "name": m.resume.name,
                "match_score": round(m.score or 0, 1),
                "status": m.resume.status,
                "match_status": m.status,
            }
            for m in matchings
        ]

        for r in resumes:
            r["match_score_percent"] = r["match_score"] * 10

    except Exception as e:
        messages.error(request, f"获取匹配结果失败：{str(e)}")
        resumes = []

    return render(request, "jobs/match_result.html", {"job": job, "resumes": resumes})
