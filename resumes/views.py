import logging
from django.db.models import Q
from django.contrib import messages
from django.http import JsonResponse
from django.template.loader import render_to_string
from django.shortcuts import render, redirect, get_object_or_404
from django.views.decorators.http import require_POST
from django.contrib.auth.decorators import login_required
from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger

from .models import Resume, UploadRecord
from .constants import *
from .parser import parse_html_file
from core.utils.crypto import decrypt_params


# Create your views here.
@login_required
def resume_list(request):
    q = request.GET.get("q")
    if q:
        try:
            params = decrypt_params(q)
        except Exception:
            return JsonResponse({"error": "参数解密失败"})
    else:
        params = {
            "city": request.GET.get("city", "不限").strip(),
            "work_years": request.GET.get("work_years", "不限").strip(),
            "education": request.GET.get("education", "不限").strip(),
            "keyword": request.GET.get("keyword", "").strip(),
        }

    qs = Resume.objects.all()
    city = params["city"]
    work_years = params["work_years"]
    education = params["education"]
    keyword = params["keyword"]

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

    # 分页
    paginator = Paginator(qs, 10)
    page_number = request.GET.get("page", 1)
    try:
        page_obj = paginator.page(page_number)
    except PageNotAnInteger:
        page_obj = paginator.page(1)
    except EmptyPage:
        page_obj = paginator.page(paginator.num_pages)

    # TODO: 给简历添加标签

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

    # Ajax 异步更新简历表格
    if request.headers.get("x-requested-with") == "XMLHttpRequest":
        html = render_to_string("resumes/Table.html", context, request=request)
        return JsonResponse({"html": html})

    return render(request, "resumes/List.html", context)


def resume_add():
    pass


@login_required
def resume_upload_page(request):
    return render(request, "resumes/Upload.html")


# TODO: 简历上传记录
@login_required
def resume_upload_list(request):
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

    if not filename.lower().endswith(ALLOWED_EXTENSIONS):
        return JsonResponse(
            {
                "success": False,
                "message": "不支持的文件类型。请上传 Excel、HTML 或 PDF 文件。",
            }
        )
    upload_record = UploadRecord.objects.create(
        user=request.user,
        filename=filename,
        parse_status="fail",
        resume=None,
    )

    try:
        resume_id, resume_data = "demo123456", {}
        resume_obj, created = Resume.objects.get_or_create(resume_id=resume_id)

        # 覆盖原简历字段
        for field, value in resume_data.items():
            setattr(resume_obj, field, value)
        resume_obj.save()

        upload_record.parse_status = "success"
        upload_record.resume = resume_obj
        upload_record.save()

        return JsonResponse(
            {"success": True, "message": f"{filename} 上传成功且解析完成！"}
        )
    except Exception as e:
        # 解析失败
        return JsonResponse(
            {"success": False, "message": f"{filename} 上传成功，但解析失败: {str(e)}"}
        )


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
