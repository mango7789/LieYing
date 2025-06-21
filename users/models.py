from django.db import models
from django.contrib.auth.models import User


class UserProfile(models.Model):
    ROLE_CHOICES = (
        ("管理员", "管理员"),
        ("猎头", "猎头"),
    )
    user = models.OneToOneField(
        User, on_delete=models.CASCADE, related_name="profile", verbose_name="用户"
    )
    role = models.CharField("角色", max_length=10, choices=ROLE_CHOICES)

    class Meta:
        verbose_name = "用户资料"
        verbose_name_plural = "用户资料"

    def __str__(self):
        return f"{self.user.username}（{self.role}）"
