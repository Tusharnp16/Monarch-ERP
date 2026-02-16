<%--
  Created by IntelliJ IDEA.
  User: tusharparmar
  Date: 02-02-2026
  Time: 11:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Monarch ERP | Recent Sales</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        body { background-color: #f8f9fa; }
        .invoice-card { border-top: 4px solid #0d6efd; }
        .invoice-header { cursor: pointer; }
        .item-table th { font-size: 0.85rem; }
        .badge-soft { background: #e7f1ff; color: #0d6efd; }
    </style>
</head>

<body>
<div class="app-shell">
    <%@ include file="/WEB-INF/fragments/sidebar.html" %>

      <div class="container py-5">
          <div class="d-flex justify-content-between align-items-center mb-4">
              <h2 class="h4"><i class="fa-solid fa-clock-rotate-left me-2"></i>Recent Sales Invoices</h2>
              <a href="/salesinvoice" class="btn btn-primary"><i class="fa-solid fa-plus me-1"></i> New Invoice</a>
          </div>

          <div id="invoiceContainer">
              <div class="text-center p-5">
                  <div class="spinner-border text-primary" role="status"></div>
                  <p class="mt-2">Loading invoices...</p>
              </div>
          </div>
      </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', () => {
    fetchRecentInvoices();
});

function fetchRecentInvoices() {
    fetch('/salesitem/api/recentitems')
        .then(res => res.json())
        .then(response => {
            const container = document.getElementById('invoiceContainer');

            if (!response.success || response.data.length === 0) {
                container.innerHTML = '<div class="alert alert-info text-center">No recent invoices found.</div>';
                return;
            }

            renderAccordion(response.data);
        })
        .catch(err => console.error("Error loading invoices:", err));
}

function renderAccordion(sales) {
    const container = document.getElementById('invoiceContainer');
    let html = `<div class="accordion" id="invoiceAccordion">`;

    sales.forEach((inv, index) => {

        html += `
        <div class="accordion-item mb-3 shadow-sm rounded invoice-card">
            <h2 class="accordion-header">
                <button class="accordion-button collapsed" type="button"
                        data-bs-toggle="collapse"
                        data-bs-target="#collapse${inv.id}"
                        onclick="loadItems(${inv.id})">
                    <div class="w-100 d-flex justify-content-between align-items-center">
                        <div>
                            <span class="fw-bold text-primary">${inv.invoiceNumber}</span>
                            <span class="ms-3 badge bg-light text-dark border">${inv.customerName}</span>
                        </div>
                        <div class="text-end me-3">
                            <div class="fw-bold text-success">₹ ${inv.grandTotal.toLocaleString()}</div>
                        </div>
                    </div>
                </button>
            </h2>
            <div id="collapse${inv.id}" class="accordion-collapse collapse" data-bs-parent="#invoiceAccordion">
                <div class="accordion-body bg-white" id="details-${inv.id}">
                    <div class="text-center p-3">
                        <div class="spinner-border spinner-border-sm text-primary"></div>
                        <p class="small">Loading items...</p>
                    </div>
                </div>
            </div>
        </div>`;
    });
    container.innerHTML = html + `</div>`;
}

const loadedInvoices = new Set();

function loadItems(invoiceId) {
    if (loadedInvoices.has(invoiceId)) return;

    fetch(`/salesitem/api/invoice-items/${invoiceId}`)
        .then(res => res.json())
        .then(response => {
            const detailContainer = document.getElementById(`details-${invoiceId}`);

            if (response.success) {
                renderItemsTable(detailContainer, response.data);
                loadedInvoices.add(invoiceId);
            }
        })
        .catch(err => console.error("Error loading items:", err));
}

function renderItemsTable(container, items) {
    if (items.length === 0) {
        container.innerHTML = "No items found.";
        return;
    }

    let tableHtml = `
        <h6 class="fw-bold mb-3">Items</h6>
        <div class="table-responsive">
            <table class="table table-sm align-middle">
                <thead class="table-light">
                    <tr><th>Product</th><th>Qty</th><th>Price</th><th>Total</th></tr>
                </thead>
                <tbody>
                    ${items.map(item => `
                        <tr>
                            <td>${item.productName}</td>
                            <td>${item.quantity}</td>
                            <td>₹ ${item.unitPrice}</td>
                            <td class="fw-bold">₹ ${item.lineTotal}</td>
                        </tr>
                    `).join('')}
                </tbody>
            </table>
        </div>`;

    container.innerHTML = tableHtml;
}
</script>
</body>
</html>

