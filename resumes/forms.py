import json
from django import forms
from django.core.exceptions import ValidationError
from .models import Resume
from jobs.models import JobPosition


class ResumeForm(forms.ModelForm):
    related_jobs = forms.ModelMultipleChoiceField(
        queryset=JobPosition.objects.all(),
        required=False,
        widget=forms.SelectMultiple(
            attrs={"class": "form-select", "multiple": "multiple"}
        ),
    )

    education = forms.CharField(widget=forms.HiddenInput(), required=False)
    skills = forms.CharField(widget=forms.HiddenInput(), required=False)
    project_experiences = forms.CharField(widget=forms.HiddenInput(), required=False)
    working_experiences = forms.CharField(widget=forms.HiddenInput(), required=False)
    expected_positions = forms.CharField(widget=forms.HiddenInput(), required=False)

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        for field in self.fields.values():
            field.widget.attrs.update({"class": "form-control"})

    def clean_json_field(self, field_name, required_keys=None, is_dict=False):
        raw_data = self.cleaned_data.get(field_name, "[]")
        try:
            data = json.loads(raw_data)
        except Exception:
            raise ValidationError(f"{field_name} 字段不是合法的 JSON 格式")

        if not isinstance(data, list):
            raise ValidationError(f"{field_name} 应为数组结构")

        if required_keys:
            for idx, item in enumerate(data):
                if not isinstance(item, dict):
                    raise ValidationError(f"{field_name} 第 {idx+1} 项应为对象")
                missing = [k for k in required_keys if k not in item]
                if missing:
                    raise ValidationError(
                        f"{field_name} 第 {idx+1} 项缺少字段: {', '.join(missing)}"
                    )
        elif is_dict:
            for idx, item in enumerate(data):
                if not isinstance(item, str):
                    raise ValidationError(f"{field_name} 第 {idx+1} 项应为字符串")
        return data

    def clean_education(self):
        return self.clean_json_field(
            "education", required_keys=["school", "time", "details"]
        )

    def clean_skills(self):
        return self.clean_json_field("skills", is_dict=True)

    def clean_project_experiences(self):
        return self.clean_json_field(
            "project_experiences",
            required_keys=["project_name", "employment_period"],
        )

    def clean_working_experiences(self):
        return self.clean_json_field(
            "working_experiences",
            required_keys=[
                "company",
                "employment_period",
                # "all_tags",
                "job_name",
                # "department",
                # "responsibilities",
            ],
        )

    def clean_expected_positions(self):
        return self.clean_json_field(
            "expected_positions",
            required_keys=["position", "location", "salary"],
        )

    class Meta:
        model = Resume
        fields = [
            "name",
            "status",
            "personal_info",
            "phone",
            "email",
            "expected_positions",
            "education",
            "certificates",
            "skills",
            "self_evaluation",
            "project_experiences",
            "working_experiences",
            "current_status",
            "tags",
            "related_jobs",
        ]
