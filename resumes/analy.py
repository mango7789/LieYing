import os
import sys
import time
import json
import random
import logging
from bs4 import BeautifulSoup
from typing import Dict

# 移除所有与Selenium相关的导入
# 保留必要的工具函数
from utils import setup_logger, load_json, init_dirs, format_elapsed_time

# 修改配置路径
CONFIG_PATH: Final = "./config/local.json"  # 可以改为本地配置
TEMPLATE_PATH: Final = "./template/task.json"

def parse_html_file(html_path: str) -> Dict:
    """解析本地HTML文件并提取简历数据"""
    logging.info(f"开始解析HTML文件: {html_path}")
    data_dict = {}
    
    try:
        # 读取HTML文件内容
        with open(html_path, 'r', encoding='utf-8') as f:
            html_content = f.read()
        
        # 使用BeautifulSoup解析HTML
        soup = BeautifulSoup(html_content, 'html.parser')
        
        # 提取简历ID
        resume_id_elem = soup.select_one('div[class*="resume-detail-single"] span')
        data_dict["resume_id"] = resume_id_elem.text.strip()[5:] if resume_id_elem else ""
        
        # 提取最后登录时间
        last_login_elem = soup.select_one('span:contains("最后登录")')
        data_dict["last_login"] = last_login_elem.text.strip()[9:] if last_login_elem else ""
        
        # 提取状态
        status_elem = soup.select_one('#resume-detail-basic-info div span')
        data_dict["status"] = status_elem.text.strip() if status_elem else ""
        
        # 提取个人信息
        personal_info = []
        info_elems = soup.select('#resume-detail-basic-info > div:nth-child(3) > div')
        for elem in info_elems:
            if elem.find('span') and 'text' in elem.span.attrs.get('class', []):
                personal_info.append(elem.text.strip())
        data_dict["information"] = " | ".join(personal_info)
        
        # 提取求职意向
        job_intention = []
        intention_elems = soup.select('#resume-detail-job-exp-info > div:nth-child(1) > div:nth-child(1) > span')
        for elem in intention_elems:
            job_intention.append(elem.text.strip())
        data_dict["expectation"] = " | ".join(job_intention)
        
        # 提取教育经历
        education = []
        edu_elems = soup.select('.edu-school-cont')
        for elem in edu_elems:
            education.append(elem.text.replace('\n', ' ').strip())
        data_dict["education"] = education
        
        # 提取资格证书
        certificates = []
        cert_elems = soup.select('.credential-tag')
        for elem in cert_elems:
            certificates.append(elem.text.strip())
        data_dict["certificates"] = certificates
        
        # 提取语言能力
        languages = []
        lang_elems = soup.select('.rd-lang-item')
        for elem in lang_elems:
            lang_name = elem.select_one('.lang-name')
            lang_levels = elem.select('.lang-level')
            if lang_name:
                lang_data = {
                    "type": lang_name.text.strip(),
                    "level": [level.text.strip() for level in lang_levels]
                }
                languages.append(lang_data)
        data_dict["languages"] = languages
        
        # 提取技能
        skills = []
        skill_elems = soup.select('.skill-tag')
        for elem in skill_elems:
            skills.append(elem.text.strip())
        data_dict["skills"] = skills
        
        # 提取自我评价
        self_eval_elem = soup.select_one('#resume-detail-self-eva-info > div > div')
        data_dict["self_assessment"] = self_eval_elem.text.strip() if self_eval_elem else ""
        
        # 提取工作经历
        work_experience = []
        work_elems = soup.select('.rd-info-tpl-item.rd-work-item-cont')
        for work in work_elems:
            work_head = work.select_one('.rd-info-tpl-item-head')
            work_cont = work.select_one('.rd-info-tpl-item-cont')
            
            work_data = {
                "company": work_head.select_one('h5.ellipsis').text.strip() if work_head.select_one('h5.ellipsis') else "",
                "employment_period": work_head.select_one('span.rd-work-time').text.strip() if work_head.select_one('span.rd-work-time') else "",
                "job_name": work_cont.select_one('h6.job-name').text.strip() if work_cont.select_one('h6.job-name') else ""
            }
            
            # 提取工作详情
            info_rows = work_cont.select('.rd-info-row')
            for row in info_rows:
                cols = row.select('.rd-info-col')
                for col in cols:
                    title_elem = col.select_one('.rd-info-col-title')
                    content_elem = col.select_one('.rd-info-col-cont')
                    if title_elem and content_elem:
                        title = title_elem.text.strip('：')
                        content = content_elem.text.strip().replace('\n', ' ')
                        work_data[title] = content
            
            work_experience.append(work_data)
        data_dict["work_experience"] = work_experience
        
        # 提取项目经历
        project_experience = []
        project_elems = soup.select('.rd-info-tpl-item.rd-project-item-cont')
        for project in project_elems:
            project_head = project.select_one('.rd-info-tpl-item-head')
            project_cont = project.select_one('.rd-info-tpl-item-cont')
            
            project_data = {
                "project_name": project_head.select_one('h5.ellipsis').text.strip() if project_head.select_one('h5.ellipsis') else "",
                "employment_period": project_head.select_one('span.rd-project-time').text.strip() if project_head.select_one('span.rd-project-time') else ""
            }
            
            # 提取项目详情
            info_rows = project_cont.select('.rd-info-row')
            for row in info_rows:
                cols = row.select('.rd-info-col')
                for col in cols:
                    title_elem = col.select_one('.rd-info-col-title')
                    content_elem = col.select_one('.rd-info-col-cont')
                    if title_elem and content_elem:
                        title = title_elem.text.strip('：')
                        content = content_elem.text.strip().replace('\n', ' ')
                        project_data[title] = content
            
            project_experience.append(project_data)
        data_dict["project_experience"] = project_experience
        
        logging.info(f"成功解析HTML文件: {html_path}")
        return data_dict
        
    except Exception as e:
        logging.error(f"解析HTML文件失败: {html_path}, 错误: {str(e)}")
        return {}

def process_html_directory(input_dir: str, output_file: str):
    """处理目录中的所有HTML文件"""
    logging.info(f"开始处理目录: {input_dir}")
    all_data = []
    
    # 遍历目录中的所有HTML文件
    for filename in os.listdir(input_dir):
        if filename.endswith(".html"):
            html_path = os.path.join(input_dir, filename)
            data = parse_html_file(html_path)
            if data:
                all_data.append(data)
    
    # 保存结果到JSON文件
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(all_data, f, ensure_ascii=False, indent=2)
    
    logging.info(f"处理完成! 共解析 {len(all_data)} 个文件, 结果保存至: {output_file}")

if __name__ == "__main__":
    # 初始化
    init_dirs()
    setup_logger(True)  # 启用日志
    
    # 示例用法
    input_directory = "./html_files"  # 存放HTML文件的目录
    output_json = "./output/resumes.json"  # 输出JSON文件路径
    
    process_html_directory(input_directory, output_json)