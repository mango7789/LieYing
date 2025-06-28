# Match模块接口规范

## 概述
Match模块负责处理职位与简历的匹配功能，为jobs模块提供匹配服务。

## 与Jobs模块的集成接口

### 1. 获取职位详情
**接口地址：** `GET /jobs/api/job/{job_id}/`

**返回格式：**
```json
{
    "success": true,
    "data": {
        "job_id": "1",
        "name": "Python开发工程师",
        "company": "腾讯科技",
        "city": "深圳",
        "salary": "15k-25k",
        "education": "本科",
        "years_of_working": "3-5年",
        "language": "英语",
        "responsibilities": ["负责后端开发", "参与系统设计"],
        "requirements": ["熟悉Python", "了解Django框架"]
    }
}
```

### 2. 开始匹配任务
**接口地址：** `POST /match/start/{job_id}/`

**请求参数：**
```json
{
    "job_id": 1,
    "priority": "normal"  // 可选：high, normal, low
}
```

**返回格式：**
```json
{
    "success": true,
    "task_id": "match_task_12345",
    "message": "匹配任务已启动"
}
```

### 3. 获取匹配结果
**接口地址：** `GET /match/result/{job_id}/`

**返回格式：**
```json
{
    "success": true,
    "data": {
        "job_id": 1,
        "status": "completed",  // pending, running, completed, failed
        "total_candidates": 150,
        "matched_count": 12,
        "results": [
            {
                "resume_id": 1,
                "candidate_name": "张三",
                "match_score": 92,
                "status": "在职，看看新机会",
                "key_skills": ["Python", "Django", "MySQL"],
                "experience_years": 4,
                "education": "本科"
            }
        ]
    }
}
```

### 4. 获取匹配状态
**接口地址：** `GET /match/status/{job_id}/`

**返回格式：**
```json
{
    "success": true,
    "data": {
        "job_id": 1,
        "status": "matching",  // not_started, matching, matched, failed
        "progress": 65,  // 0-100
        "estimated_time": "2分钟"
    }
}
```

## 数据库表结构建议

### 匹配任务表 (MatchTask)
```sql
CREATE TABLE match_task (
    id SERIAL PRIMARY KEY,
    job_id INTEGER REFERENCES jobs_jobposition(id),
    status VARCHAR(20) DEFAULT 'pending',
    progress INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    started_at TIMESTAMP NULL,
    completed_at TIMESTAMP NULL,
    error_message TEXT NULL
);
```

### 匹配结果表 (MatchResult)
```sql
CREATE TABLE match_result (
    id SERIAL PRIMARY KEY,
    job_id INTEGER REFERENCES jobs_jobposition(id),
    resume_id INTEGER REFERENCES resumes_resume(id),
    match_score DECIMAL(5,2),
    rank_position INTEGER,
    created_at TIMESTAMP DEFAULT NOW()
);
```

## 实现建议

1. **异步处理：** 使用Celery或Django-Q处理匹配任务
2. **缓存机制：** 对匹配结果进行缓存，提高查询速度
3. **状态管理：** 实时更新匹配状态，支持进度显示
4. **错误处理：** 完善的错误处理和重试机制

## 调用示例

### 在Jobs模块中调用匹配服务
```python
# jobs/views.py
from match.services import start_matching_task, get_matching_status

def start_matching(request, job_id):
    try:
        # 启动匹配任务
        result = start_matching_task(job_id)
        messages.success(request, '匹配任务已启动')
    except Exception as e:
        messages.error(request, f'启动失败：{str(e)}')
    
    return redirect('jobs:job_list', company=job.company)

def get_job_match_status(job_id):
    try:
        status = get_matching_status(job_id)
        return status
    except:
        return 'not_started' 