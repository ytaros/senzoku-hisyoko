import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="unload"
export default class extends Controller {
  connect() {
    this.formSubmitting = false;
    this.dialogShown = false;

    this.element.addEventListener("submit", () => {
      this.formSubmitting = true;
    });

    document.addEventListener("turbo:before-visit", this.confirmNavigation);
  }

  disconnect() {
    document.removeEventListener("turbo:before-visit", this.confirmNavigation);
  }

  confirmNavigation = (event) => {
    if (this.formSubmitting || this.dialogShown) {
      return;
    }

    const status = this.data.get("status");
    let confirmMessage = "";

    if (status === "in_progress") {
      confirmMessage = "入力中の内容は全て失われます。ページを離れますか？";
    } else {
      confirmMessage =
        "入力中の内容が伝票に反映されません。ページを離れますか？";
    }

    if (!confirm(confirmMessage)) {
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
