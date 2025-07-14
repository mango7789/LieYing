from django.views.generic import ListView
from django.db.models import Q
from django.shortcuts import render, get_object_or_404
from django.contrib.auth.decorators import login_required

from .models import Interview


class InterviewListView(ListView):
    model = Interview
    template_name = "match/interview_List.html"  # 模板路径
    context_object_name = "interviews"  # 模板中使用的变量名
    paginate_by = 10  # 每页显示10条记录

    def get_queryset(self):
        queryset = super().get_queryset()

        # 获取筛选参数（从URL的GET请求中）
        keyword = self.request.GET.get("keyword", "")
        stage = self.request.GET.get("stage", "")
        status = self.request.GET.get("status", "")
        result = self.request.GET.get("result", "")

        # 关键词筛选（面试官、地点、反馈等）
        if keyword:
            queryset = queryset.filter(
                Q(interviewer__icontains=keyword)
                | Q(location__icontains=keyword)
                | Q(feedback__icontains=keyword)
            )

        # 其他条件筛选
        if stage:
            queryset = queryset.filter(stage=stage)
        if status:
            queryset = queryset.filter(status=status)
        if result:
            queryset = queryset.filter(result=result)

        return queryset.order_by("-interview_date")  # 按面试时间倒序

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)

        # 添加筛选选项到上下文（用于模板中的下拉框/按钮组）
        context["stage_choices"] = Interview.INTERVIEW_STAGE_CHOICES
        context["status_choices"] = Interview.INTERVIEW_STATUS_CHOICES
        context["result_choices"] = Interview.INTERVIEW_RESULT_CHOICES

        # 保留当前筛选值（用于模板中回显）
        context["filter_keyword"] = self.request.GET.get("keyword", "")
        context["selected_stage"] = self.request.GET.get("stage", "")
        context["selected_status"] = self.request.GET.get("status", "")
        context["selected_result"] = self.request.GET.get("result", "")

        return context


@login_required
def interview_detail(request, pk):
    interview = get_object_or_404(Interview, pk=pk)
    return render(request, "match/interview_detail.html", {"interview": interview})
