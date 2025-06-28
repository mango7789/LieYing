console.log("Upload JS For Resume Loaded");

document.addEventListener("DOMContentLoaded", function () {
  const uploadArea = document.getElementById("upload-area");
  const fileInput = document.getElementById("file-input");
  const uploadForm = document.getElementById("upload-form");
  const fileListEl = document.getElementById("file-list");
  const confirmUploadBtn = document.getElementById("confirm-upload");

  const toastEl = document.getElementById("message-toast");
  const toastBody = toastEl?.querySelector(".toast-body");
  const toast = toastEl ? new bootstrap.Toast(toastEl) : null;

  let selectedFiles = [];

  function showToast(message) {
    if (!toast || !toastBody) {
      alert(message);
    } else {
      toastBody.textContent = message;
      toast.show();
    }
  }

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

  // 点击上传区域触发文件选择
  uploadArea.addEventListener("click", () => fileInput.click());

  // 文件选择后加入列表（同名文件确认替换）
  fileInput.addEventListener("change", () => {
    for (const file of fileInput.files) {
      const existIndex = selectedFiles.findIndex(f => f.name === file.name);
      if (existIndex === -1) {
        // 不存在，直接添加
        selectedFiles.push(file);
      } else {
        // 存在，弹窗确认是否替换（同步确认框只能用window.confirm）
        const confirmReplace = window.confirm(`文件 "${file.name}" 已存在，是否替换？`);
        if (confirmReplace) {
          selectedFiles.splice(existIndex, 1, file);
          showToast(`文件 "${file.name}" 已被替换`);
        }
      }
    }
    renderFileList();
    fileInput.value = ""; // 允许重新选择同名文件
  });

  // 渲染待上传文件列表
  function renderFileList() {
    fileListEl.innerHTML = "";

    selectedFiles.forEach((file, index) => {
      // 判断文件类型，决定class和icon
      let fileClass = "default";
      let iconClass = "bi-file-earmark";

      if (file.type.includes("pdf") || file.name.endsWith(".pdf")) {
        fileClass = "pdf";
        iconClass = "bi-file-earmark-pdf";
      } else if (
        file.type.includes("excel") ||
        file.name.endsWith(".xls") ||
        file.name.endsWith(".xlsx") ||
        file.name.endsWith(".csv")
      ) {
        fileClass = "excel";
        iconClass = "bi-file-earmark-spreadsheet";
      } else if (
        file.type.includes("html") ||
        file.name.endsWith(".html") ||
        file.name.endsWith(".htm")
      ) {
        fileClass = "html";
        iconClass = "bi-file-earmark-code";
      }

      const li = document.createElement("li");
      li.className = `list-group-item ${fileClass}`;
      li.style.display = "flex";
      li.style.alignItems = "center";
      li.style.justifyContent = "space-between";

      li.innerHTML = `
        <span style="display:flex; align-items:center; gap:8px; flex-grow:1;">
          <i class="bi ${iconClass} file-icon"></i>
          <span class="file-name">${file.name}</span>
        </span>
        <button type="button" class="remove-btn btn btn-sm btn-danger" data-index="${index}" title="删除文件">×</button>
      `;

      fileListEl.appendChild(li);
    });

    confirmUploadBtn.disabled = selectedFiles.length === 0;
  }

  // 删除文件，弹窗确认
  fileListEl.addEventListener("click", (e) => {
    if (e.target.classList.contains("remove-btn")) {
      const index = Number(e.target.dataset.index);
      if (Number.isNaN(index)) return;

      const fileName = selectedFiles[index]?.name;
      if (!fileName) return;

      if (window.confirm(`确定要删除文件 "${fileName}" 吗？`)) {
        selectedFiles.splice(index, 1);
        renderFileList();
        showToast(`文件 "${fileName}" 已删除`);
      }
    }
  });


  // 确认上传
  confirmUploadBtn.addEventListener("click", async () => {
    const resultBody = document.getElementById("upload-result-body");
    const resultSection = document.getElementById("upload-result");
    resultBody.innerHTML = "";

    const selectedJobIds = $('#job-select').val();

    for (const file of selectedFiles) {
      const formData = new FormData();
      formData.append("file", file);

      // 岗位 ID
      // const jobSelect = document.getElementById("job-select");
      // const selectedJobs = Array.from(jobSelect.selectedOptions).map(opt => opt.value);
      // selectedJobs.forEach(jobId => {
      //   formData.append("job_ids", jobId);
      // });
      console.log(selectedJobIds.length);
      if (selectedJobIds && selectedJobIds.length > 0) {
        for (const jobId of selectedJobIds) {
          console.log(jobId);
          formData.append("job_ids", jobId);
        }
      }

      let status = "失败";
      let message = "未知错误";

      try {
        const response = await fetch(uploadForm.action, {
          method: "POST",
          headers: {
            "X-CSRFToken": getCookie("csrftoken"),
          },
          body: formData,
        });

        const data = await response.json();
        status = data.success ? "成功" : "失败";
        message = data.message || "";

        // showToast(`${file.name}: ${message}`);
      } catch (err) {
        message = "上传失败，请检查网络";
        // showToast(`${file.name}: ${message}`);
      }

      const row = document.createElement("tr");
      row.innerHTML = `
        <td>${file.name}</td>
        <td class="${status === "成功" ? "text-success" : "text-danger"}">${status}</td>
        <td>${message}</td>
      `;
      resultBody.appendChild(row);
    }

    resultSection.classList.remove("d-none");
    selectedFiles = [];
    renderFileList();
  });
});

