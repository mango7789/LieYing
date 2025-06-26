import json
from django import forms
from .models import Resume


class ResumeForm(forms.ModelForm):
    education = forms.CharField(widget=forms.HiddenInput(), required=False)
    skills = forms.CharField(widget=forms.HiddenInput(), required=False)
    project_experiences = forms.CharField(widget=forms.HiddenInput(), required=False)
    working_experiences = forms.CharField(widget=forms.HiddenInput(), required=False)
    expected_positions = forms.CharField(widget=forms.HiddenInput(), required=False)

    def clean_json_field(self, field_name):
        data = self.cleaned_data.get(field_name, "[]")
        # logging.debug(data)
        try:
            return json.loads(data)
        except Exception:
            raise forms.ValidationError(f"{field_name} 格式错误")

    def clean_education(self):
        return self.clean_json_field("education")

    def clean_skills(self):
        return self.clean_json_field("skills")

    def clean_project_experiences(self):
        return self.clean_json_field("project_experiences")

    def clean_working_experiences(self):
        return self.clean_json_field("working_experiences")

    def clean_expected_positions(self):
        return self.clean_json_field("expected_positions")

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
        ]
