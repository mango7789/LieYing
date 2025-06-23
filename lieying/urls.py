"""
URL configuration for lieying project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""

from django.contrib import admin
from django.urls import path
from django.views.generic import RedirectView

import users.views as user_view
import resumes.views as resume_view
import jobs.views as job_view

urlpatterns = [
    # 超级管理员
    path("admin/", admin.site.urls),
    # 用户/管理员 处理注册、登录、权限管理
    path("", RedirectView.as_view(url="/login/", permanent=False)),
    path("login/", user_view.login, name="login"),
    path("logout/", user_view.logout, name="logout"),
    path("register/", user_view.register, name="register"),
    path("home/", user_view.home, name="home"),
    # 简历模块
    path("resume/list/", resume_view.resume_list, name="resume_list"),
    path("resume/upload/", resume_view.resume_upload, name="resume_upload"),
    path(
        "resume/upload/page", resume_view.resume_upload_page, name="resume_upload_page"
    ),
    path("resumes/<str:resume_id>/", resume_view.resume_detail, name="resume_detail"),
]
