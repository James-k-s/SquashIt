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

// ...existing imports and code...

function connectMatches() {
  const svg = document.getElementById("bracket-lines");
  const container = document.querySelector(".bracket-container");
  if (!svg || !container) return;

  // Size SVG to match the scrollable bracket area
  const width = container.scrollWidth;
  const height = container.scrollHeight;
  svg.setAttribute("width", width);
  svg.setAttribute("height", height);

  svg.innerHTML = ""; // reset paths

  document.querySelectorAll(".match[id^='match-']").forEach(matchEl => {
    const nextId = matchEl.dataset.nextMatchId;
    if (!nextId) return;

    const targetEl = document.getElementById(`match-${nextId}`);
    if (!targetEl) return;

    const r1 = matchEl.getBoundingClientRect();
    const r2 = targetEl.getBoundingClientRect();
    const rSvg = svg.getBoundingClientRect();

    const x1 = r1.right - rSvg.left;
    const y1 = r1.top + r1.height / 2 - rSvg.top;
    const x2 = r2.left - rSvg.left;
    const y2 = r2.top + r2.height / 2 - rSvg.top;

    const path = document.createElementNS("http://www.w3.org/2000/svg", "path");
    path.setAttribute("d", `M ${x1} ${y1} C ${(x1 + x2) / 2} ${y1}, ${(x1 + x2) / 2} ${y2}, ${x2} ${y2}`);
    path.setAttribute("stroke", "#444");
    path.setAttribute("fill", "none");
    path.setAttribute("stroke-width", "3");
    path.setAttribute("stroke-linecap", "round");
    path.style.opacity = "0.8";

    svg.appendChild(path);
  });
}

function scheduleConnect() {
  // Wait for Turbo render + layout/paint to settle
  requestAnimationFrame(() => requestAnimationFrame(connectMatches));
}

document.addEventListener("turbo:load", scheduleConnect);
document.addEventListener("turbo:render", scheduleConnect);
// Fallback for full reload
document.addEventListener("DOMContentLoaded", scheduleConnect);

// Keep updates in sync with UI changes
window.addEventListener("resize", scheduleConnect);
document.addEventListener("scroll", scheduleConnect, { passive: true });
document.addEventListener("wheel", scheduleConnect, { passive: true });

// If the bracket scrolls horizontally inside a container, also:
document.addEventListener("turbo:load", () => {
  const scroller = document.querySelector(".bracket-container");
  if (scroller) scroller.addEventListener("scroll", scheduleConnect, { passive: true });
});
