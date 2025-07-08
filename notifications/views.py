from django.shortcuts import render, redirect, get_object_or_404
from django.core.paginator import Paginator
from django.contrib.auth.decorators import login_required
from django.db.models import Q

from .models import Notification


@login_required
def mail_list(request):
    query = request.GET.get("q", "")

    notifications = Notification.objects.filter(recipient=request.user)

    if query:
        notifications = notifications.filter(
            Q(title__icontains=query) | Q(content__icontains=query)
        )

    notifications = notifications.order_by("-created_at")

    paginator = Paginator(notifications, 10)
    page_number = request.GET.get("page")
    page_obj = paginator.get_page(page_number)

    return render(
        request,
        "notifications/mail_list.html",
        {
            "page_obj": page_obj,
            "query": query,
        },
    )


@login_required
def mark_notification_read(request, notification_id):
    notification = get_object_or_404(
        Notification, id=notification_id, recipient=request.user
    )
    if not notification.is_read:
        notification.is_read = True
        notification.save(update_fields=["is_read"])
    # 标记后跳回上一页或通知列表页
    return redirect(request.META.get("HTTP_REFERER", "/"))


@login_required
def mark_all_notifications_read(request):
    Notification.objects.filter(recipient=request.user, is_read=False).update(
        is_read=True
    )
    return redirect("mail_list")
