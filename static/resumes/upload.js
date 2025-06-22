console.log("Upload JS For Resume Loaded");

document.addEventListener('DOMContentLoaded', function() {
  const toastEl = document.getElementById("message-toast");
  if (!toastEl) {
    console.error("Toast element not found!");
    return;
  }
  const toastBody = toastEl.querySelector(".toast-body");
  if (!toastBody) {
    console.error("Toast body element not found!");
    return;
  }
  const toast = new bootstrap.Toast(toastEl);

  function showToast(message) {
    toastBody.textContent = message;
    toast.show();
  }

  document.querySelectorAll('.upload-form').forEach(form => {
    form.addEventListener('submit', function(e) {
      e.preventDefault();
      const fileInput = this.querySelector('input[type="file"]');
      if (!fileInput.files.length) {
        showToast('请选择文件！');
        return;
      }

      const formData = new FormData(this);
      fetch(this.action, {
        method: 'POST',
        headers: {
          'X-CSRFToken': getCookie('csrftoken'),
        },
        body: formData
      })
      .then(resp => resp.json())
      .then(data => {
        console.log(data)
        showToast(data.message);
        if (data.success) {
          fileInput.value = '';
          // location.reload();
        }
      })
      .catch(() => showToast('上传失败，请稍后重试'));
    });
  });

  function getCookie(name) {
    let cookieValue = null;
    if (document.cookie && document.cookie !== '') {
      const cookies = document.cookie.split(';');
      for (const c of cookies) {
        const cookie = c.trim();
        if (cookie.startsWith(name + '=')) {
          cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
          break;
        }
      }
    }
    return cookieValue;
  }
});


function showToast(message) {
  toastBody.textContent = message;
  toast.show();
}

function getCookie(name) {
  let cookieValue = null;
  if (document.cookie && document.cookie !== '') {
    const cookies = document.cookie.split(';');
    for (const c of cookies) {
      const cookie = c.trim();
      if (cookie.startsWith(name + '=')) {
        cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
        break;
      }
    }
  }
  return cookieValue;
}
