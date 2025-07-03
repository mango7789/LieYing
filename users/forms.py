from django import forms
from django.contrib.auth.models import User
from django.contrib.auth.forms import PasswordChangeForm


class UserUpdateForm(forms.ModelForm):
    username = forms.CharField(label="用户名", disabled=True, required=False)
    email = forms.EmailField(required=False, label="邮箱")

    class Meta:
        model = User
        fields = ["username", "email"]


class CustomPasswordChangeForm(PasswordChangeForm):
    old_password = forms.CharField(label="原密码", widget=forms.PasswordInput)
    new_password1 = forms.CharField(label="新密码", widget=forms.PasswordInput)
    new_password2 = forms.CharField(label="确认新密码", widget=forms.PasswordInput)
