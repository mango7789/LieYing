import logging
from django.db.models import Q
from django.contrib import messages
from django.http import JsonResponse
from django.template.loader import render_to_string
from django.shortcuts import render, redirect, get_object_or_404
from django.views.decorators.http import require_POST
from django.contrib.auth.decorators import login_required
from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger

from .models import JobPosition, JobOwner
from .constants import *
from .parser import parse_html_file
from core.utils.crypto import decrypt_params


# Create your views here.
login_required
def job_list(request):
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

    qs = JobPosition.objects.all()
    city = params["city"]
    education = params["education"]
    work_years = params["work_years"]
    keyword = params["keyword"]

    if city != "不限" and city:
        qs = qs.filter(city__icontains=city)
    if education != "不限" and education:
        qs = qs.filter(education__icontains=education)
    if work_years != "不限" and work_years:
        qs = qs.filter(tags__icontains=work_years)
    if keyword:
        qs = qs.filter(
            Q(name__icontains=keyword)
            | Q(company__icontains=keyword)
            | Q(responsibilities__icontains=keyword)
            | Q(requirements__icontains=keyword)
            | Q(city__icontains=keyword)
            | Q(education__icontains=keyword)
            | Q(work_years__icontains=keyword)
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
