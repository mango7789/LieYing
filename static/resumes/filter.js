console.log("Filter JS For Resume Loaded");

document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("filter-form");
  const tableSection = document.querySelector("section.stats");

    // 重置按钮逻辑
  const resetBtn = document.getElementById("reset-btn");
  if (resetBtn) {
    resetBtn.addEventListener("click", () => {
      // // 清空关键词
      // form.querySelector("input[name='keyword']").value = "";

      document.getElementById("city-input").value = "";
      document.querySelectorAll(".city-btn").forEach((btn, idx) => {
        btn.classList.replace("btn-primary", "btn-outline-primary");
        if (idx === 0) {
          btn.classList.replace("btn-outline-primary", "btn-primary");
          document.getElementById("city-input").value = btn.dataset.value;
        }
      });

      document.getElementById("education-input").value = "";
      document.querySelectorAll(".edu-btn").forEach((btn, idx) => {
        btn.classList.replace("btn-primary", "btn-outline-primary");
        if (idx === 0) {
          btn.classList.replace("btn-outline-primary", "btn-primary");
          document.getElementById("education-input").value = btn.dataset.value;
        }
      });

      document.getElementById("workyears-input").value = "";
      document.querySelectorAll(".workyears-btn").forEach((btn, idx) => {
        btn.classList.replace("btn-primary", "btn-outline-primary");
        if (idx === 0) {
          btn.classList.replace("btn-outline-primary", "btn-primary");
          document.getElementById("workyears-input").value = btn.dataset.value;
        }
      });

      fetchFilteredResumes();
    });
  }


  // 统一发加密请求
  async function fetchFilteredResumes(page = 1) {
    const data = {
      keyword: form.querySelector("input[name='keyword']").value.trim(),
      city: document.getElementById("city-input").value.trim(),
      education: document.getElementById("education-input").value.trim(),
      work_years: document.getElementById("workyears-input").value.trim(),
    };
    // console.log(data);
    try {
      const res = await fetch("/core/encrypt/", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRFToken": getCookie("csrftoken"),
        },
        body: JSON.stringify(data),
      });

      const json = await res.json();
      if (!json.q) throw new Error("加密失败");

      const url = `${window.location.pathname}?q=${encodeURIComponent(json.q)}&page=${page}`;
      window.history.pushState({}, '', url);

      const htmlRes = await fetch(url, {
        headers: {
          "X-Requested-With": "XMLHttpRequest"
        }
      });
      const htmlJson = await htmlRes.json();
      tableSection.innerHTML = htmlJson.html;
      bindPagination();

    } catch (err) {
      console.error("加载失败", err);
      tableSection.innerHTML = "<p>加载失败，请重试。</p>";
    }
  }

  function bindPagination() {
    document.querySelectorAll(".ajax-page").forEach((link) => {
      link.addEventListener("click", (e) => {
        e.preventDefault();
        const url = new URL(link.href);
        const page = url.searchParams.get("page") || 1;
        fetchFilteredResumes(page);
      });
    });
  }

  // 城市筛选按钮绑定
  document.querySelectorAll(".city-btn").forEach((btn) => {
    btn.addEventListener("click", () => {
      document.getElementById("city-input").value = btn.dataset.value;
      document.querySelectorAll(".city-btn").forEach((b) => b.classList.replace("btn-primary", "btn-outline-primary"));
      btn.classList.replace("btn-outline-primary", "btn-primary");
      fetchFilteredResumes();
    });
  });

  // 教育筛选
  document.querySelectorAll(".edu-btn").forEach((btn) => {
    btn.addEventListener("click", () => {
      document.getElementById("education-input").value = btn.dataset.value;
      document.querySelectorAll(".edu-btn").forEach((b) => b.classList.replace("btn-primary", "btn-outline-primary"));
      btn.classList.replace("btn-outline-primary", "btn-primary");
      fetchFilteredResumes();
    });
  });

  // 年限筛选
  document.querySelectorAll(".workyears-btn").forEach((btn) => {
    btn.addEventListener("click", () => {
      document.getElementById("workyears-input").value = btn.dataset.value;
      document.querySelectorAll(".workyears-btn").forEach((b) => b.classList.replace("btn-primary", "btn-outline-primary"));
      btn.classList.replace("btn-outline-primary", "btn-primary");
      fetchFilteredResumes();
    });
  });

  // 关键词搜索
  form.querySelector("input[name='keyword']").addEventListener("keydown", (e) => {
    if (e.key === "Enter") {
      e.preventDefault();
      fetchFilteredResumes();
    }
  });

  bindPagination();
});

// 获取 CSRF Token
function getCookie(name) {
  const cookieValue = document.cookie
    .split("; ")
    .find((row) => row.startsWith(name + "="));
  return cookieValue ? decodeURIComponent(cookieValue.split("=")[1]) : "";
}
