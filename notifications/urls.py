from . import views as message_view
from django.urls import path

urlpatterns = [
    path("list/", message_view.mail_list, name="mail_list"),
    path(
        "notifications/read/<int:notification_id>/",
        message_view.mark_notification_read,
        name="mark_notification_read",
    ),
    path(
        "notifications/mark_all_read/",
        message_view.mark_all_notifications_read,
        name="mark_all_notifications_read",
    ),
]
