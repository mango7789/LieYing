console.log("Upload JS For Jobs Loaded");

document.addEventListener("DOMContentLoaded", function () {
  const uploadArea = document.getElementById("job-upload-area");
  const fileInput = document.getElementById("job-file-input");
  const uploadForm = document.getElementById("job-upload-form");
  const fileListEl = document.getElementById("job-file-list");
  const confirmUploadBtn = document.getElementById("job-confirm-upload");
  const resultSection = document.getElementById("job-upload-result");
  const resultBody = document.getElementById("job-upload-result-body");

  let selectedFiles = [];

  // 点击上传区域触发文件选择
  uploadArea.addEventListener("click", () => fileInput.click());

  // 文件选择后加入列表（同名文件确认替换）
  fileInput.addEventListener("change", () => {
    for (const file of fileInput.files) {
      const existIndex = selectedFiles.findIndex(f => f.name === file.name);
      if (existIndex === -1) {
        selectedFiles.push(file);
      } else {
        const confirmReplace = window.confirm(`文件 "${file.name}" 已存在，是否替换？`);
        if (confirmReplace) {
          selectedFiles.splice(existIndex, 1, file);
        }
      }
    }
    renderFileList();
    fileInput.value = "";
  });

  // 渲染待上传文件列表
  function renderFileList() {
    fileListEl.innerHTML = "";
    selectedFiles.forEach((file, index) => {
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

  // 删除文件
  fileListEl.addEventListener("click", (e) => {
    if (e.target.classList.contains("remove-btn")) {
      const index = Number(e.target.dataset.index);
      if (Number.isNaN(index)) return;
      const fileName = selectedFiles[index]?.name;
      if (!fileName) return;
      if (window.confirm(`确定要删除文件 "${fileName}" 吗？`)) {
        selectedFiles.splice(index, 1);
        renderFileList();
      }
    }
  });

  // 确认上传
  confirmUploadBtn.addEventListener("click", async (e) => {
    e.preventDefault();
    resultBody.innerHTML = "";
    for (const file of selectedFiles) {
      const formData = new FormData();
      formData.append("files", file);
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
        if (data.result && data.result.length > 0) {
          status = data.result[0].status;
          message = data.result[0].msg;
        }
      } catch (err) {
        message = "上传失败，请检查网络";
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

  // 获取 CSRF Token
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