from . import views as core_view
from django.urls import path

urlpatterns = [
    path("", core_view.encrypt, name="encrypt"),
]
