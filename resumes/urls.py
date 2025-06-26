from . import views as resume_view
from django.urls import path

urlpatterns = [
    path("list/", resume_view.resume_list, name="resume_list"),
    path("upload/", resume_view.resume_upload, name="resume_upload"),
    path("confirm/", resume_view.resume_confirm, name="resume_confirm"),
    path("upload/page", resume_view.resume_upload_page, name="resume_upload_page"),
    path("upload/hist/", resume_view.resume_upload_list, name="resume_upload_history"),
    path(
        "detail/<str:resume_id>/",
        resume_view.resume_detail,
        name="resume_detail",
    ),
    path("edit/<str:resume_id>/", resume_view.resume_edit, name="resume_edit"),
]
