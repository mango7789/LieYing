from . import views as job_view
from django.urls import path

urlpatterns = [
    path("list/", job_view.job_list, name="job_list"),
    path("add/", job_view.job_add, name="job_add"),
    path("edit/<int:job_id>/", job_view.job_edit, name="job_edit"),
]
