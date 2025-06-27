import sys
from django.apps import AppConfig


class MatchConfig(AppConfig):
    default_auto_field = "django.db.models.BigAutoField"
    name = "match"

    def ready(self):
        from apscheduler.schedulers.background import BackgroundScheduler
        from django_apscheduler.jobstores import DjangoJobStore, register_events
        from .services import run_resume_job_matching

        scheduler = BackgroundScheduler()
        scheduler.add_jobstore(DjangoJobStore(), "default")

        scheduler.add_job(
            run_resume_job_matching,
            trigger="interval",
            minutes=60,
            id="resume_job_matching",
            kwargs={"overwrite_existing": False},
            replace_existing=True,
        )

        register_events(scheduler)
        if "runserver" in sys.argv or "evaluate_matches" in sys.argv:
            scheduler.start()
