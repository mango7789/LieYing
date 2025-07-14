import requests
import time
from tqdm import tqdm
from configapi import (
    BATCH_SIZE,
    MAX_SEQ_LENGTH,
    DEEPSEEK_API_URL,
    DEEPSEEK_API_KEY,
    API_TIMEOUT,
)
from prompt_builder import create_prompt
from result_parser import parse_assessment
from openai import OpenAI
from typing import Dict, Any, List


def deepseek_api_call(prompt: str) -> str:
    try:
        client = OpenAI(
            api_key=DEEPSEEK_API_KEY,
            base_url="https://dashscope.aliyuncs.com/compatible-mode/v1",
        )

        response = client.chat.completions.create(
            model="deepseek-r1-distill-llama-70b",
            messages=[{"role": "user", "content": prompt}],
            max_tokens=3000,
            temperature=0.1,
            top_p=0.8,
            frequency_penalty=0.2,
            presence_penalty=0.1,
        )

        return response.choices[0].message.content.strip()

    except Exception as e:
        print(f"API调用失败: {str(e)}")
        return f"ERROR: {str(e)}"


def process_single_match(resume: Dict[str, Any], job: Dict[str, Any]) -> Dict[str, Any]:
    prompt = create_prompt(resume, job)
    time.sleep(0.5)
    output = deepseek_api_call(prompt)
    result = parse_assessment(
        output=output, resume=resume, job_id=job.get("id"), job_config=job
    )
    return result


def process_all_matches(
    resume_data: List[Dict[str, Any]], job_data: List[Dict[str, Any]]
) -> List[Dict[str, Any]]:
    all_matches = []
    total_tasks = len(resume_data) * len(job_data)
    print(f"总任务数: {total_tasks}")
    progress_bar = tqdm(total=total_tasks, desc="匹配进度")

    for resume in resume_data:
        if not isinstance(resume, dict):
            print(f"⚠️ 跳过无效简历（非字典类型）：{resume}")
            continue

        for job in job_data:
            if not isinstance(job, dict):
                print(f"⚠️ 跳过无效岗位（非字典类型）：{job}")
                progress_bar.update(1)
                continue

            result = process_single_match(resume, job)
            all_matches.append(result)
            progress_bar.update(1)

    progress_bar.close()
    return all_matches
