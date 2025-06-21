from django.contrib import admin
from .models import JobPosition, JobOwner

# Register your models here.
admin.site.register(JobPosition)
admin.site.register(JobOwner)