import logging
from django.db.models import Q
from django.contrib import messages
from django.http import JsonResponse
from django.template.loader import render_to_string
from django.shortcuts import render, redirect, get_object_or_404
from django.views.decorators.http import require_POST
from django.contrib.auth.decorators import login_required
from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger
from django.conf import settings

from .models import JobPosition, JobOwner
from .constants import *
from core.utils.crypto import decrypt_params
import os


# Create your views here.
@login_required
def job_list(request):
    q = request.GET.get("q")
    if q:
        try:
            params = decrypt_params(q)
        except Exception:
            return JsonResponse({"error": "参数解密失败"})
    else:
        params = {
            # "city": request.GET.get("city", "不限").strip(),
            # "work_years": request.GET.get("work_years", "不限").strip(),
            # "education": request.GET.get("education", "不限").strip(),
            "keyword": request.GET.get("keyword", "").strip(),
        }

    qs = JobPosition.objects.all().order_by("-id")
    # city = params["city"]
    # education = params["education"]
    # work_years = params["work_years"]
    keyword = params["keyword"]

    # if city != "不限" and city:
    #     qs = qs.filter(city__icontains=city)
    # if education != "不限" and education:
    #     qs = qs.filter(education__icontains=education)
    # if work_years != "不限" and work_years:
    #     qs = qs.filter(work_experience__icontains=work_years)
    if keyword:
        qs = qs.filter(
            Q(name__icontains=keyword)
            | Q(company__icontains=keyword)
            | Q(responsibilities__icontains=keyword)
            | Q(requirements__icontains=keyword)
            | Q(city__icontains=keyword)
            | Q(education__icontains=keyword)
            | Q(work_experience__icontains=keyword)
        )

    paginator = Paginator(qs, 10)
    page_number = request.GET.get("page", 1)
    try:
        page_obj = paginator.page(page_number)
    except PageNotAnInteger:
        page_obj = paginator.page(1)
    except EmptyPage:
        page_obj = paginator.page(paginator.num_pages)

    context = {
        "jobs": page_obj.object_list,
        "page_obj": page_obj,
        "city": CITY,
        "education": EDUCATION,
        "work_years": WORK_YEARS,
        "keyword": keyword,
    }

    if request.headers.get("x-requested-with") == "XMLHttpRequest":
        html = render_to_string("jobs/Table.html", context, request=request)
        return JsonResponse({"html": html})

    return render(request, "jobs/List.html", context)


@login_required
def job_upload_page(request):
    return render(request, "jobs/Upload.html")


@require_POST
@login_required
def job_upload(request):
    files = request.FILES.getlist("files")
    result = []
    for f in files:
        # 这里只做简单保存，实际可调用解析逻辑
        filename = f.name
        ext = os.path.splitext(filename)[1].lower()
        if ext not in [".pdf", ".html", ".htm", ".xls", ".xlsx", ".csv"]:
            result.append(
                {"filename": filename, "status": "失败", "msg": "文件类型不支持"}
            )
            continue
        # 保存文件到 media/jobs_uploads/
        save_path = os.path.join("jobs_uploads", filename)
        with open(os.path.join(settings.MEDIA_ROOT, save_path), "wb+") as dest:
            for chunk in f.chunks():
                dest.write(chunk)
        # TODO: 解析文件并入库
        result.append({"filename": filename, "status": "成功", "msg": "上传成功"})
    return JsonResponse({"result": result})


@login_required
def job_edit(request, job_id):
    job = get_object_or_404(JobPosition, id=job_id)
    if request.method == "POST":
        name = request.POST.get("name", "").strip()
        company = request.POST.get("company", "").strip()
        city = request.POST.get("city", "").strip()
        salary = request.POST.get("salary", "").strip()
        education = request.POST.get("education", "").strip()
        work_years = request.POST.get("work_years", "").strip()
        responsibilities = request.POST.get("responsibilities", "").strip()
        requirements = request.POST.get("requirements", "").strip()

        # 简单校验
        if not name or not company or not city:
            messages.error(request, "岗位名称、公司、城市为必填项")
        else:
            job.name = name
            job.company = company
            job.city = city
            job.salary = salary
            job.education = education
            job.work_years = work_years
            job.responsibilities = responsibilities
            job.requirements = requirements
            job.save()
            messages.success(request, "岗位信息已更新")
            return redirect("job_list")

    context = {
        "job": job,
        "city_choices": CITY,
        "education_choices": EDUCATION,
        "working_years_choices": WORK_YEARS,
    }
    return render(request, "jobs/Edit.html", context)
