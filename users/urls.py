from . import views as user_view
from django.urls import path

urlpatterns = [
    path("", user_view.root_redirect, name="RootRedirect"),
    path("login/", user_view.custom_login_view, name="login"),
    path("logout/", user_view.custom_logout_view, name="logout"),
    path("register/", user_view.custom_register_view, name="register"),
    path("home/", user_view.home_view, name="home"),
    path("profile/", user_view.profile_view, name="profile"),
]
