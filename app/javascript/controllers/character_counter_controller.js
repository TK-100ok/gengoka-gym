import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="character-counter"
export default class extends Controller {
  static targets = ["textarea", "counter"]

  connect() {
    this.count()
  }

  count() {
    const length = this.textareaTarget.value.length
    this.counterTarget.textContent = `${length} / 600文字`
  }
}
