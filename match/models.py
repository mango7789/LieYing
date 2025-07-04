from django.db import models
from resumes.models import Resume
from jobs.models import JobPosition

STATUS_CHOICES = [
    ("未过分数筛选", "未过分数筛选"),
    ("进入初筛", "进入初筛"),
    ("进入面试", "进入面试"),
    ("淘汰", "淘汰"),
    ("录用", "录用"),
]
TASK_STATUS_CHOICES = [
    ("未开始", "未开始"),
    ("匹配中", "匹配中"),
    ("已完成", "已完成"),
    ("失败", "失败"),
]


class Matching(models.Model):

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
    task_status = models.CharField(
        max_length=10, choices=TASK_STATUS_CHOICES, default="未开始"
    )
    score = models.FloatField("分数", null=True, blank=True)
    score_source = models.CharField("分数来源", max_length=100, blank=True)
    scored_at = models.DateTimeField("打分时间", auto_now_add=True)
    updated_at = models.DateTimeField("更新时间", auto_now=True)

    reason = models.TextField("匹配原因", blank=True)
    strengths = models.TextField("简历长处", blank=True)
    weaknesses = models.TextField("简历短处", blank=True)
    suggestions = models.TextField("改进建议", blank=True)

    class Meta:
        verbose_name = "简历岗位匹配"
        verbose_name_plural = "简历岗位匹配"
        unique_together = ("resume", "job")

    def __str__(self):
        return f"{self.resume.resume_id} - {self.job.name} 匹配（{self.status}）"

    def save(self, *args, **kwargs):
        if self.score is not None:
            self.task_status = "已完成"
        super().save(*args, **kwargs)


class JobMatchTask(models.Model):
    job = models.OneToOneField(
        JobPosition, on_delete=models.CASCADE, related_name="match_task"
    )
    status = models.CharField(
        max_length=10, choices=TASK_STATUS_CHOICES, default="未开始"
    )
    last_processed_resume_id = models.CharField(max_length=32, null=True, blank=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.job.name} 匹配任务（{self.status}）"


class Interview(models.Model):
    class Meta:
        verbose_name = "面试流程"
        verbose_name_plural = "面试流程"
