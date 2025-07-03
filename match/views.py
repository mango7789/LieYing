from django.shortcuts import render
from django.contrib.auth.decorators import login_required
from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger

from .models import Matching


# Create your views here.
@login_required
def match_list(request):
    query = request.GET.get("q", "")
    page_number = request.GET.get("page", 1)
    sort = request.GET.get("sort", "updated_at")
    order = request.GET.get("order", "desc")  # 默认倒序

    records = Matching.objects.select_related("resume", "job").all()

    # 模糊搜索简历ID或岗位名或公司名
    if query:
        records = (
            records.filter(resume__resume_id__icontains=query)
            | records.filter(job__name__icontains=query)
            | records.filter(job__company__icontains=query)
        )

    # 有效排序字段列表，避免注入
    valid_sort_fields = {
        "resume": "resume__resume_id",
        "job": "job__name",
        "company": "job__company",
        "task_status": "task_status",
        "score": "score",
        "score_source": "score_source",
        "updated_at": "updated_at",
    }

    sort_field = valid_sort_fields.get(sort, "updated_at")

    if order == "desc":
        sort_field = "-" + sort_field

    records = records.order_by(sort_field)

    paginator = Paginator(records, 10)
    page_obj = paginator.get_page(page_number)

    columns = [
        ("resume", "简历 ID"),
        ("job", "岗位名称"),
        ("task_status", "状态"),
        ("score", "分数"),
        ("score_source", "分数来源"),
        ("updated_at", "最后更新时间"),
    ]

    return render(
        request,
        "match/List.html",
        {
            "page_obj": page_obj,
            "query": query,
            "sort": sort,
            "order": order,
            "columns": columns,
        },
    )
