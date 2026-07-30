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

    this.counterTarget.classList.remove(
      "text-gray-500",
      "text-amber-500",
      "text-red-500"
    )

    if (length <= 9) {
      this.counterTarget.classList.add("text-red-500")
    } else if (length <= 550) {
      this.counterTarget.classList.add("text-gray-500")
    } else if (length <= 600) {
      this.counterTarget.classList.add("text-amber-500")
    } else {
      this.counterTarget.classList.add("text-red-500")
    }
  }
}
