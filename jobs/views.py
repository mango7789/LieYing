from django.shortcuts import render, redirect, get_object_or_404
from django.db.models import Count, Max
from django.contrib import messages
from django.http import JsonResponse
from .models import JobPosition
from .forms import JobForm
from .constants import CITY_CHOICES, EDUCATION_CHOICES, WORK_EXPERIENCE_CHOICES

def company_list(request):
    # 按公司分组，统计职位数量和最新创建时间
    companies = JobPosition.objects.values('company').annotate(
        job_count=Count('id'),
        latest_created=Max('created_at')
    ).order_by('-latest_created')
    
    return render(request, 'jobs/company_list.html', {
        'companies': companies
    })

def job_list(request, company):
    # 获取指定公司的所有职位
    jobs = JobPosition.objects.filter(company=company).order_by('-created_at')
    
    # 添加匹配状态逻辑
    for job in jobs:
        # TODO: 从match模块获取实际的匹配状态
        # 这里应该查询match模块的匹配记录
        # 暂时使用模拟状态，实际项目中需要与match模块集成
        job.match_status = get_job_match_status(job.id)
    
    return render(request, 'jobs/job_list.html', {
        'jobs': jobs,
        'company': company
    })

def get_job_match_status(job_id):
    """
    获取职位的匹配状态
    TODO: 需要与match模块集成，查询实际的匹配状态
    """
    # 这里应该查询match模块的数据库表
    # 暂时返回模拟状态
    import random
    statuses = ['not_started', 'matching', 'matched']
    return random.choice(statuses)

def job_create_general(request):
    """Floor1的通用新增岗位视图"""
    if request.method == 'POST':
        print("POST数据:", request.POST)  # 调试信息
        form = JobForm(request.POST)
        print("表单是否有效:", form.is_valid())  # 调试信息
        if form.is_valid():
            try:
                job = form.save()
                print("保存成功，职位ID:", job.id)  # 调试信息
                messages.success(request, '职位添加成功！')
                return redirect('jobs:company_list')
            except Exception as e:
                print("保存失败:", str(e))  # 调试信息
                messages.error(request, f'保存失败：{str(e)}')
        else:
            print("表单错误:", form.errors)  # 调试信息
            # 显示表单错误
            for field, errors in form.errors.items():
                for error in errors:
                    messages.error(request, f'{field}: {error}')
    else:
        form = JobForm()
    
    return render(request, 'jobs/job_form_general.html', {
        'form': form,
        'company': None,
        'city_choices': CITY_CHOICES,
        'education_choices': EDUCATION_CHOICES,
        'work_experience_choices': WORK_EXPERIENCE_CHOICES
    })

def job_create(request, company):
    """Floor2的指定公司新增岗位视图"""
    if request.method == 'POST':
        form = JobForm(request.POST)
        if form.is_valid():
            try:
                job = form.save(commit=False)
                job.company = company  # 强制使用URL中的公司名
                job.save()
                messages.success(request, '职位添加成功！')
                return redirect('jobs:job_list', company=company)
            except Exception as e:
                messages.error(request, f'保存失败：{str(e)}')
        else:
            # 显示表单错误
            for field, errors in form.errors.items():
                for error in errors:
                    messages.error(request, f'{field}: {error}')
    else:
        form = JobForm(initial={'company': company})
    
    return render(request, 'jobs/job_form.html', {
        'form': form,
        'company': company,
        'city_choices': CITY_CHOICES,
        'education_choices': EDUCATION_CHOICES,
        'work_experience_choices': WORK_EXPERIENCE_CHOICES
    })

def job_update(request, pk):
    job = get_object_or_404(JobPosition, pk=pk)
    
    if request.method == 'POST':
        form = JobForm(request.POST, instance=job)
        if form.is_valid():
            try:
                form.save()
                messages.success(request, '职位信息更新成功！')
                return redirect('jobs:job_list', company=job.company)
            except Exception as e:
                messages.error(request, f'更新失败：{str(e)}')
        else:
            # 显示表单错误
            for field, errors in form.errors.items():
                for error in errors:
                    messages.error(request, f'{field}: {error}')
    else:
        form = JobForm(instance=job)
    
    return render(request, 'jobs/job_form.html', {
        'form': form,
        'company': job.company,
        'city_choices': CITY_CHOICES,
        'education_choices': EDUCATION_CHOICES,
        'work_experience_choices': WORK_EXPERIENCE_CHOICES
    })

def job_delete(request, pk):
    job = get_object_or_404(JobPosition, pk=pk)
    
    if request.method == 'POST':
        company = job.company
        job_name = job.name
        job.delete()
        messages.success(request, f'职位"{job_name}"已成功删除！')
        return redirect('jobs:job_list', company=company)
    
    return render(request, 'jobs/job_confirm_delete.html', {'job': job})

def start_matching(request, job_id):
    """开始匹配功能"""
    job = get_object_or_404(JobPosition, pk=job_id)
    
    if request.method == 'POST':
        # TODO: 调用match模块的匹配算法
        # 这里应该触发后台匹配任务，调用match模块的API
        try:
            # 示例：调用match模块的匹配服务
            # from match.services import start_job_matching
            # start_job_matching(job_id)
            
            # 暂时模拟匹配开始
            print(f"Starting matching for job: {job.name} (ID: {job_id})")
            
            messages.success(request, f'已开始为职位"{job.name}"进行匹配，请稍后查看结果。')
        except Exception as e:
            messages.error(request, f'启动匹配失败：{str(e)}')
        
        return redirect('jobs:job_list', company=job.company)
    
    # GET请求显示确认页面
    return render(request, 'jobs/start_matching_confirm.html', {'job': job})

def match_result(request, job_id):
    """查看匹配结果"""
    job = get_object_or_404(JobPosition, pk=job_id)
    
    # TODO: 从match模块获取实际的匹配结果数据
    # 这里应该查询match模块的匹配结果
    try:
        # 示例：调用match模块的结果查询服务
        # from match.services import get_job_match_results
        # resumes = get_job_match_results(job_id)
        
        # 暂时使用模拟数据
        resumes = [
            {'id': 1, 'name': '张三', 'match_score': 92, 'status': '在职，看看新机会'},
            {'id': 2, 'name': '李四', 'match_score': 87, 'status': '离职，正在找工作'},
            {'id': 3, 'name': '王五', 'match_score': 78, 'status': '在职，急寻新工作'},
        ]
    except Exception as e:
        messages.error(request, f'获取匹配结果失败：{str(e)}')
        resumes = []
    
    return render(request, 'jobs/match_result.html', {
        'job': job,
        'resumes': resumes
    })

# API接口，供match模块调用
def api_job_detail(request, job_id):
    """API接口：获取职位详情，供match模块调用"""
    try:
        job = get_object_or_404(JobPosition, pk=job_id)
        return JsonResponse({
            'success': True,
            'data': job.to_json()
        })
    except Exception as e:
        return JsonResponse({
            'success': False,
            'error': str(e)
        }, status=400)
