from django.db import models
from django.contrib.auth.models import User

# Create your models here.


class Notification(models.Model):
    class NotificationType(models.TextChoices):
        SCORE_STARTED = "score_started", "打分任务启动"
        SCORE_SUCCESS = "score_success", "打分任务成功"
        SCORE_FAILED = "score_failed", "打分任务失败"
        JOB_CREATED = "job_created", "新建岗位"
        JOB_UPDATED = "job_updated", "岗位更新"
        RESUME_FOUND = "resume_found", "收到新简历"
        CONTACT_FOUND = "contact_found", "获得新联系方式"
        OTHER = "other", "其他"

    recipient = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name="notifications"
    )
    notification_type = models.CharField(
        max_length=32, choices=NotificationType.choices
    )
    title = models.CharField(max_length=255)
    content = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    is_read = models.BooleanField(default=False)
    is_important = models.BooleanField(default=False)
    link_url = models.URLField(blank=True, null=True)

    def __str__(self):
        return f"{self.recipient.username} - {self.title[:20]} ({self.get_notification_type_display()})"

    class Meta:
        indexes = [
            models.Index(fields=["recipient", "is_read"]),
            models.Index(fields=["recipient", "created_at"]),
        ]
        ordering = ["-created_at"]
