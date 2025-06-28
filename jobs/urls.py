from django.urls import path
from . import views

app_name = "jobs"

urlpatterns = [
    path("", views.company_list, name="company_list"),
    path(
        "create/", views.job_create_general, name="job_create_general"
    ),  # floor1通用创建
    path("<str:company>/", views.job_list, name="job_list"),
    path(
        "<str:company>/create/", views.job_create, name="job_create"
    ),  # floor2指定公司创建
    path("update/<int:pk>/", views.job_update, name="job_update"),
    path("delete/<int:pk>/", views.job_delete, name="job_delete"),
    path("match/start/<int:job_id>/", views.start_matching, name="start_matching"),
    path("match/result/<int:job_id>/", views.match_result, name="match_result"),
]
