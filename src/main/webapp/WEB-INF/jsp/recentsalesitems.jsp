<%--
  Created by IntelliJ IDEA.
  User: tusharparmar
  Date: 02-02-2026
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
        .item-table th { font-size: 0.85rem; }

        /* Fixed Stacking/UI issue */
        #invoiceAccordion .accordion-item {
            margin-bottom: 1.5rem !important;
            border-radius: 0.5rem !important;
            overflow: hidden;
            border: 1px solid rgba(0,0,0,.125);
        }

            @media print {
                .app-shell, .container, .d-print-none, .accordion-button::after {
                    display: none !important;
                }

                #printSection {
                    display: block !important;
                    padding: 15mm;
                    background: white;
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    color: #333;
                }

                .bill-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: flex-start;
                    border-bottom: 4px solid #0d6efd;
                    padding-bottom: 20px;
                    margin-bottom: 30px;
                }

                .brand-logo h1 {
                    color: #0d6efd;
                    font-size: 32pt;
                    margin: 0;
                    letter-spacing: -1px;
                }

                /* Info Grid */
                .info-grid {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 20px;
                    margin-bottom: 40px;
                }

                .info-box h6 {
                    text-transform: uppercase;
                    color: #666;
                    font-size: 9pt;
                    margin-bottom: 5px;
                    border-bottom: 1px solid #eee;
                }

                /* Modern Table Styling */
                .table {
                    width: 100%;
                    border-collapse: collapse;
                    margin-bottom: 30px;
                }
                .table th {
                    background-color: #f8f9fa !important;
                    color: #444;
                    text-transform: uppercase;
                    font-size: 9pt;
                    padding: 12px 10px;
                    border-bottom: 2px solid #0d6efd !important;
                }
                .table td {
                    padding: 12px 10px;
                    border-bottom: 1px solid #eee !important;
                }

                /* Summary Card */
                .summary-card {
                    background: #f8f9fa;
                    padding: 20px;
                    border-radius: 8px;
                    width: 300px;
                    margin-left: auto;
                }
                .summary-line {
                    display: flex;
                    justify-content: space-between;
                    margin-bottom: 10px;
                }
                .grand-total {
                    border-top: 2px solid #0d6efd;
                    margin-top: 10px;
                    padding-top: 10px;
                    font-size: 14pt;
                    font-weight: bold;
                    color: #0d6efd;
                }

                #printSection {
                        display: block !important;
                        padding: 15mm;
                        background: white;
                        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                        color: #333;
                        /* FORCE COLORS HERE */
                        -webkit-print-color-adjust: exact !important;
                        print-color-adjust: exact !important;
                    }

                    .brand-logo h1 {
                        color: #0d6efd !important; /* Force Brand Blue */
                        font-size: 32pt;
                        margin: 0;
                        letter-spacing: -1px;
                    }

                    .table th {
                        background-color: #0d6efd !important; /* Blue Header */
                        color: white !important;
                        text-transform: uppercase;
                        font-size: 9pt;
                        padding: 12px 10px;
                    }

                    .summary-card {
                        background: #f0f7ff !important; /* Light Blue Shading */
                        padding: 20px;
                        border-radius: 8px;
                        width: 300px;
                        margin-left: auto;
                        border: 1px solid #0d6efd;
                    }

                    .grand-total {
                        color: #0d6efd !important;
                        font-size: 16pt;
                        border-top: 2px solid #0d6efd;
                    }

            }

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

<div id="printSection" class="d-none d-print-block"></div>

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

    sales.forEach((inv) => {
        html += `
        <div class="accordion-item shadow-sm invoice-card">
            <h2 class="accordion-header" id="heading${inv.id}">
                <button class="accordion-button collapsed" type="button"
                        data-bs-toggle="collapse"
                        data-bs-target="#collapse${inv.id}"
                        onclick="loadItems(${inv.id})">
                    <div class="w-100 d-flex justify-content-between align-items-center">
                        <div>
                            <span class="fw-bold text-primary">${inv.invoiceNumber}</span>
                            <span class="ms-3 badge bg-light text-dark border">${inv.customerName}</span>
                            <span class="ms-2 text-muted small">${inv.customerNumber || ''}</span>
                        </div>
                        <div class="text-end me-3">
                            <div class="small text-muted"><i class="fa-regular fa-calendar me-1"></i>${inv.invoiceDate}</div>
                            <div class="fw-bold text-success">₹ ${inv.grandTotal.toLocaleString()}</div>
                        </div>
                    </div>
                </button>
            </h2>
            <div id="collapse${inv.id}" class="accordion-collapse collapse"
                 data-bs-parent="#invoiceAccordion"
                 data-total="${inv.totalAmount}"
                 data-discount="${inv.discountAmount}"
                 data-grand="${inv.grandTotal}">
                <div class="accordion-body bg-white" id="details-${inv.id}">
                    <div class="text-center p-3">
                        <div class="spinner-border spinner-border-sm text-primary"></div>
                        <p class="small">Loading items...</p>
                    </div>
                </div>
            </div>
        </div>`;
    });

    html += `</div>`;
    container.innerHTML = html;
}

const loadedInvoices = new Set();

function loadItems(invoiceId) {
    if (loadedInvoices.has(invoiceId)) return;

    fetch(`/salesitem/api/invoice-items/${invoiceId}`)
        .then(res => res.json())
        .then(response => {
            const detailContainer = document.getElementById(`details-${invoiceId}`);
            if (response.success) {
                renderItemsTable(detailContainer, response.data, invoiceId);
                loadedInvoices.add(invoiceId);
            }
        })
        .catch(err => console.error("Error loading items:", err));
}

function renderItemsTable(container, items, invoiceId) {
    const parentCollapse = document.getElementById(`collapse${invoiceId}`);
    const total = parseFloat(parentCollapse.getAttribute('data-total'));
    const discount = parseFloat(parentCollapse.getAttribute('data-discount'));
    const grand = parseFloat(parentCollapse.getAttribute('data-grand'));

    let tableHtml = `
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h6 class="fw-bold m-0">Items</h6>
            <button class="btn btn-sm btn-outline-danger d-print-none" onclick="prepareAndPrint('collapse${invoiceId}', ${invoiceId})">
                <i class="fa-solid fa-file-pdf me-1"></i> Print Bill
            </button>
        </div>
        <div class="table-responsive">
            <table class="table table-sm align-middle item-table">
                <thead class="table-light">
                    <tr>
                        <th>Product</th>
                        <th>Variant</th>
                        <th>Qty</th>
                        <th>Unit Price</th>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody>
                    ${items.map(item => `
                        <tr>
                            <td>${item.productName} (${item.variantName})</td>
                            <td>${item.variantInfo || '-'}</td>
                            <td>${item.quantity}</td>
                            <td>₹ ${item.unitPrice.toLocaleString()}</td>
                            <td class="fw-bold">₹ ${item.lineTotal.toLocaleString()}</td>
                        </tr>
                    `).join('')}
                </tbody>
            </table>
        </div>
        <div class="row justify-content-end mt-3">
            <div class="col-md-4">
                <ul class="list-group list-group-flush">
                    <li class="list-group-item d-flex justify-content-between">
                        <span>Subtotal</span><span>₹ ${total.toLocaleString()}</span>
                    </li>
                    <li class="list-group-item d-flex justify-content-between text-danger">
                        <span>Discount</span><span>- ₹ ${discount.toLocaleString()}</span>
                    </li>
                    <li class="list-group-item d-flex justify-content-between fw-bold fs-5">
                        <span>Grand Total</span><span class="text-success">₹ ${grand.toLocaleString()}</span>
                    </li>
                </ul>
            </div>
        </div>`;

    container.innerHTML = tableHtml;
}

function prepareAndPrint(collapseId, invoiceId) {
    const accordionItem = document.getElementById(collapseId).closest('.accordion-item');
    const invNumber = accordionItem.querySelector('.text-primary').innerText;
    const custName = accordionItem.querySelector('.badge').innerText;

    // Scrape data from the lazy-loaded table
    const tableRows = accordionItem.querySelector('tbody').innerHTML;
    const parentCollapse = document.getElementById(collapseId);

    // Get financial values for the summary card
    const subtotal = parentCollapse.getAttribute('data-total');
    const discount = parentCollapse.getAttribute('data-discount');
    const grand = parentCollapse.getAttribute('data-grand');

    const printSection = document.getElementById('printSection');
    printSection.innerHTML = `
        <div class="bill-header">
            <div class="brand-logo">
                <h1>MONARCH</h1>
                <p style="margin:0; font-weight:bold; color:#666;">ERP SOLUTIONS</p>
            </div>
            <div style="text-align: right;">
                <h2 style="margin:0;">INVOICE</h2>
                <p style="color:#0d6efd; font-weight:bold; margin:0;">${invNumber}</p>
                <p style="font-size:10pt; margin:0;">Date: ${new Date().toLocaleDateString('en-IN')}</p>
            </div>
        </div>

        <div class="info-grid">
            <div class="info-box">
                <h6>Billed To</h6>
                <p style="margin:0;"><strong>${custName}</strong></p>
                <p style="margin:0; font-size:10pt; color:#555;">Customer ID: #${invoiceId}</p>
            </div>
            <div class="info-box" style="text-align: right;">
                <h6>Payment Status</h6>
                <p style="margin:0; color:#198754; font-weight:bold;">COMPLETED</p>
            </div>
        </div>

        <table class="table">
            <thead>
                <tr>
                    <th>Product</th>
                    <th>Colour/Size</th>
                    <th>Qty</th>
                    <th>Price</th>
                    <th style="text-align:left;">Total</th>
                </tr>
            </thead>
            <tbody>
                ${tableRows}
            </tbody>
        </table>

        <div class="summary-card">
            <div class="summary-line">
                <span>Subtotal</span>
                <span>₹ ${parseFloat(subtotal).toLocaleString()}</span>
            </div>
            <div class="summary-line" style="color:#dc3545;">
                <span>Discount</span>
                <span>- ₹ ${parseFloat(discount).toLocaleString()}</span>
            </div>
            <div class="summary-line grand-total">
                <span>Total Due</span>
                <span>₹ ${parseFloat(grand).toLocaleString()}</span>
            </div>
        </div>

        <div style="margin-top: 60px; text-align: center; border-top: 1px solid #eee; padding-top: 20px;">
            <p style="font-size:10pt; color:#888; margin:0;">Thank you for your business!</p>
            <p style="font-size:8pt; color:#aaa; margin:5px 0;">This is a system-generated invoice for Monarch ERP.</p>
        </div>
    `;

    window.print();
    printSection.innerHTML ='' ;
}
</script>
</body>
</html>