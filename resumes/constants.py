from typing import Final

# 筛选框
CITY_CHOICES: Final = ["不限", "上海", "北京", "广州", "深圳"]
EDUCATION_CHOICES: Final = ["不限", "本科", "硕士", "博士/博士后", "大专"]
EDUCATION_LEVELS: Final = {
    "不限": 0,
    "大专": 1,
    "本科": 2,
    "硕士": 3,
    "博士/博士后": 4,
}
WORKING_Y_CHOICES: Final = ["不限", "应届生", "1~3年", "3~5年", "5~10年", "10年以上"]
WORKING_Y_RANGES = {
    "不限": (0, 1000),
    "应届生": (0, 1),
    "1~3年": (1, 3),
    "3~5年": (3, 5),
    "5~10年": (5, 10),
    "10年以上": (10, 1000),
}


# 简历上传 & 解析
MB: Final = 1024 * 1024
MAX_UPLOAD_SIZE = 5
ALLOWED_EXTENSIONS = (".xls", ".xlsx", ".html", ".htm", ".pdf")
UPLOAD_FOLDER = "resumes"
