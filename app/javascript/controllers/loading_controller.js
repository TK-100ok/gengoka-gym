import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="loading"
export default class extends Controller {
  static targets = ["overlay", "submit"]

  show() {
    this.overlayTarget.classList.remove("hidden")
    this.submitTarget.disabled = true
  }
}
