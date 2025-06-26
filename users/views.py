from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth import login
from django.contrib import messages
from django.views.generic import RedirectView
from django.conf import settings
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


def home_view(request):
    resume_count = Resume.objects.count()
    job_count = JobPosition.objects.count()
    user_count = UserProfile.objects.filter(role="猎头").count()
    matching_count = Matching.objects.count()
    return render(request, "users/Main.html", {
        "resume_count": resume_count,
        "job_count": job_count,
        "user_count": user_count,
        "matching_count": matching_count,
    })
