console.log("Upload JS For Resume Loaded");

document.addEventListener("DOMContentLoaded", function () {
  const uploadArea = document.getElementById("upload-area");
  const fileInput = document.getElementById("file-input");
  const uploadForm = document.getElementById("upload-form");
  const confirmForm = document.getElementById("resume-confirm-form");
  const toastEl = document.getElementById("message-toast");
  const toastBody = toastEl?.querySelector(".toast-body");
  const toast = toastEl ? new bootstrap.Toast(toastEl) : null;

  function showToast(message) {
    if (!toast || !toastBody) {
      alert(message);
    } else {
      toastBody.textContent = message;
      toast.show();
    }
  }

  // 点击上传区域，触发选择文件
  uploadArea.addEventListener("click", () => fileInput.click());

  // 文件选中后自动上传
  fileInput.addEventListener("change", () => {
    if (fileInput.files.length > 0) {
      uploadForm.dispatchEvent(new Event("submit"));
    }
  });

  // 上传简历表单提交
  uploadForm.addEventListener("submit", function (e) {
    e.preventDefault();
    const file = fileInput.files[0];
    if (!file) {
      showToast("请选择文件！");
      return;
    }

    const formData = new FormData(uploadForm);

    fetch(uploadForm.action, {
      method: "POST",
      headers: {
        "X-CSRFToken": getCookie("csrftoken"),
      },
      body: formData,
    })
      .then((resp) => resp.json())
      .then((data) => {
        console.log("解析结果：", data);
        showToast(data.message);

        if (data.success && data.resume_data) {
          populateForm(data.resume_data, data.resume_id);
        }
      })
      .catch(() => showToast("上传失败，请稍后重试"));
  });

  // 填充右侧确认表单
  function populateForm(data, resumeId) {
    confirmForm.classList.remove("d-none");
    document.getElementById("resume-id").value = resumeId;

    for (const [key, value] of Object.entries(data)) {
      const input = confirmForm.querySelector(`[name="${key}"]`);
      if (!input) continue;

      if (input.tagName === "TEXTAREA" || input.tagName === "INPUT") {
        if (Array.isArray(value)) {
          input.value = value.join(", ");
        } else if (typeof value === "object") {
          input.value = JSON.stringify(value, null, 2);
        } else {
          input.value = value;
        }
      } else if (input.tagName === "SELECT") {
        input.value = value;
      }
    }
  }

  // 提交确认简历表单
  confirmForm.addEventListener("submit", function (e) {
    e.preventDefault();
    const formData = new FormData(confirmForm);
    const data = {};

    for (const [key, val] of formData.entries()) {
      if (["expected_positions", "skills", "tags"].includes(key)) {
        data[key] = val.split(",").map(v => v.trim()).filter(v => v);
      } else if (
        ["education", "project_experiences", "working_experiences"].includes(key)
      ) {
        try {
          data[key] = JSON.parse(val);
        } catch {
          showToast(`字段 ${key} 需要合法 JSON`);
          return;
        }
      } else {
        data[key] = val;
      }
    }

    fetch("/resume/confirm/", {
      method: "POST",
      headers: {
        "X-CSRFToken": getCookie("csrftoken"),
        "Content-Type": "application/json",
      },
      body: JSON.stringify(data),
    })
      .then((resp) => resp.json())
      .then((data) => {
        showToast(data.message);
        if (data.success) {
          confirmForm.reset();
          confirmForm.classList.add("d-none");
        }
      })
      .catch(() => showToast("确认保存失败，请稍后重试"));
  });

  function getCookie(name) {
    let cookieValue = null;
    if (document.cookie && document.cookie !== "") {
      const cookies = document.cookie.split(";");
      for (const c of cookies) {
        const cookie = c.trim();
        if (cookie.startsWith(name + "=")) {
          cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
          break;
        }
      }
    }
    return cookieValue;
  }
});
