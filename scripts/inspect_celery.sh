#!/bin/bash
celery -A lieying flower --port=5555 --broker=redis://:LieYing7789@localhost:6379/0
