document.addEventListener("DOMContentLoaded", function () {
  const container = document.getElementById("resume-list-container"); // 容器包裹表格和按钮

  container.addEventListener("click", function (event) {
    const btn = event.target.closest(".delete-resume-btn");
    if (!btn) return;

    if (!confirm("确定要删除该简历吗？")) return;

    const resumeId = btn.dataset.resumeId;
    console.log(resumeId);

    fetch(`/resume/delete/${resumeId}/`, {
      method: "POST",
      headers: {
        "X-CSRFToken": getCookie("csrftoken"),
        "X-Requested-With": "XMLHttpRequest"
      }
    })
    .then(res => res.json())
    .then(data => {
      if (data.success) {
        // 删除成功，重新请求简历表格HTML并替换
        fetch(window.location.href, {
          headers: { "X-Requested-With": "XMLHttpRequest" }
        })
        .then(res => res.json())
        .then(data => {
          container.innerHTML = data.html;
        });
      } else {
        alert("删除失败");
      }
    })
    .catch(err => {
      console.error('请求出错:', err);
    });
  });

  function getCookie(name) {
    let cookieValue = null;
    if (document.cookie && document.cookie !== "") {
      const cookies = document.cookie.split(";");
      for (let cookie of cookies) {
        cookie = cookie.trim();
        if (cookie.startsWith(name + "=")) {
          cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
          break;
        }
      }
    }
    return cookieValue;
  }
});
