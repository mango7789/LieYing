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
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    # 超级管理员
    path("admin/", admin.site.urls),
    # 功能
    path("core/", include("core.urls")),
    # 用户/管理员 处理注册、登录、权限管理
    path("", include("users.urls")),
    # 简历模块
    path("resume/", include("resumes.urls")),
    # 工作模块
    path("job/", include("jobs.urls")),
    # 打分（匹配）模块
    path("match/", include("match.urls")),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
