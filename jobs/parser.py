import os
import json
import logging
from bs4 import BeautifulSoup
from typing import Dict, List

def parse_html_file(html_path: str) -> Dict:
    """解析本地HTML文件并提取岗位数据"""
    logging.info(f"开始解析HTML文件: {html_path}")
    data_dict = {}

    try:
        with open(html_path, "r", encoding="utf-8") as f:
            html_content = f.read()

        soup = BeautifulSoup(html_content, "html.parser")

        # 岗位名称
        name_elem = soup.select_one(".job-title, .position-title, h1")
        data_dict["name"] = name_elem.text.strip() if name_elem else ""

        # 企业名称
        company_elem = soup.select_one(".company-name, .corp-name, .company")
        data_dict["company"] = company_elem.text.strip() if company_elem else ""

        # 城市
        city_elem = soup.select_one(".job-city, .city, .location")
        data_dict["city"] = city_elem.text.strip() if city_elem else ""

        # 薪资
        salary_elem = soup.select_one(".salary, .job-salary")
        data_dict["salary"] = salary_elem.text.strip() if salary_elem else ""

        # 工作年限
        work_exp_elem = soup.select_one(".work-exp, .experience")
        data_dict["work_experience"] = work_exp_elem.text.strip() if work_exp_elem else ""

        # 学历要求
        edu_elem = soup.select_one(".education, .edu, .degree")
        data_dict["education"] = edu_elem.text.strip() if edu_elem else ""

        # 语言要求
        lang_elem = soup.select_one(".language, .lang")
        data_dict["language"] = lang_elem.text.strip() if lang_elem else ""

        # 岗位职责
        resp_elem = soup.select_one(".responsibilities, .job-responsibilities")
        data_dict["responsibilities"] = resp_elem.text.strip() if resp_elem else ""

        # 岗位要求
        req_elem = soup.select_one(".requirements, .job-requirements")
        data_dict["requirements"] = req_elem.text.strip() if req_elem else ""

        logging.info(f"成功解析HTML文件: {html_path}")
        return data_dict

    except Exception as e:
        logging.error(f"解析HTML文件失败: {html_path}, 错误: {str(e)}")
        return {}

def process_html_directory(input_dir: str, output_file: str):
    """处理目录中的所有HTML文件，批量生成岗位数据"""
    logging.info(f"开始处理目录: {input_dir}")
    all_data: List[Dict] = []

    for filename in os.listdir(input_dir):
        if filename.endswith(".html"):
            html_path = os.path.join(input_dir, filename)
            data = parse_html_file(html_path)
            if data:
                all_data.append(data)

    with open(output_file, "w", encoding="utf-8") as f:
        json.dump(all_data, f, ensure_ascii=False, indent=2)

    logging.info(f"处理完成! 共解析 {len(all_data)} 个文件, 结果保存至: {output_file}")

if __name__ == "__main__":
    input_directory = "./upload_jobs"  # 存放岗位HTML文件的目录
    output_json = "./output/jobs.json"  # 输出JSON文件路径
    process_html_directory(input_directory, output_json)