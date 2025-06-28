from django import forms
from .models import JobPosition
from .constants import (
    CITY_CHOICES,
    EDUCATION_CHOICES,
    WORK_EXPERIENCE_CHOICES,
    LANGUAGE_CHOICES,
)


class JobForm(forms.ModelForm):
    # 自定义城市字段 - 支持选择或输入
    city = forms.ChoiceField(
        choices=[("", "-- 请选择或输入 --")] + CITY_CHOICES,
        required=True,
        widget=forms.Select(
            attrs={"class": "form-select", "onchange": "checkCityCustom(this)"}
        ),
    )
    custom_city = forms.CharField(
        required=False,
        widget=forms.TextInput(
            attrs={
                "class": "form-control mt-2 d-none",
                "placeholder": "输入其他城市",
                "id": "custom-city-input",
            }
        ),
        label="",
    )

    # 其他字段使用选择框
    education = forms.ChoiceField(
        choices=EDUCATION_CHOICES, widget=forms.Select(attrs={"class": "form-select"})
    )

    work_experience = forms.ChoiceField(
        choices=WORK_EXPERIENCE_CHOICES,
        widget=forms.Select(attrs={"class": "form-select"}),
    )

    language = forms.ChoiceField(
        choices=LANGUAGE_CHOICES, widget=forms.Select(attrs={"class": "form-select"})
    )

    company = forms.CharField(
        max_length=100,
        required=True,
        widget=forms.TextInput(
            attrs={"class": "form-control", "placeholder": "请输入公司名称"}
        ),
    )

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
            "name": forms.TextInput(attrs={"class": "form-control"}),
            "salary": forms.TextInput(attrs={"class": "form-control"}),
            "responsibilities": forms.Textarea(
                attrs={
                    "class": "form-control",
                    "rows": 4,
                    "placeholder": "每条职责用换行分隔",
                }
            ),
            "requirements": forms.Textarea(
                attrs={
                    "class": "form-control",
                    "rows": 4,
                    "placeholder": "每条要求用换行分隔",
                }
            ),
        }
        labels = {
            "name": "岗位名称",
            "salary": "薪资范围",
            "responsibilities": "岗位职责",
            "requirements": "岗位要求",
        }

    def __init__(self, *args, **kwargs):
        initial = kwargs.get("initial", {})
        super().__init__(*args, **kwargs)

        # city 字段初始化
        if self.instance and self.instance.city:
            if self.instance.city not in dict(CITY_CHOICES).keys():
                self.fields["city"].initial = "其他"
                self.fields["custom_city"].initial = self.instance.city
            else:
                self.fields["city"].initial = self.instance.city

        # 仅在 GET（未提交表单）时 company 字段只读
        if not args and initial.get("company"):
            self.fields["company"].widget.attrs["readonly"] = True
            self.fields["company"].widget.attrs["class"] += " bg-light"

    def clean(self):
        cleaned_data = super().clean()
        city = cleaned_data.get("city")
        custom_city = cleaned_data.get("custom_city")

        # 处理城市字段
        if city == "其他" and custom_city:
            cleaned_data["city"] = custom_city.strip()
        elif city == "其他" and not custom_city:
            self.add_error("custom_city", "请输入城市名称")
        elif city == "":
            self.add_error("city", "请选择或输入城市")

        # 清理自定义城市字段（不保存到数据库）
        if "custom_city" in cleaned_data:
            del cleaned_data["custom_city"]

        return cleaned_data

    def clean_company(self):
        value = self.cleaned_data["company"].strip()
        if not value:
            raise forms.ValidationError("公司名称不能为空")
        return value
