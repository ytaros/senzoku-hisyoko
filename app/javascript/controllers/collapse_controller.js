import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="collapse"
export default class extends Controller {
  static targets = ["icon"];

  connect() {
    this.toggleIcon();
  }

  toggleIcon() {
    const collapseElement = document.querySelector(
      this.element.getAttribute("href")
    );
    collapseElement.addEventListener("shown.bs.collapse", () => {
      this.iconTarget.classList.remove("fa-magnifying-glass-plus");
      this.iconTarget.classList.add("fa-magnifying-glass-minus");
    });

    collapseElement.addEventListener("hidden.bs.collapse", () => {
      this.iconTarget.classList.remove("fa-magnifying-glass-minus");
      this.iconTarget.classList.add("fa-magnifying-glass-plus");
    });
  }
}
