from django.contrib import admin
from .models import JobPosition, JobOwner, UserScore, JobFieldWeight, JobChoiceWeight

# Register your models here.
admin.site.register(JobPosition)
admin.site.register(JobOwner)
admin.site.register(UserScore)
admin.site.register(JobFieldWeight)
admin.site.register(JobChoiceWeight)
