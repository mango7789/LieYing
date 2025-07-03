from django.core.management.base import BaseCommand
from resumes.models import Resume


class Command(BaseCommand):
    help = "批量解析 personal_info 并填入简历字段"

    def handle(self, *args, **kwargs):
        resumes = Resume.objects.all()
        for r in resumes:
            # parsed = parse_required_info(r.personal_info)
            # r.gender = parsed.get("gender", "")
            # r.age = int(parsed.get("age", 0) or 0) if parsed.get("age") else None
            # r.education_level = parsed.get("education", "")
            # r.work_years = parsed.get("work_experience", "")
            # r.position = parsed.get("position", "")
            # r.company_name = parsed.get("company", "")
            r.save()
        self.stdout.write(self.style.SUCCESS("简历字段批量填充完成"))
