import os
import logging

from django.core.management.base import BaseCommand
from django.conf import settings

from resumes.models import Resume
from resumes.parser import Parser
from resumes.constants import UPLOAD_FOLDER

logger = logging.getLogger(__name__)
resume_parser = Parser()


class Command(BaseCommand):
    help = "Refresh resume fields from uploaded resume file(s)"

    def add_arguments(self, parser):
        parser.add_argument(
            "resume_id",
            nargs="?",
            default=None,
            help="Optional: Specific resume_id to refresh",
        )

    def handle(self, *args, **options):
        resume_id = options["resume_id"]

        if resume_id:
            queryset = Resume.objects.filter(resume_id=resume_id)
        else:
            queryset = Resume.objects.all()

        if not queryset.exists():
            self.stderr.write(self.style.ERROR("No resume(s) found to refresh."))
            return

        total = queryset.count()
        success, failed = 0, 0

        for resume in queryset:
            rid = resume.resume_id
            file_path = os.path.join(
                settings.MEDIA_ROOT, UPLOAD_FOLDER, f"NO.{rid}.html"
            )
            if not os.path.exists(file_path):
                self.stderr.write(
                    self.style.WARNING(f"[{rid}] Resume file not found: {file_path}")
                )
                failed += 1
                continue

            try:
                resume_id_parsed, resume_dict = resume_parser.parse(file_path)
                if rid != resume_id_parsed:
                    self.stderr.write(
                        self.style.WARNING(
                            f"[{rid}] Parsed resume_id ({resume_id_parsed}) does not match original."
                        )
                    )

                # self.stdout.write(self.style.NOTICE(f"[{rid}] Parsed fields:"))
                for field, value in resume_dict.items():
                    # self.stdout.write(f"  - {field}: {value!r}")
                    setattr(resume, field, value)

                resume.save()
                # self.stdout.write(
                #     self.style.WARNING(
                #         f"[{rid}] Resume parsed and fields set, but not saved (debug mode)."
                #     )
                # )
                success += 1
            except Exception as e:
                logger.exception(f"[{rid}] Failed to refresh resume")
                self.stderr.write(self.style.ERROR(f"[{rid}] Error: {e}"))
                failed += 1

        self.stdout.write(
            self.style.SUCCESS(
                f"\nDone. Success: {success}, Failed: {failed}, Total: {total}"
            )
        )
