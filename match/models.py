import datetime
from django.db import models
from django.contrib.auth.models import User
from django.core.validators import MinValueValidator, MaxValueValidator

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
    initiator = models.ForeignKey(
        User, null=True, blank=True, on_delete=models.SET_NULL
    )

    class Meta:
        verbose_name = "岗位匹配任务"
        verbose_name_plural = "岗位匹配任务"

    def __str__(self):
        return f"{self.job.name} 匹配任务（{self.status}）"


############# 面试 ###############


class Tag(models.Model):
    name = models.CharField(max_length=50, verbose_name="标签名称")

    def __str__(self):
        return self.name


class Interview(models.Model):
    INTERVIEW_STAGE_CHOICES = [
        ("初试", "初试"),
        ("复试", "复试"),
        ("终面", "终面"),
    ]

    INTERVIEW_STATUS_CHOICES = [
        ("未安排", "未安排"),
        ("进行中", "进行中"),
        ("已完成", "已完成"),
        ("已取消", "已取消"),
    ]

    INTERVIEW_RESULT_CHOICES = [
        ("通过", "通过"),
        ("不通过", "不通过"),
    ]

    resume = models.ForeignKey(
        Resume, on_delete=models.CASCADE, verbose_name="简历", related_name="interviews"
    )
    job = models.ForeignKey(
        JobPosition,
        on_delete=models.CASCADE,
        verbose_name="岗位",
        related_name="interviews",
    )
    stage = models.CharField(
        max_length=20,
        choices=INTERVIEW_STAGE_CHOICES,
        default="初试",
        verbose_name="面试阶段",
    )
    status = models.CharField(
        max_length=10,
        choices=INTERVIEW_STATUS_CHOICES,
        default="未安排",
        verbose_name="面试状态",
    )
    interview_date = models.DateTimeField("面试时间", default=datetime.date.today)
    interviewer = models.CharField(
        max_length=255, verbose_name="面试官", blank=True, null=True
    )
    location = models.CharField(
        max_length=255, verbose_name="面试地点", blank=True, null=True
    )
    feedback = models.TextField("面试反馈", blank=True, null=True)
    score = models.FloatField("面试分数", null=True, blank=True)
    reason = models.TextField("面试原因", blank=True, null=True)
    result = models.CharField(
        max_length=50,
        choices=INTERVIEW_RESULT_CHOICES,
        blank=True,
        null=True,
        verbose_name="面试结果",
    )
    updated_at = models.DateTimeField("更新时间", auto_now=True)

    # 薪资信息和用人规划
    current_salary = models.FloatField("现有薪资", null=True, blank=True)
    expected_salary = models.FloatField("期望薪资", null=True, blank=True)
    hiring_plan = models.TextField("用人规划", blank=True, null=True)

    # 综合评价
    overall_evaluation = models.TextField("综合评价", blank=True, null=True)

    ############# 问卷主体内容 #############
    # 工作经验匹配性（单选题）
    experience_match = models.CharField(
        "工作经验匹配性",
        max_length=20,
        choices=[("高", "高"), ("中等", "中等"), ("低", "低")],
        null=True,
        blank=True,
    )

    # 下一轮面试需进一步关注（多选题）
    focus_areas = models.CharField(
        "下一轮面试需进一步关注",
        max_length=255,
        null=True,
        blank=True,
        help_text="多个选项请用逗号分隔",
    )

    # 业务或专业能力（评分题）
    professional_ability = models.IntegerField(
        "业务能力评分",
        null=True,
        blank=True,
        validators=[MinValueValidator(1), MaxValueValidator(5)],  # 评分范围：1到5
    )

    # 培养潜力（评分题）
    cultivate_potential = models.IntegerField(
        "培养潜力",
        null=True,
        blank=True,
        validators=[MinValueValidator(1), MaxValueValidator(5)],  # 评分范围：1到5
    )

    # 沟通协调（评分题）
    communication_ability = models.IntegerField(
        "沟通协调",
        null=True,
        blank=True,
        validators=[MinValueValidator(1), MaxValueValidator(5)],  # 评分范围：1到5
    )

    # 逻辑思考（评分题）
    logical_thinking = models.IntegerField(
        "逻辑思考",
        null=True,
        blank=True,
        validators=[MinValueValidator(1), MaxValueValidator(5)],  # 评分范围：1到5
    )

    # 责任意识（评分题）
    responsibility = models.IntegerField(
        "责任意识",
        null=True,
        blank=True,
        validators=[MinValueValidator(1), MaxValueValidator(5)],  # 评分范围：1到5
    )

    # 创新思维（评分题）
    innovative_thinking = models.IntegerField(
        "创新思维",
        null=True,
        blank=True,
        validators=[MinValueValidator(1), MaxValueValidator(5)],  # 评分范围：1到5
    )

    # 候选人所有者（可编辑的名字）
    owner_name = models.CharField(
        "候选人所有者",
        max_length=100,
        blank=True,
        null=True,
        help_text="请输入候选人的所有者名字",
    )

    # 自定义标签
    tags = models.ManyToManyField(
        Tag, blank=True, related_name="interviews", verbose_name="自定义标签"
    )

    class Meta:
        verbose_name = "面试流程"
        verbose_name_plural = "面试流程"
        unique_together = (
            "resume",
            "job",
            "stage",
        )  # 确保每个简历和岗位在同一面试阶段只有一条记录

    def __str__(self):
        return f"{self.resume.resume_id} - {self.job.name} - {self.stage} 面试"

    def save(self, *args, **kwargs):
        if self.status == "已完成" and self.score is not None:
            self.result = "通过" if self.score >= 60 else "不通过"
        super().save(*args, **kwargs)
