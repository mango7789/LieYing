from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.decorators import login_required
from django.contrib.auth import update_session_auth_hash
from django.contrib import messages
from django.views.generic import RedirectView
from django.conf import settings

from .forms import UserUpdateForm, CustomPasswordChangeForm
from resumes.models import Resume
from jobs.models import JobPosition
from users.models import UserProfile
from match.models import Matching


def root_redirect(request):
    if request.user.is_authenticated:
        return RedirectView.as_view(url="/home/", permanent=False)(request)
    else:
        return RedirectView.as_view(url="/login/", permanent=False)(request)


def custom_login_view(request):
    if request.method == "POST":
        username = request.POST.get("username")
        password = request.POST.get("password")
        remember_me = request.POST.get("remember_me")
        user = authenticate(request, username=username, password=password)

        if user is not None:
            if remember_me:
                request.session.set_expiry(settings.REMEMBER_ME_SECONDS)
            else:
                request.session.set_expiry(0)
            login(request, user)
            messages.success(request, "登录成功！")
            next_url = request.GET.get("next")
            if next_url:
                return redirect(next_url)
            else:
                return redirect("home")
        else:
            messages.error(request, "用户名或密码错误")

    return render(request, "users/User_Login.html")


@login_required
def custom_logout_view(request):
    logout(request)
    messages.info(request, "你已成功登出。")
    return redirect("login")


def custom_register_view(request):
    form = UserCreationForm(request.POST or None)
    if request.method == "POST":
        if form.is_valid():
            user = form.save()
            login(request, user)
            return redirect("home")
    return render(request, "users/User_register.html", {"form": form})


@login_required
def home_view(request):
    resume_count = Resume.objects.count()
    job_count = JobPosition.objects.count()
    user_count = UserProfile.objects.filter(role="猎头").count()
    matching_count = Matching.objects.count()
    return render(
        request,
        "users/Main.html",
        {
            "resume_count": resume_count,
            "job_count": job_count,
            "user_count": user_count,
            "matching_count": matching_count,
        },
    )


@login_required
def profile_view(request):
    user = request.user

    if request.method == "POST":
        user_form = UserUpdateForm(request.POST, instance=user)
        pwd_form = CustomPasswordChangeForm(user=user, data=request.POST)

        if "update_profile" in request.POST and user_form.is_valid():
            user_form.save()
            messages.success(request, "资料更新成功")
            return redirect("profile")

        elif "change_password" in request.POST and pwd_form.is_valid():
            pwd_form.save()
            update_session_auth_hash(request, pwd_form.user)
            messages.success(request, "密码修改成功")
            return redirect("profile")
    else:
        user_form = UserUpdateForm(instance=user)
        pwd_form = CustomPasswordChangeForm(user=user)

    return render(
        request, "users/profile.html", {"user_form": user_form, "pwd_form": pwd_form}
    )
