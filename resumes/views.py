import os, json, logging
from django.db.models import Q
from django.contrib import messages
from django.http import JsonResponse
from django.conf import settings
from django.core.files.storage import default_storage
from django.core.files.base import ContentFile
from django.template.loader import render_to_string
from django.shortcuts import render, redirect, get_object_or_404
from django.views.decorators.http import require_POST
from django.contrib.auth.decorators import login_required
from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger

from .models import Resume, UploadRecord
from .forms import ResumeForm
from .constants import *
from .parser import Parser
from core.utils.crypto import decrypt_params
from core.decorators import admin_required
from jobs.models import JobPosition

resume_parser = Parser()


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

    qs = (
        Resume.objects.exclude(resume_id__isnull=True)
        .exclude(resume_id="")
        .prefetch_related("related_jobs")
        .order_by("-updated_at")
    )
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

    # TODO: 根据 tags 进一步筛选

    if keyword:
        qs = qs.filter(
            Q(personal_info__icontains=keyword)
            | Q(skills__icontains=keyword)
            | Q(education__icontains=keyword)
            | Q(project_experiences__icontains=keyword)
            | Q(working_experiences__icontains=keyword)
        )

    # 分页
    paginator = Paginator(qs, 5)
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
        "is_staff": request.user.is_staff,
        "query": q,
    }

    # Ajax 异步更新简历表格
    if request.headers.get("x-requested-with") == "XMLHttpRequest":
        html = render_to_string("resumes/Table.html", context, request=request)
        return JsonResponse({"html": html})

    # TODO: 点击关联岗位，跳转到对应岗位的具体情况，而非编辑界面

    return render(request, "resumes/List.html", context)


@login_required
def resume_add():
    pass


@login_required
def resume_upload_page(request):
    jobs = JobPosition.objects.all()
    return render(request, "resumes/Upload.html", {"jobs": jobs})


@login_required
def resume_upload_list(request):
    query = request.GET.get("q", "")
    page_number = request.GET.get("page", 1)

    records = UploadRecord.objects.filter(user=request.user)

    if request.user.is_staff or request.user.is_superuser:
        records = UploadRecord.objects.all()
    else:
        records = UploadRecord.objects.filter(user=request.user)

    if query:
        records = records.filter(filename__icontains=query)

    records = records.order_by("-upload_time")

    paginator = Paginator(records, 10)  # 每页显示 10 条记录
    page_obj = paginator.get_page(page_number)

    for record in page_obj:
        file_path = os.path.join(settings.MEDIA_ROOT, UPLOAD_FOLDER, record.filename)
        record.file_exists = os.path.exists(file_path)

    return render(
        request,
        "resumes/History.html",
        {"page_obj": page_obj, "query": query, "MEDIA_URL": settings.MEDIA_URL},
    )


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

    filename = uploaded_file.name
    if not filename.lower().endswith(ALLOWED_EXTENSIONS):
        return JsonResponse(
            {
                "success": False,
                "message": "不支持的文件类型。请上传 Excel、HTML 或 PDF 文件。",
            }
        )

    local_path = os.path.join(UPLOAD_FOLDER, filename)
    full_path = os.path.join(settings.MEDIA_ROOT, local_path)
    os.makedirs(os.path.dirname(full_path), exist_ok=True)
    with open(full_path, "wb+") as destination:
        for chunk in uploaded_file.chunks():
            destination.write(chunk)

    upload_record = UploadRecord.objects.create(
        user=request.user,
        filename=filename,
        parse_status="fail",
        resume=None,
    )

    # NOTE: 批量解析，不再需要用户进行确认
    # TODO: 弹出小窗口展示解析结果
    try:
        resume_id, resume_dict = resume_parser.parse(full_path)
        logging.debug(f"解析结果：{resume_dict}")

        resume_obj, created = Resume.objects.get_or_create(
            resume_id=resume_id, defaults=resume_dict
        )
        if not created:
            for field, value in resume_dict.items():
                setattr(resume_obj, field, value)
            resume_obj.save()

        job_ids = request.POST.getlist("job_ids")
        # logging.debug(f"Job ids: {job_ids}")
        if job_ids:
            qs = JobPosition.objects.filter(id__in=job_ids)
            resume_obj.related_jobs.set(qs)

        upload_record.parse_status = "success"
        upload_record.resume = resume_obj
        upload_record.save()

        return JsonResponse(
            {
                "success": True,
                "message": f"{filename} 上传成功且解析完成，简历已保存。",
                "resume_id": resume_id,
                "resume_data": resume_dict,
                "upload_record_id": upload_record.id,
            }
        )

    except Exception as e:
        # 解析失败
        upload_record.error_message = str(e)
        upload_record.save()
        if settings.DEBUG:
            return JsonResponse(
                {
                    "success": False,
                    "message": f"{filename} 上传成功，但解析失败: {str(e)}",
                }
            )
        else:
            return JsonResponse(
                {"success": False, "message": f"{filename} 上传成功，但解析失败！"}
            )


@require_POST
@login_required
def resume_confirm(request):
    data = json.loads(request.body)
    resume_id = data.get("resume_id")
    resume_dict = data.get("resume_data")
    record_id = data.get("upload_record_id")

    resume_obj, created = Resume.objects.get_or_create(
        resume_id=resume_id, defaults=resume_dict
    )
    if not created:
        for field, value in resume_dict.items():
            setattr(resume_obj, field, value)
        resume_obj.save()

    UploadRecord.objects.filter(id=record_id).update(
        parse_status="success", resume=resume_obj
    )

    return JsonResponse({"success": True, "message": "简历已确认并保存！"})


@login_required
def resume_edit(request, resume_id):
    resume = get_object_or_404(Resume, pk=resume_id)

    if request.method == "POST":
        form = ResumeForm(request.POST, instance=resume)
        if form.is_valid():
            logging.debug("简历已成功修改")
            form.save()
            return redirect("resume_list")
        else:
            logging.warning("表单校验失败：%s", form.errors)
    else:
        form = ResumeForm(instance=resume)

    return render(request, "resumes/Edit.html", {"form": form, "resume": resume})


# TODO: 展示单独一份简历，可加入用户画像等功能
@login_required
def resume_detail(request, resume_id):
    resume = get_object_or_404(Resume, resume_id=resume_id)
    context = {
        "resume": resume,
    }
    return render(request, "resumes/Detail.html", context)


@login_required
@admin_required
@require_POST
def resume_delete(request, resume_id):
    logging.debug(resume_id)
    resume = get_object_or_404(Resume, resume_id=resume_id)
    resume.delete()
    return JsonResponse({"success": True})
