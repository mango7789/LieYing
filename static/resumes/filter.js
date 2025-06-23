console.log("Filter JS For Resume Loaded");

document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("filter-form");
  const tableSection = document.querySelector("section.stats");

  function fetchFilteredResumes(extraParams = "") {
    // console.log("正在发送 AJAX 请求...");
    const formData = new FormData(form);
    const params = new URLSearchParams(formData).toString();
    const query = params + (extraParams ? "&" + extraParams : "");

    window.history.pushState({}, '', `${window.location.pathname}?${query}`);

    fetch(`${window.location.pathname}?${query}`, {
      headers: {
        "X-Requested-With": "XMLHttpRequest"
      }
    })
      .then((res) => res.json())
      .then((data) => {
        tableSection.innerHTML = data.html;
        bindPagination();
      })
      .catch(() => {
        tableSection.innerHTML = "<p>加载失败，请重试。</p>";
      });
  }

  function bindPagination() {
    document.querySelectorAll(".ajax-page").forEach((link) => {
      link.addEventListener("click", (e) => {
        e.preventDefault();
        const url = new URL(link.href);
        const page = url.searchParams.get("page");
        fetchFilteredResumes("page=" + page);
      });
    });
  }

  // 城市筛选
  document.querySelectorAll(".city-btn").forEach((btn) => {
    btn.addEventListener("click", () => {
      document.getElementById("city-input").value = btn.dataset.value;

      document.querySelectorAll(".city-btn").forEach((b) => {
        b.classList.remove("btn-primary");
        b.classList.add("btn-outline-primary");
      });
      btn.classList.add("btn-primary");
      btn.classList.remove("btn-outline-primary");

      fetchFilteredResumes();
    });
  });

  // 教育筛选
  document.querySelectorAll(".edu-btn").forEach((btn) => {
    btn.addEventListener("click", () => {
      document.getElementById("education-input").value = btn.dataset.value;

      document.querySelectorAll(".edu-btn").forEach((b) => {
        b.classList.remove("btn-primary");
        b.classList.add("btn-outline-primary");
      });
      btn.classList.add("btn-primary");
      btn.classList.remove("btn-outline-primary");

      fetchFilteredResumes();
    });
  });

  // 年限筛选
  document.querySelectorAll(".workyears-btn").forEach((btn) => {
    btn.addEventListener("click", () => {
      document.getElementById("workyears-input").value = btn.dataset.value;

      document.querySelectorAll(".workyears-btn").forEach((b) => {
        b.classList.remove("btn-primary");
        b.classList.add("btn-outline-primary");
      });
      btn.classList.add("btn-primary");
      btn.classList.remove("btn-outline-primary");

      fetchFilteredResumes();
    });
  });

  // 搜索框支持回车查询
  form.querySelector("input[name='keyword']").addEventListener("keydown", (e) => {
    if (e.key === "Enter") {
      e.preventDefault();
      fetchFilteredResumes();
    }
  });

  // 初始分页绑定
  bindPagination();
});
