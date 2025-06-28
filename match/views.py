from django.shortcuts import render
from django.contrib.auth.decorators import login_required
from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger

from .models import Matching


# Create your views here.
def match_list(request):
    query = request.GET.get("q", "")
    page_number = request.GET.get("page", 1)

    records = Matching.objects.select_related("resume", "job").all()

    # 匹配简历 ID 或岗位名称
    if query:
        records = records.filter(resume__resume_id__icontains=query) | records.filter(
            job__name__icontains=query
        )

    records = records.order_by("-updated_at")

    paginator = Paginator(records, 10)
    page_obj = paginator.get_page(page_number)

    return render(
        request,
        "match/List.html",
        {"page_obj": page_obj, "query": query},
    )
