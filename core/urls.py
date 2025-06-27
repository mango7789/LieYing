from . import views as core_view
from django.urls import path

urlpatterns = [
    path("encrypt/", core_view.encrypt, name="encrypt"),
]
