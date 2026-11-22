// Delegation keeps toggles working across Turbo visits without duplicate listeners.
document.addEventListener("click", (event) => {
  const trigger = event.target.closest("#hamburger, #account")
  if (!trigger) return

  const menu = document.getElementById(trigger.getAttribute("aria-controls"))
  if (!menu) return

  event.preventDefault()
  const mobile = trigger.id === "hamburger"
  const active = menu.classList.toggle(mobile ? "collapse" : "active")
  const expanded = mobile ? !active : active
  trigger.setAttribute("aria-expanded", String(expanded))
  if (mobile) trigger.classList.toggle("collapsed", !expanded)
})

// Do not restore an open menu from Turbo's cached page.
document.addEventListener("turbo:before-cache", () => {
  document.getElementById("dropdown-menu")?.classList.remove("active")
  document.getElementById("navbar-menu")?.classList.add("collapse")
  document.getElementById("hamburger")?.classList.add("collapsed")
  document.querySelectorAll("#hamburger, #account").forEach((trigger) => {
    trigger.setAttribute("aria-expanded", "false")
  })
})
