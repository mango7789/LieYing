console.log("Filter JS For Resume Loaded");

document.addEventListener("DOMContentLoaded", function () {
  // 城市
  document.querySelectorAll(".city-btn").forEach(function (btn) {
    btn.addEventListener("click", function () {
      document.getElementById("city-input").value = btn.dataset.value;
      document.getElementById("filter-form").submit();
    });
  });

  // 教育
  document.querySelectorAll(".edu-btn").forEach(function (btn) {
    btn.addEventListener("click", function () {
      document.getElementById("education-input").value = btn.dataset.value;
      document.getElementById("filter-form").submit();
    });
  });

  // 工作年限
  document.querySelectorAll(".workyears-btn").forEach(function (btn) {
    btn.addEventListener("click", function () {
      document.getElementById("workyears-input").value = btn.dataset.value;
      document.getElementById("filter-form").submit();
    });
  });
});
