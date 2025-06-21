from django.db import models
from django.contrib.auth.models import User
from django.utils import timezone


class Resume(models.Model):
    resume_id = models.CharField("简历编号", max_length=32, primary_key=True)
    created_at = models.DateTimeField("创建时间", auto_now_add=True)
    updated_at = models.DateTimeField("更新时间", auto_now=True)
    current_version = models.ForeignKey(
        "ResumeVersion",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="+",
        verbose_name="当前版本",
    )


class ResumeVersion(models.Model):
    resume = models.ForeignKey(
        Resume,
        on_delete=models.CASCADE,
        related_name="versions",
        verbose_name="所属简历",
    )
    version_number = models.PositiveIntegerField("版本号")

    # 主要信息
    name = models.CharField("姓名", max_length=10)
    status = models.CharField("状态", max_length=10)
    personal_info = models.TextField("个人信息")
    phone = models.CharField("电话号码", max_length=11, blank=True)
    email = models.EmailField("邮箱", blank=True)

    # 其他信息
    expected_positions = models.JSONField("期望岗位", default=list, blank=True)
    education = models.JSONField("教育经历", default=list, blank=True)
    certificates = models.TextField("证书", blank=True)
    skills = models.JSONField("技能", default=list, blank=True)
    self_evaluation = models.TextField("自我评价", blank=True)

    # 项目经历/工作经历
    project_experiences = models.JSONField("项目经历", default=list, blank=True)
    working_experiences = models.JSONField("工作经历", default=list, blank=True)

    current_status = models.CharField(
        "当前状态", max_length=20, choices=[("面试中", "面试中"), ("匹配中", "匹配中")]
    )
    tags = models.JSONField("标签", default=list, blank=True)

    created_at = models.DateTimeField("创建时间", auto_now_add=True)

    class Meta:
        unique_together = ("resume", "version_number")
        ordering = ["-version_number"]
        verbose_name = "简历版本"
        verbose_name_plural = "简历版本"
