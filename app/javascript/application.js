// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

document.addEventListener("turbo:load", () => {
  const select = document.getElementById("training_target_id");
  const customField = document.getElementById("custom-target-field");

  if (!select || !customField) return;

  const toggle = () => {
    if (select.selectedOptions[0].text === "その他") {
      customField.classList.remove("hidden");
    } else {
      customField.classList.add("hidden");
    }
  };

  select.addEventListener("change", toggle);

  toggle();
});
