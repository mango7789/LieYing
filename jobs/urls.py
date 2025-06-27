from . import views as job_view
from django.urls import path

urlpatterns = [
    path("list/", job_view.job_list, name="job_list"),
]
