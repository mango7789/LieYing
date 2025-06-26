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
            name_elem = soup.select_one('div.name-box > h4.name.ellipsis')
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
            job_intention = []
            job_intention_div = soup.select_one('h3:contains("求职意向") + div.tabs')
            if job_intention_div:
                position = job_intention_div.select_one("span.title[title]")
                location = job_intention_div.select_one("span.title:not([title])")
                salary = job_intention_div.select_one("span.salary")

                if position and position.text.strip():
                    job_intention.append(f"职位: {position.text.strip()}")
                if location and location.text.strip():
                    job_intention.append(f"地点: {location.text.strip()}")
                if salary and salary.text.strip():
                    job_intention.append(f"薪资: {salary.text.strip()}")

            if not job_intention:
                intention_elems = soup.select(
                    "#resume-detail-job-exp-info > div:nth-child(1) > div:nth-child(1) > span"
                )
                for elem in intention_elems:
                    if elem.text.strip():
                        job_intention.append(elem.text.strip())
            data_dict["expected_positions"] = (
                " | ".join(job_intention) if job_intention else "未提供求职意向"
            )

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
                            work_data[title] = content

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
                            project_data[title] = content

                project_experience.append(project_data)
            data_dict["project_experiences"] = project_experience

            logging.info(f"成功解析HTML文件: {html_path}")
            return data_dict

        except Exception as e:
            logging.error(f"解析HTML文件失败: {html_path}, 错误: {str(e)}")
            return {}

    def _parse_pdf(self, pdf_path: str) -> Dict:
        """解析PDF简历文件并提取结构化信息"""
        logging.info(f"开始解析PDF文件: {pdf_path}")
        data_dict = {
            "resume_id": os.path.basename(pdf_path).split(".")[0],
            "name": "",
            "phone": "",
            "email": "",
            "github": "",
            "linkedin": "",
            "last_login": "",
            "status": "",
            "information": "",
            "expectation": "",
            "education": [],
            "certificates": [],
            "languages": [],
            "skills": [],
            "self_assessment": "",
            "work_experience": [],
            "project_experience": [],
        }

        try:
            # 打开PDF文件
            doc = fitz.open(pdf_path)
            full_text = ""

            # 提取所有文本
            for page in doc:
                text = page.get_text()
                # 清理文本：移除多余空格和空行
                text = re.sub(r"\s+", " ", text).strip()
                full_text += text + "\n"

            # 提取各部分内容
            sections = self.extract_sections(full_text)

            for key, value in sections.items():
                print(f"Section: {key}, {value[:100]}...")  # 打印每个部分的前100个字符
            # 解析个人信息
            if sections["personal_info"]:
                # 1. 提取姓名
                if sections["name"]:
                    # 尝试提取姓名标签后的内容
                    name_match = re.search(
                        r"(?:姓名|名字)[:：\s]*(.+)", sections["name"], re.IGNORECASE
                    )
                    if name_match:
                        data_dict["name"] = name_match.group(1).strip()
                    else:
                        # 如果没有标签，尝试取第一行
                        first_line = sections["name"].split("\n")[0].strip()
                        if first_line and not any(
                            char.isdigit() for char in first_line
                        ):
                            data_dict["name"] = first_line

                # 2. 提取联系方式
                contact_info = sections["personal_info"]

                # 提取电话号码
                phone_match = re.search(
                    r"(\+?\d{1,4}?[-.\s]?$?\d{1,4}$?[-.\s]?\d{1,4}[-.\s]?\d{1,9})",
                    contact_info,
                )
                if phone_match:
                    data_dict["phone"] = phone_match.group().strip()

                # 提取电子邮箱
                email_match = re.search(r"[\w\.-]+@[\w\.-]+\.\w+", contact_info)
                if email_match:
                    data_dict["email"] = email_match.group().strip()

                # 提取GitHub链接
                github_match = re.search(r"github\.com/[\w-]+", contact_info)
                if github_match:
                    data_dict["github"] = "https://" + github_match.group()

                # 提取领英链接
                linkedin_match = re.search(r"linkedin\.com/in/[\w-]+", contact_info)
                if linkedin_match:
                    data_dict["linkedin"] = "https://" + linkedin_match.group()

                # 将剩余信息存入information字段
                data_dict["information"] = contact_info

            # 解析求职意向（如果个人信息中包含）
            if "求职意向" in full_text:
                match = re.search(r"求职意向[:：](.*?)(?:\n|$)", full_text)
                if match:
                    data_dict["expectation"] = match.group(1).strip()

            # 解析教育经历
            if sections["education"]:
                # 尝试分割多条教育经历
                edu_items = re.split(
                    r"(?<=\d{4}[./年])\s*(?:[-~至]\s*)?(?=\d{4})", sections["education"]
                )
                for item in edu_items:
                    if item.strip():
                        # 尝试提取学校名称和时间
                        school_match = re.search(r"(.+?大学|.+?学院|.+?学校)", item)
                        time_match = re.search(
                            r"(\d{4}[./年]\s*[-\~至]?\s*\d{4}[./年]?)", item
                        )

                        edu_entry = {
                            "school": school_match.group(0) if school_match else "",
                            "time": time_match.group(0) if time_match else "",
                            "details": item.strip(),
                        }
                        data_dict["education"].append(edu_entry)

            # 解析工作经历
            if sections["work_experience"]:
                # 尝试分割多条工作经历
                work_items = re.split(
                    r"(?<=\d{4}[./年])\s*(?:[-~至]\s*)?(?=\d{4})|(?<=至今)\s",
                    sections["work_experience"],
                )
                for item in work_items:
                    if item.strip():
                        # 尝试提取公司名称和时间
                        company_match = re.search(r"(.+?公司|.+?科技|.+?集团)", item)
                        time_match = re.search(
                            r"(\d{4}[./年]\s*[-\~至]?\s*\d{4}[./年]?|至今)", item
                        )

                        work_entry = {
                            "company": company_match.group(0) if company_match else "",
                            "employment_period": (
                                time_match.group(0) if time_match else ""
                            ),
                            "details": item.strip(),
                        }
                        data_dict["work_experience"].append(work_entry)

            # 解析项目经历
            if sections["project_experience"]:
                # 分割多个项目
                project_items = re.split(
                    r"\n(?=\d{4}|项目名称|项目\d+[.:：])",
                    sections["project_experience"],
                )
                for item in project_items:
                    if item.strip():
                        # 尝试提取项目名称和时间
                        name_match = re.search(r"(项目名称|项目)[:：]?\s*(.+)", item)
                        time_match = re.search(
                            r"(\d{4}[./年]\s*[-\~至]?\s*\d{4}[./年]?)", item
                        )

                        project_entry = {
                            "project_name": (
                                name_match.group(2).strip() if name_match else ""
                            ),
                            "time": time_match.group(0) if time_match else "",
                            "details": item.strip(),
                        }
                        data_dict["project_experience"].append(project_entry)

            # 解析专业技能
            if sections["skills"]:
                # 分割技能列表
                skills = re.split(r"[,;、，；]\s*", sections["skills"])
                data_dict["skills"] = [
                    skill.strip() for skill in skills if skill.strip()
                ]

            # 解析证书
            if sections["certificates"]:
                # 分割证书列表
                certs = re.split(r"[,;、，；]\s*", sections["certificates"])
                data_dict["certificates"] = [
                    cert.strip() for cert in certs if cert.strip()
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
                        data_dict["languages"].append(
                            {"type": lang.strip(), "level": level.strip()}
                        )

            # 解析自我评价
            if sections["self_assessment"]:
                data_dict["self_assessment"] = sections["self_assessment"]

            logging.info(f"成功解析PDF文件: {pdf_path}")
            return data_dict

        except Exception as e:
            logging.error(f"解析PDF文件失败: {pdf_path}, 错误: {str(e)}")
            return {}
        finally:
            # 确保关闭文档
            if "doc" in locals():
                doc.close()

    def extract_sections(self, pdf_text: str) -> Dict[str, str]:
        """识别简历中的各个部分并提取内容"""
        sections = {
            "personal_info": r"(?i)(个人信息|基本资料|个人资料)",
            "name": r"(?i)(姓名|名字)",
            "education": r"(?i)(教育经历|教育背景)",
            "work_experience": r"(?i)(工作经历|工作经验)",
            "project_experience": r"(?i)(项目经历|项目经验)",
            "skills": r"(?i)(专业技能|技术能力|技能专长)",
            "certificates": r"(?i)(证书|资格证书|认证)",
            "languages": r"(?i)(语言能力|语言)",
            "self_assessment": r"(?i)(自我评价|关于我)",
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
            title_pattern = sections[section] + r".*?\n"
            section_contents[section] = re.sub(
                title_pattern, "", section_contents[section], flags=re.IGNORECASE
            )

        # 提取个人信息块（通常是第一部分）
        if section_starts["personal_info"] > 0:
            section_contents["personal_info"] = pdf_text[
                : section_starts["personal_info"]
            ]

        return section_contents

    def _clean_dict(self, data: Dict) -> Dict:
        model_fields = set(f.name for f in Resume._meta.get_fields())
        clean_dict = {k: v for k, v in data.items() if k in model_fields}
        return clean_dict
