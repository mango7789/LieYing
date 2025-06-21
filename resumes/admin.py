from django.contrib import admin
from .models import Resume, ResumeVersion

# Register your models here.
admin.site.register(Resume)
admin.site.register(ResumeVersion)