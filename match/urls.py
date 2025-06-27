from . import views as match_view
from django.urls import path

urlpatterns = [
    path("list/", match_view.match_list, name="match_list"),
]
