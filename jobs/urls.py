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
    path("match/update_score/", views.update_match_score, name="update_match_score"),
    path("score/history/", views.get_user_score_history, name="get_user_score_history"),
    path("score/add/", views.add_user_score, name="add_user_score"),
    path(
        "<str:company>/match_status_api/",
        views.match_status_api,
        name="match_status_api",
    ),
    path(
        "get_matching_report/<int:matching_id>",
        views.get_matching_report,
        name="get_matching_report",
    ),
]
