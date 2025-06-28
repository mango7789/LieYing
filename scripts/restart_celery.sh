#!/bin/bash
pkill -f 'celery -A lieying worker'
sleep 1
nohup celery -A lieying worker --loglevel=info > ./logs/celery.log 2>&1 &