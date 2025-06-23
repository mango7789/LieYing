from django.shortcuts import render
from django.contrib.auth.decorators import login_required


# Create your views here.
@login_required
def job_list_aggregate():
    pass


@login_required
def job_list_single():
    pass


@login_required
def job_edit():
    pass


@login_required
def job_delete():
    pass
