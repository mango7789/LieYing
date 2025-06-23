from django.shortcuts import render

# Create your views here.


def login():
    pass


def logout():
    pass


def register():
    pass


def home(request):
    return render(request, "crawls/Main.html")
