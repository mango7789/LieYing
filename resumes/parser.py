import os
import sys
import time
import json
import random
import logging
import re
from bs4 import BeautifulSoup
from typing import Dict, Final
import fitz
from .models import Resume
import pdfplumber

logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)


class Parser:
    def __init__(self):
        pass

    def parse(self, file_name: str):
        """处理目录中的所有HTML文件"""
        logging.info(f"开始处理文件: {file_name}")

        if file_name.endswith(".html"):
            data = self._parse_html(file_name)
        elif file_name.lower().endswith(".pdf"):
            data = self._parse_pdf(file_name)

        if data and isinstance(data, dict):
            resume_id = data["resume_id"]

        logging.info(f"文件解析完成: {resume_id}")

        data = self._clean_dict(data)

        return resume_id, data

    def _parse_html(self, html_path: str) -> Dict:
        """解析本地HTML文件并提取简历数据"""
        logging.info(f"开始解析HTML文件: {html_path}")
        data_dict = {}

        try:
            # 读取HTML文件内容
            with open(html_path, "r", encoding="utf-8") as f:
                html_content = f.read()

            # 使用BeautifulSoup解析HTML
            soup = BeautifulSoup(html_content, "html.parser")

            # 提取名字
            name_elem = soup.select_one("div.name-box > h4.name.ellipsis")
            data_dict["name"] = name_elem.text.strip() if name_elem else ""

            # 提取简历ID
            resume_id_elem = soup.select_one('div[class*="BTVlw"] span')
            data_dict["resume_id"] = (
                resume_id_elem.text.strip()[5:] if resume_id_elem else ""
            )

            # 提取最后登录时间
            last_login_elem = soup.select_one('span:contains("最后一次登录时间")')
            data_dict["last_login"] = (
                last_login_elem.text.strip()[9:] if last_login_elem else ""
            )

            # 提取状态
            status_elem = soup.select_one("span.user-status-tag")
            data_dict["status"] = status_elem.text.strip() if status_elem else ""

            # 提取个人信息
            personal_info = []
            info_elems = soup.select("div.sep-info")
            for elem in info_elems:
                strings = list(elem.stripped_strings)
                filtered = [s for s in strings if s]
                personal_info.append(" ".join(filtered))
            data_dict["personal_info"] = " | ".join(personal_info)

            # 提取求职意向
            expected_positions = []
            job_intention_div = soup.select_one('h3:contains("求职意向") + div.tabs')

            if job_intention_div:
                position = job_intention_div.select_one("span.title[title]")
                location = job_intention_div.select_one("span.title:not([title])")
                salary = job_intention_div.select_one("span.salary")

                pos_data = {
                    "position": position.text.strip() if position else "",
                    "location": location.text.strip() if location else "",
                    "salary": salary.text.strip() if salary else "",
                }

                # 只要至少一个字段有内容就加入
                if any(pos_data.values()):
                    expected_positions.append(pos_data)

            # 备选：旧结构下的兜底方式
            if not expected_positions:
                pos_data = {"position": "", "location": "", "salary": ""}
                intention_elems = soup.select(
                    "#resume-detail-job-exp-info > div:nth-child(1) > div:nth-child(1) > span"
                )
                for elem in intention_elems:
                    text = elem.text.strip()
                    if "职位" in text:
                        pos_data["position"] = text.split("：")[-1].strip()
                    elif "地点" in text:
                        pos_data["location"] = text.split("：")[-1].strip()
                    elif "薪资" in text or "待遇" in text:
                        pos_data["salary"] = text.split("：")[-1].strip()
                if any(pos_data.values()):
                    expected_positions.append(pos_data)

            data_dict["expected_positions"] = expected_positions

            # 教育经历（结构化数据）
            education_list = []
            edu_elems = soup.select(".edu-school-cont")
            for elem in edu_elems:
                education_list.append(elem.text.replace("\n", " ").strip())
            data_dict["education"] = education_list

            # 提取资格证书
            certificates = []
            cert_elems = soup.select(".credential-tag")
            for elem in cert_elems:
                certificates.append(elem.text.strip())
            data_dict["certificates"] = certificates

            # 提取语言能力
            languages = []
            lang_elems = soup.select(".rd-lang-item")
            for elem in lang_elems:
                lang_name = elem.select_one(".lang-name")
                lang_levels = elem.select(".lang-level")
                if lang_name:
                    lang_data = {
                        "type": lang_name.text.strip(),
                        "level": [level.text.strip() for level in lang_levels],
                    }
                    languages.append(lang_data)
            data_dict["languages"] = languages

            # 提取技能
            skills = []
            skill_elems = soup.select(".skill-tag")
            for elem in skill_elems:
                skills.append(elem.text.strip())
            data_dict["skills"] = skills

            # 提取自我评价
            self_eval_elem = soup.select_one("#resume-detail-self-eva-info > div > div")
            data_dict["self_evaluation"] = (
                self_eval_elem.text.strip() if self_eval_elem else ""
            )

            # 提取工作经历
            work_experience = []
            work_elems = soup.select(".rd-info-tpl-item.rd-work-item-cont")
            for work in work_elems:
                work_head = work.select_one(".rd-info-tpl-item-head")
                work_cont = work.select_one(".rd-info-tpl-item-cont")

                work_data = {
                    "company": (
                        work_head.select_one("h5.ellipsis").text.strip()
                        if work_head.select_one("h5.ellipsis")
                        else ""
                    ),
                    "employment_period": (
                        work_head.select_one("span.rd-work-time").text.strip()
                        if work_head.select_one("span.rd-work-time")
                        else ""
                    ),
                    "job_name": (
                        work_cont.select_one("h6.job-name").text.strip()
                        if work_cont.select_one("h6.job-name")
                        else ""
                    ),
                }

                # 提取工作详情
                info_rows = work_cont.select(".rd-info-row")
                for row in info_rows:
                    cols = row.select(".rd-info-col")
                    for col in cols:
                        title_elem = col.select_one(".rd-info-col-title")
                        content_elem = col.select_one(".rd-info-col-cont")
                        if title_elem and content_elem:
                            title = title_elem.text.strip("：")
                            content = content_elem.text.strip().replace("\n", " ")
                            if title == "薪   资":
                                work_data["salary"] = content
                            elif title == "职位类别":
                                work_data["position_category"] = content
                            elif title == "职责业绩":
                                work_data["responsibilities"] = content
                            elif title == "所在部门":
                                work_data["department"] = content

                work_experience.append(work_data)
            data_dict["working_experiences"] = work_experience

            # 提取项目经历
            project_experience = []
            project_elems = soup.select(".rd-info-tpl-item.rd-project-item-cont")
            for project in project_elems:
                project_head = project.select_one(".rd-info-tpl-item-head")
                project_cont = project.select_one(".rd-info-tpl-item-cont")

                project_data = {
                    "project_name": (
                        project_head.select_one("h5.ellipsis").text.strip()
                        if project_head.select_one("h5.ellipsis")
                        else ""
                    ),
                    "employment_period": (
                        project_head.select_one("span.rd-project-time").text.strip()
                        if project_head.select_one("span.rd-project-time")
                        else ""
                    ),
                }

                # 提取项目详情
                info_rows = project_cont.select(".rd-info-row")
                for row in info_rows:
                    cols = row.select(".rd-info-col")
                    for col in cols:
                        title_elem = col.select_one(".rd-info-col-title")
                        content_elem = col.select_one(".rd-info-col-cont")
                        if title_elem and content_elem:
                            title = title_elem.text.strip("：")
                            content = content_elem.text.strip().replace("\n", " ")
                        if title == "项目职务":
                            project_data["project_role"] = content
                        elif title == "所在公司":
                            project_data["company"] = content
                        elif title == "项目描述":
                            project_data["project_description"] = content
                        elif title == "项目职责":
                            project_data["responsibilities"] = content
                        elif title == "项目业绩":
                            project_data["project_achievement"] = content

                project_experience.append(project_data)
            data_dict["project_experiences"] = project_experience

            logging.info(f"成功解析HTML文件: {html_path}")
            return data_dict

        except Exception as e:
            logging.error(f"解析HTML文件失败: {html_path}, 错误: {str(e)}")
            return {}

    def _parse_pdf(self, pdf_path: str) -> Dict:
        # 联系人信息正则表达式
        phone_pattern = re.compile(r"\d{3}[-.\s]?\d{3}[-.\s]?\d{4}")
        email_pattern = re.compile(r"[\w\.-]+@[\w\.-]+\.\w+")

        # 最终结果容器 - 扩展为包含所有字段
        result = {
            "resume_id": os.path.basename(pdf_path).split(".")[0],
            "name": "",
            "phone": "",
            "email": "",
            "github": "",
            "linkedin": "",
            "information": "",
            "expectation": "",
            "education": [],
            "work_experience": [],
            "project_experience": [],
            "skills": [],
            "certificates": [],
            "languages": [],
            "self_assessment": "",
        }

        all_text = ""

        try:
            with pdfplumber.open(pdf_path) as pdf:
                # 提取所有文本，保留页面结构信息
                for page in pdf.pages:
                    text = page.extract_text()
                    if text:
                        # 添加页码标记，帮助保留页面边界
                        text = f"--- Page {page.page_number} ---\n{text}\n--- Page End ---\n"
                        all_text += text

            # 提取各部分内容
            sections = self.extract_sections(all_text)

            # 调试：输出各部分的概要
            for key, value in sections.items():
                logging.info(f"Section: {key}, content length: {len(value)} characters")

            # 提取联系人信息 - 使用原始代码中的全局搜索逻辑
            phones = phone_pattern.findall(all_text)
            emails = email_pattern.findall(all_text)
            result["phone"] = list(set(phones))
            result["email"] = list(set(emails))

            print(result)
            # 解析个人信息
            if sections["personal_info"]:
                contact_info = sections["personal_info"]

                # 1. 提取姓名
                if sections["name"]:
                    # 尝试提取姓名标签后的内容
                    name_match = re.search(
                        r"(?:姓名|名字|Name)[:：\s]*(.+)",
                        sections["name"],
                        re.IGNORECASE,
                    )
                    if name_match:
                        result["name"] = name_match.group(1).strip()
                        # 保留个人信息但不包含姓名
                        contact_info = contact_info.replace(name_match.group(0), "")
                    else:
                        # 如果没有标签，尝试取第一行不含数字的内容
                        first_line = sections["name"].split("\n")[0].strip()
                        if first_line and not any(
                            char.isdigit() for char in first_line
                        ):
                            result["name"] = first_line

                # 如果没有在name部分找到，尝试从个人信息中提取
                if not result["name"]:
                    name_match = re.search(
                        r"(?:姓名|名字|Name)[:：\s]*(.+)", contact_info, re.IGNORECASE
                    )
                    if name_match:
                        result["name"] = name_match.group(1).strip()
                        contact_info = contact_info.replace(name_match.group(0), "")

                # 提取GitHub链接
                github_match = re.search(r"github\.com/[\w-]+", contact_info)
                if github_match:
                    result["github"] = "https://" + github_match.group()

                # 提取领英链接
                linkedin_match = re.search(r"linkedin\.com/in/[\w-]+", contact_info)
                if linkedin_match:
                    result["linkedin"] = "https://" + linkedin_match.group()

                # 将剩余信息存入information字段
                result["information"] = contact_info.strip()

            # 解析求职意向（如果个人信息中包含）
            if "求职意向" in all_text or "Career Objective" in all_text:
                match = re.search(
                    r"(?:求职意向|期望职位|Career Objective)[:：](.*?)(?:\n|$)",
                    all_text,
                    re.IGNORECASE,
                )
                if match:
                    result["expectation"] = match.group(1).strip()

            # 解析教育经历
            if sections["education"]:
                # 尝试分割多条教育经历
                edu_items = re.split(
                    r"(?<=\d{4}[./年])\s*(?:[-~至]\s*)?(?=\d{4})|(?<=至今)\s|●",
                    sections["education"],
                )
                for item in edu_items:
                    if item.strip():
                        # 尝试提取学校名称和时间
                        school_match = re.search(
                            r"(.+?大学|.+?学院|.+?学校|.+\bUniversity|.+\bCollege)",
                            item,
                        )
                        time_match = re.search(
                            r"(\d{4}[-./年]\s*[-\~至]?\s*\d{4}[-./年]?|\d{4}年\d{1,2}月[\s至-]+\d{4}年\d{1,2}月)",
                            item,
                        )

                        edu_entry = {
                            "school": school_match.group(0) if school_match else "",
                            "time": time_match.group(0) if time_match else "",
                            "details": item.strip(),
                        }
                        result["education"].append(edu_entry)

            # 解析工作经历
            if sections["work_experience"]:
                # 尝试分割多条工作经历
                work_items = re.split(
                    r"(?<=\d{4}[./年])\s*(?:[-~至]\s*)?(?=\d{4})|(?<=至今)\s|●|◆|\d{4}[年./]\d{1,2}月",
                    sections["work_experience"],
                )
                for item in work_items:
                    if item.strip():
                        # 尝试提取公司名称和时间
                        company_match = re.search(
                            r"(.+?公司|.+?科技|.+?集团|.+\bCo\.|.+\bInc\.|.+\bLtd\.)",
                            item,
                        )
                        time_match = re.search(
                            r"(\d{4}[./年]\s*[-\~至]?\s*\d{4}[./年]?|至今|\d{4}[-./年]\d{1,2}月)",
                            item,
                        )

                        work_entry = {
                            "company": company_match.group(0) if company_match else "",
                            "employment_period": (
                                time_match.group(0) if time_match else ""
                            ),
                            "details": item.strip(),
                        }
                        result["work_experience"].append(work_entry)

            # 解析项目经历
            if sections["project_experience"]:
                # 分割多个项目
                project_items = re.split(
                    r"\n(?=\d{4}|项目名称|项目\d+[.:：]|\d+[-.] )",
                    sections["project_experience"],
                )
                for item in project_items:
                    if item.strip():
                        # 尝试提取项目名称和时间
                        name_match = re.search(
                            r"(项目名称|项目名称|项目|Project)[:：]?\s*(.+)", item
                        )
                        time_match = re.search(
                            r"(\d{4}[./年]\s*[-\~至]?\s*\d{4}[./年]?|\d{4}/\d{1,2}[-~]\d{4}/\d{1,2})",
                            item,
                        )

                        project_entry = {
                            "project_name": (
                                name_match.group(2).strip() if name_match else ""
                            ),
                            "time": time_match.group(0) if time_match else "",
                            "details": item.strip(),
                        }
                        result["project_experience"].append(project_entry)

            # 解析专业技能
            if sections["skills"]:
                # 分割技能列表 - 支持多种分隔符
                skills = re.split(r"[,;、，；]|(?:\n\s*[-●•])", sections["skills"])
                # 过滤空项和短项
                result["skills"] = [
                    skill.strip() for skill in skills if len(skill.strip()) > 2
                ]

                # 如果没有分割出有效技能，尝试逐行处理
                if not result["skills"]:
                    result["skills"] = [
                        line.strip()
                        for line in sections["skills"].split("\n")
                        if line.strip()
                    ]

            # 解析证书
            if sections["certificates"]:
                # 分割证书列表 - 支持多种分隔符
                certs = re.split(r"[,;、，；]|(?:\n\s*[-●•])", sections["certificates"])
                # 过滤空项和短项
                result["certificates"] = [
                    cert.strip() for cert in certs if len(cert.strip()) > 2
                ]

                # 如果没有分割出有效证书，尝试逐行处理
                if not result["certificates"]:
                    result["certificates"] = [
                        line.strip()
                        for line in sections["certificates"].split("\n")
                        if line.strip()
                    ]

            # 解析语言能力
            if sections["languages"]:
                # 分割语言条目
                langs = re.findall(
                    r"(\w+?语?)\s*[:：]?\s*([良好精通熟练基本]+|\w+级)",
                    sections["languages"],
                )
                for lang, level in langs:
                    if lang.strip():
                        result["languages"].append(
                            {"type": lang.strip(), "level": level.strip()}
                        )

                # 如果没有找到匹配，尝试提取简单列表
                if not result["languages"]:
                    lang_items = re.split(r"[,;、，；]", sections["languages"])
                    for item in lang_items:
                        if item.strip():
                            result["languages"].append(
                                {"type": item.strip(), "level": ""}
                            )

            # 解析自我评价
            if sections["self_assessment"]:
                result["self_assessment"] = sections["self_assessment"]

            logging.info(f"成功解析PDF文件: {pdf_path}")
            return result

        except Exception as e:
            logging.error(f"解析PDF文件失败: {pdf_path}, 错误: {str(e)}")
            # 返回基本结构避免程序崩溃
            return {
                "resume_id": os.path.basename(pdf_path).split(".")[0],
                "error": f"解析失败: {str(e)}",
            }

    def extract_sections(self, pdf_text: str) -> Dict[str, str]:
        """识别简历中的各个部分并提取内容"""
        sections = {
            "personal_info": r"(?i)(个人信息|基本资料|个人资料)",
            "name": r"(?i)(姓名|名字|Name)",
            "education": r"(?i)(教育经历|教育背景|EDUCATION)",
            "work_experience": r"(?i)(工作经历|工作经验|工作履历|WORK EXPERIENCE)",
            "project_experience": r"(?i)(项目经历|项目经验|PROJECTS)",
            "skills": r"(?i)(专业技能|技术能力|技能专长|SKILLS)",
            "certificates": r"(?i)(证书|资格证书|认证|CERTIFICATES)",
            "languages": r"(?i)(语言能力|语言|LANGUAGES)",
            "self_assessment": r"(?i)(自我评价|关于我|SELF ASSESSMENT)",
        }

        section_contents = {key: "" for key in sections.keys()}
        section_starts = {key: -1 for key in sections.keys()}

        # 找到各部分的起始位置
        for section, pattern in sections.items():
            match = re.search(pattern, pdf_text)
            if match:
                section_starts[section] = match.start()

        # 对部分位置排序，确定边界
        ordered_sections = sorted(
            [(pos, sec) for sec, pos in section_starts.items() if pos != -1]
        )

        # 提取各部分内容
        for i, (start_pos, section) in enumerate(ordered_sections):
            end_pos = (
                ordered_sections[i + 1][0]
                if i < len(ordered_sections) - 1
                else len(pdf_text)
            )
            section_contents[section] = pdf_text[start_pos:end_pos].strip()

            # 移除标题行
            title_pattern = sections[section] + r".*?[\n\s]*"
            section_contents[section] = re.sub(
                title_pattern, "", section_contents[section], flags=re.IGNORECASE
            )

        # 提取个人信息块（通常是第一部分）
        if section_starts["personal_info"] > 0:
            section_contents["personal_info"] = pdf_text[
                : section_starts["personal_info"]
            ]
        else:
            # 如果没有明确的个人信息标题，尝试使用第一段作为个人信息
            section_contents["personal_info"] = re.split(r"\n\n", pdf_text)[0]

        return section_contents

    def _clean_dict(self, data: Dict) -> Dict:
        model_fields = set(f.name for f in Resume._meta.get_fields())
        clean_dict = {k: v for k, v in data.items() if k in model_fields}
        return clean_dict
