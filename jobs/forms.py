from django import forms
from .models import JobPosition, City
from .constants import (
    CITY_CHOICES,
    EDUCATION_CHOICES,
    WORK_EXPERIENCE_CHOICES,
    LANGUAGE_CHOICES,
)


class JobForm(forms.ModelForm):
    city_choices = CITY_CHOICES
    city = forms.MultipleChoiceField(
        choices=city_choices,
        required=True,
        widget=forms.SelectMultiple(attrs={"class": "form-select"}),
        label="工作地点（可多选）",
    )

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
        exclude = ["city"]  # city字段自定义处理，不用ModelForm自动处理
        fields = [
            "name",
            "company",
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

        if self.instance and self.instance.pk:
            city_qs = self.instance.city.all()
            city_list = [c.name for c in city_qs]

            std_city_codes = dict(CITY_CHOICES).keys()
            selected = [c for c in city_list if c in std_city_codes]

            self.fields["city"].initial = selected

        # GET请求时公司字段只读
        if not args and initial.get("company"):
            self.fields["company"].widget.attrs["readonly"] = True
            self.fields["company"].widget.attrs["class"] += " bg-light"

    def clean(self):
        cleaned_data = super().clean()
        selected_cities = cleaned_data.get("city") or []

        if not selected_cities:
            self.add_error("city", "请至少选择一个城市")

        # 把城市名转成 City 对象列表（不存在就创建）
        city_objs = []
        for name in selected_cities:
            city_obj, _ = City.objects.get_or_create(name=name)
            city_objs.append(city_obj)

        cleaned_data["city_objs"] = city_objs  # 新字段，方便视图使用

        if "city" in cleaned_data:
            del cleaned_data["city"]

        return cleaned_data

    def clean_company(self):
        value = self.cleaned_data["company"].strip()
        if not value:
            raise forms.ValidationError("公司名称不能为空")
        return value
