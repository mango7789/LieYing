from django import forms
from .models import JobPosition


class JobForm(forms.ModelForm):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        for field in self.fields.values():
            field.widget.attrs.update({'class': 'form-control'})

    class Meta:
        model = JobPosition
        fields = [
            "name",
            "company",
            "city",
            "salary",
            "work_experience",
            "education",
            "language",
            "responsibilities",
            "requirements",
        ]
        widgets = {
            "responsibilities": forms.Textarea(attrs={"rows": 3, "class": "form-control"}),
            "requirements": forms.Textarea(attrs={"rows": 3, "class": "form-control"}),
        }
        labels = {
            "name": "岗位名称",
            "company": "企业名称",
            "city": "工作地点",
            "salary": "薪资",
            "work_experience": "工作年限",
            "education": "学历要求",
            "language": "语言要求",
            "responsibilities": "岗位职责",
            "requirements": "岗位要求",
        }
