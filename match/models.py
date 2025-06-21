from django.db import models
from resumes.models import Resume
from jobs.models import JobPosition


class Matching(models.Model):
    STATUS_CHOICES = [
        ("未过分数筛选", "未过分数筛选"),
        ("进入初筛", "进入初筛"),
        ("进入面试", "进入面试"),
        ("淘汰", "淘汰"),
        ("录用", "录用"),
    ]

    resume = models.ForeignKey(
        Resume, on_delete=models.CASCADE, verbose_name="简历", related_name="matchings"
    )
    job = models.ForeignKey(
        JobPosition,
        on_delete=models.CASCADE,
        verbose_name="岗位",
        related_name="matchings",
    )
    status = models.CharField(
        "状态", max_length=20, choices=STATUS_CHOICES, default="未过分数筛选"
    )
    score = models.FloatField("分数", null=True, blank=True)
    score_source = models.CharField("分数来源", max_length=100, blank=True)
    scored_at = models.DateTimeField("打分时间", auto_now_add=True)
    updated_at = models.DateTimeField("更新时间", auto_now=True)

    class Meta:
        verbose_name = "简历岗位匹配"
        verbose_name_plural = "简历岗位匹配"
        unique_together = ("resume", "job")

    def __str__(self):
        return f"{self.resume.resume_id} - {self.job.name} 匹配（{self.status}）"
