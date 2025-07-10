// 监听筛选表单提交（AJAX或无刷新）
document.getElementById("filter-form").addEventListener("submit", function(e) {
    e.preventDefault();
    const formData = new FormData(this);
    const params = new URLSearchParams(formData);
    window.location.search = params.toString();  // 刷新页面带参数
});

// 动态筛选（如果需实时响应）
document.querySelectorAll("#filter-form select").forEach(select => {
    select.addEventListener("change", function() {
        document.getElementById("filter-form").submit();
    });
});