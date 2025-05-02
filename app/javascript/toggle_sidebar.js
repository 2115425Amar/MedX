document.addEventListener("turbo:load", () => {
    const sidebar = document.getElementById("sidebar");
    const toggleBtn = document.getElementById("sidebarToggle");
  
    if (toggleBtn && sidebar) {
      toggleBtn.addEventListener("click", () => {
        console.log("Toggle button clicked");
        sidebar.classList.toggle("-translate-x-full");
      });
    }
});
  