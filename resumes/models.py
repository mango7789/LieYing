import re
from django.db import models
from django.contrib.auth.models import User
from jobs.models import JobPosition


def parse_required_info(info_str):
    """
    解析 personal_info，返回字典只包含
    性别、年龄、学历、工作年限、岗位、公司名称
    """
    result = {
        "gender": "",
        "age": "",
        "education": "",
        "work_years": "",
        "position": "",
        "company": "",
    }
    if not info_str:
        return result

    parts = [p.strip() for p in info_str.split("|")]

    # 第二部分：性别 年龄 城市 学历 工作年限 薪资
    if len(parts) > 1:
        tokens = parts[1].split()
        for t in tokens:
            if t in ["男", "女"]:
                result["gender"] = t
            elif re.match(r"\d{2}岁", t):
                result["age"] = t
            elif t in ["本科", "硕士", "博士", "大专", "高中"]:
                result["education"] = t
            elif re.match(r"工作\d+年", t):
                result["work_years"] = re.findall(r"\d+", t)[0] + "年"

    # 第三部分：部门 岗位 公司名称
    if len(parts) > 2:
        tokens = parts[2].split()
        if len(tokens) >= 3:
            # 假设岗位是第2个词
            result["position"] = tokens[1]
            result["company"] = " ".join(tokens[2:])
        elif len(tokens) == 2:
            result["position"] = tokens[0]
            result["company"] = tokens[1]
        elif len(tokens) == 1:
            result["company"] = tokens[0]

    return result


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
    phone = models.CharField("电话号码", max_length=11, blank=True)
    email = models.EmailField("邮箱", blank=True)

    # 个人信息及解析结果
    personal_info = models.TextField("个人信息", blank=True)
    gender = models.CharField("性别", max_length=2, blank=True)
    age = models.PositiveIntegerField("年龄", blank=True, null=True)
    education_level = models.CharField("学历", max_length=10, blank=True)
    work_years = models.CharField("工作年限", blank=True, max_length=5, default="")
    company_name = models.CharField("公司", max_length=50, blank=True)
    position = models.CharField("岗位", max_length=50, blank=True)

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

    related_jobs = models.ManyToManyField(
        JobPosition, verbose_name="关联岗位", blank=True
    )

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

    def save(self, *args, **kwargs):
        if self.personal_info:
            parsed = parse_required_info(self.personal_info)
            self.gender = parsed.get("gender", "")
            self.age = int(parsed.get("age", "").replace("岁", "") or 0)
            self.education_level = parsed.get("education", "")
            self.work_years = parsed.get("work_years", "")
            self.company_name = parsed.get("company", "")
            self.position = parsed.get("position", "")
        super().save(*args, **kwargs)


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
