// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("click", (e) => {
  const closeBtn = e.target.closest("[data-flash-close]");
  if (!closeBtn) return;
  const flash = closeBtn.closest("[data-flash]");
  if (flash) flash.remove();
});

// Optional: auto-dismiss after 5s
document.addEventListener("turbo:load", () => {
  document.querySelectorAll("[data-flash]").forEach(flash => {
    setTimeout(() => {
      flash.style.transition = "opacity .3s";
      flash.style.opacity = "0";
      setTimeout(() => flash.remove(), 300);
    }, 5000);
  });
});

// ...existing code...

document.addEventListener("click", async (e) => {
  const btn = e.target.closest("[data-copy-share-link]");
  if (!btn) return;

  const url = btn.getAttribute("data-url");
  const csrf = document.querySelector('meta[name="csrf-token"]')?.content;

  try {
    const res = await fetch(url, {
      method: "POST",
      headers: { "Accept": "application/json", "X-CSRF-Token": csrf }
    });
    if (!res.ok) {
      const text = await res.text();
      console.error("Share failed", res.status, text);
      if (res.status === 403) alert("Only the organizer can generate a link.");
      else alert("Could not generate/copy link.");
      return;
    }
    const data = await res.json();
    await navigator.clipboard.writeText(data.url);
    const original = btn.textContent;
    btn.textContent = "Link copied!";
    setTimeout(() => (btn.textContent = original), 1500);
  } catch (err) {
    console.error(err);
    alert("Could not generate/copy link.");
  }
});
