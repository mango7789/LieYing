from typing import Final

# 城市选项 - 主要城市+自定义选项
CITY_CHOICES: Final = [
    ("北京", "北京"),
    ("上海", "上海"),
    ("广州", "广州"),
    ("深圳", "深圳"),
    ("杭州", "杭州"),
    ("南京", "南京"),
    ("苏州", "苏州"),
    ("成都", "成都"),
    ("武汉", "武汉"),
    ("重庆", "重庆"),
    # ("其他", "其他城市"),
]

# 学历要求
EDUCATION_CHOICES: Final = [
    ("不限", "不限"),
    ("大专", "大专"),
    ("本科", "本科及以上"),
    ("硕士", "硕士"),
    ("博士/博士后", "博士/博士后"),
]

# 工作年限
WORK_EXPERIENCE_CHOICES: Final = [
    ("不限", "不限"),
    ("应届生", "应届生"),
    ("1-3年", "1~3年"),
    ("3-5年", "3~5年"),
    ("5-10年", "5~10年"),
    ("10年以上", "10年以上"),
]

# 语言要求
LANGUAGE_CHOICES: Final = [
    ("不限", "不限"),
    ("英语", "英语"),
    ("日语", "日语"),
    ("德语", "德语"),
    ("法语", "法语"),
    ("其他", "其他语言"),
]


# 学历权重：越高权重越大
DEFAULT_EDUCATION_WEIGHTS = {
    "不限": 0.5,
    "大专": 0.6,
    "本科": 1.0,
    "硕士": 1.2,
    "博士/博士后": 1.4,
}

# 工作年限权重：中间经验值适中，太低或太高略低
DEFAULT_WORK_EXPERIENCE_WEIGHTS = {
    "不限": 0.5,
    "应届生": 0.6,
    "1-3年": 1.0,
    "3-5年": 1.1,
    "5-10年": 1.2,
    "10年以上": 1.0,
}
