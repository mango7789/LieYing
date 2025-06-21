from django.db import models
from django.contrib.auth.models import User
from django.core.exceptions import ValidationError


class JobPosition(models.Model):
    name = models.CharField("岗位名称", max_length=100)
    company = models.CharField("企业名称", max_length=100)
    city = models.CharField("工作地点", max_length=50)  # TODO: 用下拉框 + 城市列表
    salary = models.CharField("薪资", max_length=50, blank=True)
    work_experience = models.CharField("工作年限", max_length=50, blank=True)
    education = models.CharField("学历要求", max_length=50, blank=True)
    language = models.CharField("语言要求", max_length=50, blank=True)
    responsibilities = models.TextField("岗位职责", blank=True)
    requirements = models.TextField("岗位要求", blank=True)
    created_at = models.DateTimeField("创建时间", auto_now_add=True)

    class Meta:
        verbose_name = "岗位"
        verbose_name_plural = "岗位"

    def __str__(self):
        return f"{self.name} - {self.company}"


class JobOwner(models.Model):
    job = models.ForeignKey(
        JobPosition,
        on_delete=models.CASCADE,
        verbose_name="岗位",
        related_name="owners",
    )
    user = models.ForeignKey(User, on_delete=models.CASCADE, verbose_name="用户")
    start_time = models.DateTimeField("开始时间", auto_now_add=True)
    end_time = models.DateTimeField("结束时间", null=True, blank=True)

    class Meta:
        verbose_name = "岗位负责人"
        verbose_name_plural = "岗位负责人"
        unique_together = ("job", "user", "start_time")

    def __str__(self):
        return f"{self.user.username} - {self.job.name}（从 {self.start_time.strftime('%Y-%m-%d')}）"

    def clean(self):
        # 用户需要是猎头
        if not hasattr(self.user, "profile") or self.user.profile.role != "猎头":
            raise ValidationError(
                f"用户 {self.user.username} 不是猎头，不能担任岗位负责人。"
            )
