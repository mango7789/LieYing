from django.db import models
from django.contrib.auth.models import User


class Resume(models.Model):
    STATUS_CHOICES = [
        ("离职，正在找工作", "离职，正在找工作"),
        ("在职，急寻新工作", "在职，急寻新工作"),
        ("在职，看看新机会", "在职，看看新机会"),
        ("在职，暂无跳槽打算", "在职，暂无跳槽打算"),
    ]

    resume_id = models.CharField("简历编号", max_length=32, primary_key=True)
    created_at = models.DateTimeField("创建时间", auto_now_add=True)
    updated_at = models.DateTimeField("更新时间", auto_now=True)

    # 主要信息
    name = models.CharField("姓名", max_length=10)
    status = models.CharField(
        "状态", max_length=20, choices=STATUS_CHOICES, default="在职，看看新机会"
    )
    personal_info = models.TextField("个人信息", blank=True)
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

    # HH 需求
    current_status = models.CharField(
        "当前状态",
        max_length=20,
        choices=[("面试中", "面试中"), ("匹配中", "匹配中")],
        default="匹配中",
    )
    tags = models.JSONField("标签", default=list, blank=True)
    # TODO: 标注简历来源
    # source = models.CharField("来源", blank=True, default="猎聘")

    class Meta:
        verbose_name = "简历"
        verbose_name_plural = "简历"

    def to_json(self) -> dict:
        return {
            "resume_id": self.resume_id,
            "name": self.name,
            "skills": self.skills,
            "education": self.education,
            "work_experience": self.working_experiences,
            "project_experience": self.project_experiences,
            "status": self.status,
            "expectation": self.expected_positions,
        }


class UploadRecord(models.Model):
    PARSE_STATUS_CHOICES = (
        ("success", "解析成功"),
        ("fail", "解析失败"),
    )

    user = models.ForeignKey(User, on_delete=models.CASCADE)
    filename = models.CharField(max_length=255)
    upload_time = models.DateTimeField(auto_now_add=True)
    parse_status = models.CharField(
        max_length=10,
        choices=PARSE_STATUS_CHOICES,
        default="fail",
        verbose_name="解析状态",
    )
    resume = models.ForeignKey(
        Resume,
        null=True,
        blank=True,
        on_delete=models.SET_NULL,
        verbose_name="关联简历",
    )
    error_message = models.TextField(
        null=True,
        blank=True,
        verbose_name="失败原因",
        help_text="记录解析失败时的异常信息",
    )

    def __str__(self):
        return f"{self.user.username} 上传了 {self.filename} 于 {self.upload_time}，状态：{self.get_parse_status_display()}"

    class Meta:
        verbose_name = "简历上传记录"
        verbose_name_plural = "简历上传记录"
