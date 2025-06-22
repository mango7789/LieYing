from django.db.models import Q
from django.contrib import messages
from django.http import JsonResponse
from django.shortcuts import render, redirect, get_object_or_404
from django.views.decorators.http import require_POST
from django.contrib.auth.decorators import login_required
from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger
from .models import Resume
from .constants import *

# Create your views here.


@login_required
def resume_list(request):
    qs = Resume.objects.all()

    city = request.GET.get("city", "不限").strip()
    work_years = request.GET.get("work_years", "不限").strip()
    education = request.GET.get("education", "不限").strip()
    keyword = request.GET.get("keyword", "").strip()

    # 仅当选项不是“不限”时才过滤
    if city != "不限" and city:
        qs = qs.filter(personal_info__icontains=city)

    if work_years != "不限" and work_years:
        qs = qs.filter(tags__icontains=work_years)

    if education != "不限" and education:
        qs = qs.filter(education__icontains=education)

    if keyword:
        qs = qs.filter(
            Q(personal_info__icontains=keyword)
            | Q(skills__icontains=keyword)
            | Q(education__icontains=keyword)
            | Q(project_experiences__icontains=keyword)
            | Q(working_experiences__icontains=keyword)
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
        "resumes": page_obj.object_list,
        "page_obj": page_obj,
        "city_choices": CITY_CHOICES,
        "education_choices": EDUCATION_CHOICES,
        "working_years_choices": WORKING_Y_CHOICES,
        "selected_city": city,
        "selected_education": education,
        "selected_working_y": work_years,
        "filter_keyword": keyword,
    }
    return render(request, "resumes/List.html", context)


def resume_add():
    pass


@login_required
@require_POST
def resume_upload(request):
    uploaded_file = request.FILES.get("file")
    if not uploaded_file:
        return JsonResponse({"success": False, "message": "请上传文件。"})

    if uploaded_file.size > MAX_UPLOAD_SIZE * MB:
        return JsonResponse(
            {
                "success": False,
                "message": f"文件过大，最大支持 {MAX_UPLOAD_SIZE}MB 的文件上传。",
            }
        )

    # TODO: 支持多文件上传，接入文件的解析

    filename = uploaded_file.name

    if filename.endswith(".xls") or filename.endswith(".xlsx"):
        msg = f"{filename} 上传成功！"
    elif filename.endswith(".html") or filename.endswith(".htm"):
        msg = f"{filename} 上传成功！"
    elif filename.endswith(".pdf"):
        msg = f"{filename} 上传成功！"
    else:
        return JsonResponse(
            {
                "success": False,
                "message": "不支持的文件类型。请上传 Excel、HTML 或 PDF 文件。",
            }
        )

    return JsonResponse({"success": True, "message": msg})


def resume_modify():
    pass


# TODO: 展示单独一份简历，可加入用户画像等功能
@login_required
def resume_detail(request, resume_id):
    resume = get_object_or_404(Resume, resume_id=resume_id)
    context = {
        "resume": resume,
    }
    return render(request, "resumes/Detail.html", context)
