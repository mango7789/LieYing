import os

DEEPSEEK_API_KEY = "sk-32b86dfd76b544c6b8272774ef0e1936"
DEEPSEEK_API_URL = "https://dashscope.aliyuncs.com/compatible-mode/v1"
API_TIMEOUT = 60

os.environ.pop("HTTP_PROXY", None)
os.environ.pop("HTTPS_PROXY", None)
os.environ.pop("ALL_PROXY", None)

BATCH_SIZE = 5
MAX_SEQ_LENGTH = 4096
OUTPUT_FILE = "match_scores_result_example.json"

RESUME_PATH = "example_data/quant.json"
JOB_PATH = "example_data/job_posting.json"
