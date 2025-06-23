from typing import Final

# 筛选框
CITY_CHOICES: Final = ["不限", "上海", "北京", "广州", "深圳"]
EDUCATION_CHOICES: Final = ["不限", "本科", "硕士", "博士/博士后", "大专"]
WORKING_Y_CHOICES: Final = ["不限", "应届生", "1~3年", "3~5年", "5~10年", "10年以上"]

# 简历上传 & 解析
MB: Final = 1024 * 1024
MAX_UPLOAD_SIZE = 5
ALLOWED_EXTENSIONS = (".xls", ".xlsx", ".html", ".htm", ".pdf")
UPLOAD_FOLDER = "resumes"