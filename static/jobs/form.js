// 职位表单验证和交互功能
document.addEventListener('DOMContentLoaded', function() {
    // 初始化城市选择功能
    initCitySelection();
    
    // 初始化表单验证
    initFormValidation();
    
    // 初始化字数统计
    initCharacterCount();
});

// 城市选择功能
function initCitySelection() {
    const citySelect = document.querySelector('select[name="city"]');
    const customCityInput = document.getElementById('custom-city-input');
    
    if (citySelect) {
        // 监听城市选择变化
        citySelect.addEventListener('change', function() {
            checkCityCustom(this);
        });
        
        // 页面加载时初始化
        checkCityCustom(citySelect);
    }
}

// 检查城市选择并显示/隐藏自定义输入框
function checkCityCustom(select) {
    const customInput = document.getElementById('custom-city-input');
    if (!customInput) return;
    
    const parentDiv = customInput.parentElement;
    
    if (select.value === '其他') {
        parentDiv.classList.remove('d-none');
        customInput.classList.add('show');
        customInput.required = true;
        customInput.focus();
    } else {
        parentDiv.classList.add('d-none');
        customInput.classList.remove('show');
        customInput.required = false;
        customInput.value = '';
    }
}

// 表单验证
function initFormValidation() {
    const form = document.querySelector('form');
    if (!form) return;
    
    // 实时验证
    form.addEventListener('input', function(e) {
        validateField(e.target);
    });
    
    // 提交验证
    form.addEventListener('submit', function(e) {
        if (!validateForm()) {
            e.preventDefault();
            showFormErrors();
        }
    });
}

// 验证单个字段
function validateField(field) {
    const fieldName = field.name;
    const value = field.value.trim();
    let isValid = true;
    let errorMessage = '';
    
    // 清除之前的错误
    clearFieldError(field);
    
    // 必填字段验证
    if (field.hasAttribute('required') && !value) {
        isValid = false;
        errorMessage = '此字段为必填项';
    }
    
    // 特定字段验证
    switch (fieldName) {
        case 'name':
            if (value && value.length < 2) {
                isValid = false;
                errorMessage = '职位名称至少需要2个字符';
            }
            break;
            
        case 'company':
            if (value && value.length < 2) {
                isValid = false;
                errorMessage = '公司名称至少需要2个字符';
            }
            break;
            
        case 'salary':
            if (value && !/^[\d\-kK万]+$/.test(value)) {
                isValid = false;
                errorMessage = '请输入有效的薪资格式，如：15k-25k 或 15万-25万';
            }
            break;
            
        case 'custom_city':
            if (value && value.length < 2) {
                isValid = false;
                errorMessage = '城市名称至少需要2个字符';
            }
            break;
    }
    
    // 显示错误信息
    if (!isValid) {
        showFieldError(field, errorMessage);
    }
    
    return isValid;
}

// 验证整个表单
function validateForm() {
    const form = document.querySelector('form');
    const fields = form.querySelectorAll('input, select, textarea');
    let isValid = true;
    
    fields.forEach(field => {
        if (!validateField(field)) {
            isValid = false;
        }
    });
    
    return isValid;
}

// 显示字段错误
function showFieldError(field, message) {
    // 创建错误元素
    const errorDiv = document.createElement('div');
    errorDiv.className = 'text-danger small mt-1';
    errorDiv.textContent = message;
    
    // 添加错误样式
    field.classList.add('is-invalid');
    
    // 插入错误信息
    field.parentNode.appendChild(errorDiv);
    
    // 存储错误元素引用
    field.errorElement = errorDiv;
}

// 清除字段错误
function clearFieldError(field) {
    field.classList.remove('is-invalid');
    
    if (field.errorElement) {
        field.errorElement.remove();
        field.errorElement = null;
    }
}

// 显示表单错误
function showFormErrors() {
    showToast('请检查表单中的错误信息', 'warning');
    
    // 滚动到第一个错误字段
    const firstError = document.querySelector('.is-invalid');
    if (firstError) {
        firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
        firstError.focus();
    }
}

// 字数统计功能
function initCharacterCount() {
    const textareas = document.querySelectorAll('textarea');
    
    textareas.forEach(textarea => {
        const maxLength = textarea.getAttribute('maxlength');
        if (maxLength) {
            // 创建字数统计显示
            const counter = document.createElement('div');
            counter.className = 'form-text text-muted text-end';
            counter.id = `counter-${textarea.name}`;
            textarea.parentNode.appendChild(counter);
            
            // 更新字数统计
            function updateCount() {
                const currentLength = textarea.value.length;
                counter.textContent = `${currentLength}/${maxLength}`;
                
                if (currentLength > maxLength * 0.9) {
                    counter.classList.add('text-warning');
                } else {
                    counter.classList.remove('text-warning');
                }
            }
            
            // 监听输入事件
            textarea.addEventListener('input', updateCount);
            textarea.addEventListener('keyup', updateCount);
            
            // 初始化显示
            updateCount();
        }
    });
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

// 表单自动保存功能
function initAutoSave() {
    const form = document.querySelector('form');
    if (!form) return;
    
    const formData = new FormData(form);
    const formKey = `job_form_${Date.now()}`;
    
    // 保存表单数据到localStorage
    function saveFormData() {
        const data = {};
        formData.forEach((value, key) => {
            data[key] = value;
        });
        localStorage.setItem(formKey, JSON.stringify(data));
    }
    
    // 恢复表单数据
    function restoreFormData() {
        const saved = localStorage.getItem(formKey);
        if (saved) {
            const data = JSON.parse(saved);
            Object.keys(data).forEach(key => {
                const field = form.querySelector(`[name="${key}"]`);
                if (field) {
                    field.value = data[key];
                }
            });
        }
    }
    
    // 监听表单变化
    form.addEventListener('input', saveFormData);
    
    // 页面加载时恢复数据
    restoreFormData();
    
    // 表单提交成功后清除保存的数据
    form.addEventListener('submit', function() {
        localStorage.removeItem(formKey);
    });
} 