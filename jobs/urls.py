from . import views as job_view
from django.urls import path

urlpatterns = [
    path("list/", job_view.job_list, name="job_list"),
    path("upload/", job_view.job_upload_page, name="job_upload_page"),  # 显示上传页面
    path("upload/submit/", job_view.job_upload, name="job_upload"),  # 处理上传POST
    path("edit/<int:job_id>/", job_view.job_edit, name="job_edit"),
]
