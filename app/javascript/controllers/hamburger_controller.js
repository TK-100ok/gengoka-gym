import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hamburger"
export default class extends Controller {
  static targets = ["drawer", "overlay"]

  toggle(event) {
    event.stopPropagation()

    this.drawerTarget.classList.toggle("-translate-x-full")
    this.overlayTarget.classList.toggle("hidden")

    document.body.classList.toggle("overflow-hidden")
  }

  close() {
    this.drawerTarget.classList.add("-translate-x-full")
    this.overlayTarget.classList.add("hidden")

    document.body.classList.remove("overflow-hidden")
  }
}
