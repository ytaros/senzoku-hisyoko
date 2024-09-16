import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="unload"
export default class extends Controller {
  connect() {
    this.formSubmitting = false;
    this.dialogShown = false;

    this.element.addEventListener("submit", () => {
      this.formSubmitting = true;
    });

    this.confirmNavigation = this.confirmNavigation.bind(this);
    document.addEventListener("turbo:before-visit", this.confirmNavigation);
  }

  disconnect() {
    document.removeEventListener("turbo:before-visit", this.confirmNavigation);
  }

  confirmNavigation = (event) => {
    if (this.formSubmitting || this.dialogShown) {
      return;
    }

    if (!confirm("入力内容は失われます。ページを離れますか？")) {
      event.preventDefault();
    } else {
      this.dialogShown = true;
      this.deleteReceipt();
    }
  };

  deleteReceipt() {
    fetch(`/receipts/${this.data.get("receiptId")}/destroy_unload`, {
      method: "DELETE",
      headers: {
        "X-CSRF-Token": document
          .querySelector('meta[name="csrf-token"]')
          .getAttribute("content"),
        "Content-Type": "application/json",
      },
    }).then((response) => {
      if (response.ok) {
        // ページ全体をリロード
        window.location.reload();
      } else {
        console.error("伝票の削除に失敗");
      }
    });
  }
}
