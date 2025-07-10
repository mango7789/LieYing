from django.urls import path
from .views import InterviewListView
from . import views

urlpatterns = [
    path("interviews/", InterviewListView.as_view(), name="interview_list"),
    path('interviews/<int:pk>/', views.interview_detail, name='interview_detail'),
]