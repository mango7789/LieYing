from configapi import OUTPUT_FILE, RESUME_PATH, JOB_PATH
from data_loader import load_resume_and_job_data
from inference_engine import process_all_matches
from utils import save_results, print_result_summary, setup_logging


def main():
    try:
        resume_data, job_data = load_resume_and_job_data(RESUME_PATH, JOB_PATH)
        results = process_all_matches(resume_data, job_data)
        for result in results:
            total_score = result.get("total_score")
            max_total = result.get("max_total_score")
            category = "分类未知"
            if total_score is not None and max_total is not None and max_total > 0:
                score_ratio = total_score / max_total
                if score_ratio >= 0.8:
                    category = "A类（80+）：核心岗位优先面试"
                elif 0.6 <= score_ratio < 0.8:
                    category = "B类（60-79）：潜在培养对象"
                else:
                    category = "C类（<60）：简历库储备"

            result["category"] = category
        save_results(results, OUTPUT_FILE)
        print_result_summary(results)
        print("\n🎉 所有任务已完成!")

    except Exception as e:
        print(f"❌ 程序运行出错: {str(e)}")
        raise


if __name__ == "__main__":
    main()
