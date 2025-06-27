from django.core.management.base import BaseCommand
from match.services import run_resume_job_matching


class Command(BaseCommand):
    help = "评估简历与岗位匹配度并写入数据库。默认跳过已有匹配，使用 --overwrite 参数强制覆盖。"

    def add_arguments(self, parser):
        parser.add_argument(
            "--overwrite",
            action="store_true",
            help="是否覆盖已有匹配项的分数",
        )

    def handle(self, *args, **options):
        overwrite = options["overwrite"]
        self.stdout.write(f"开始匹配，overwrite={overwrite}")

        summary = run_resume_job_matching(overwrite_existing=overwrite)

        self.stdout.write(self.style.SUCCESS("匹配完成，统计信息："))
        for key, value in summary.items():
            self.stdout.write(f"{key}: {value}")
