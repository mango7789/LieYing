// delete.js - 岗位删除确认与AJAX处理

// 删除职位确认功能
document.addEventListener('DOMContentLoaded', function() {
    // 删除按钮点击事件
    document.querySelectorAll('.delete-job-btn').forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            
            const jobId = this.dataset.jobId;
            const jobName = this.closest('tr').querySelector('td:first-child').textContent.trim();
            
            // 显示确认对话框
            showDeleteConfirmModal(jobId, jobName);
        });
    });
});

// 显示删除确认模态框
function showDeleteConfirmModal(jobId, jobName) {
    // 更新模态框内容
    document.getElementById('jobNamePreview').textContent = `职位名称: ${jobName}`;
    
    // 设置表单action
    const form = document.getElementById('deleteJobForm');
    form.action = `/jobs/delete/${jobId}/`;
    
    // 显示模态框
    const modal = new bootstrap.Modal(document.getElementById('deleteJobModal'));
    modal.show();
}

// 删除成功后的回调
function onDeleteSuccess() {
    // 隐藏模态框
    const modal = bootstrap.Modal.getInstance(document.getElementById('deleteJobModal'));
    modal.hide();
    
    // 显示成功消息
    showToast('职位删除成功！', 'success');
    
    // 刷新页面或移除对应的行
    setTimeout(() => {
        window.location.reload();
    }, 1000);
}

// 显示Toast消息
function showToast(message, type = 'info') {
    const toastContainer = document.getElementById('toast-container') || createToastContainer();
    
    const toast = document.createElement('div');
    toast.className = `toast align-items-center text-white bg-${type} border-0`;
    toast.setAttribute('role', 'alert');
    toast.setAttribute('aria-live', 'assertive');
    toast.setAttribute('aria-atomic', 'true');
    
    toast.innerHTML = `
        <div class="d-flex">
            <div class="toast-body">
                ${message}
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    `;
    
    toastContainer.appendChild(toast);
    
    const bsToast = new bootstrap.Toast(toast);
    bsToast.show();
    
    // 自动移除
    toast.addEventListener('hidden.bs.toast', () => {
        toast.remove();
    });
}

// 创建Toast容器
function createToastContainer() {
    const container = document.createElement('div');
    container.id = 'toast-container';
    container.className = 'toast-container position-fixed top-0 end-0 p-3';
    container.style.zIndex = '1055';
    document.body.appendChild(container);
    return container;
}
