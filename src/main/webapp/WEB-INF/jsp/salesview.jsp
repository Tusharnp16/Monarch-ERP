<%--
  Monarch ERP | Unified Sales Management
  View: Integrated Inline Details for Sales Invoices
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Monarch ERP | Sales</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --sidebar-width: 260px;
            --bg-soft: #f8f9fa;
        }

        body {
            background-color: var(--bg-soft);
            font-family: 'Inter', sans-serif;
        }

        .app-shell {
            display: grid;
            grid-template-columns: var(--sidebar-width) 1fr;
            min-height: 100vh;
        }

        /* Detail Row Styling */
        .invoice-link {
            cursor: pointer;
            color: #0d6efd;
            font-weight: 700;
            text-decoration: none;
            display: flex;
            align-items: center;
        }

        .detail-row {
            background-color: #fcfcfc;
            display: none; /* Hidden by default */
        }

        .inner-table-wrapper {
            background: white;
            border-radius: 8px;
            border: 1px solid #dee2e6;
            margin: 10px 0;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.05);
        }

        .sales-badge {
            background: #e7f5ff;
            color: #1971c2;
            border: 1px solid #a5d8ff;
            font-weight: 600;
        }
    </style>
</head>
<body>

<div class="app-shell">
    <%@ include file="/WEB-INF/fragments/sidebar.html" %>
    <script>
        console.log("page loaded")
    </script>

    <main class="main">
        <div class="topbar d-flex justify-content-between align-items-center bg-white border-bottom p-3">
            <div>
                <h1 class="h5 mb-0">Sales Invoices</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0" style="font-size: 0.75rem;">
                        <li class="breadcrumb-item text-primary">Revenue</li>
                        <li class="breadcrumb-item active">Sales History</li>
                    </ol>
                </nav>
            </div>
            <div>
                <button class="btn btn-outline-secondary btn-sm me-2"><i class="fas fa-download"></i> Export</button>
                <a href="/sales/create" class="btn btn-success shadow-sm">
                    <i class="fas fa-cart-plus me-1"></i> New Sale
                </a>
            </div>
        </div>

        <div class="container-fluid py-4">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white py-3">
                    <h6 class="mb-0"><i class="fa-solid fa-file-invoice-dollar me-2 text-success"></i>All Sales Transactions</h6>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table align-middle mb-0">
                            <thead class="table-light text-uppercase small" style="letter-spacing: 0.5px;">
                            <tr>
                                <th class="ps-3">Invoice No</th>
                                <th>Customer</th>
                                <th>Date</th>
                                <th>Items</th>
                                <th>Discount</th>
                                <th>Grand Total</th>
                                <th class="text-end pe-3">Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${salesInvoices}" var="s">
                                <tr class="main-row">
                                    <td class="ps-3">
                                        <a class="invoice-link" onclick="toggleDetails('details-${s.id}', this)">
                                            <i class="fa-solid fa-caret-right me-2 text-muted"></i>
                                            <span class="badge sales-badge px-2 py-1">${s.invoiceNumber}</span>
                                        </a>
                                    </td>
                                    <td>
                                        <div class="fw-bold text-dark">${s.customer.name}</div>
                                        <div class="text-muted small">${s.customer.mobile}</div>
                                    </td>
                                    <td><span class="text-muted">${s.invoiceDate}</span></td>
                                    <td><span class="badge rounded-pill bg-light text-dark border">${s.items.size()} Qty</span></td>
                                    <td class="text-danger">- ₹ ${s.discountAmount}</td>
                                    <td class="fw-bold text-success">₹ ${s.invoice.grandTmfnkdjfotal}</td>
                                    <td class="text-end pe-3">
                                        <button class="btn btn-sm btn-light border" title="Print Invoice">
                                            <i class="fas fa-print"></i>
                                        </button>
                                        <button class="btn btn-sm btn-light border text-primary" title="View PDF">
                                            <i class="fas fa-file-pdf"></i>
                                        </button>
                                    </td>
                                </tr>

                                <%-- Collapsible Detail Row --%>
                                <tr id="details-${s.id}" class="detail-row">
                                    <td colspan="7" class="px-4 py-3 bg-light">
                                        <div class="inner-table-wrapper p-3">
                                            <div class="d-flex justify-content-between align-items-center mb-3">
                                                <h6 class="small fw-bold text-uppercase text-secondary mb-0">Line Items</h6>
                                                <span class="small text-muted">Tax Total: <strong>₹ ${s.taxAmount}</strong></span>
                                            </div>
                                            <table class="table table-sm table-hover mb-0">
                                                <thead class="table-light">
                                                <tr class="small text-muted">
                                                    <th>Product Description</th>
                                                    <th class="text-center">Qty</th>
                                                    <th>Unit Price</th>
                                                    <th>Discount</th>
                                                    <th class="text-end">Line Total</th>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <c:forEach items="${s.items}" var="item">
                                                    <tr>
                                                        <td>
                                                            <div class="fw-semibold">${item.variant.product.productName}</div>
                                                            <div class="small text-muted">
                                                                ${item.variant.variantName} | ${item.variant.size}
                                                            </div>
                                                        </td>
                                                        <td class="text-center">${item.quantity}</td>
                                                        <td>₹ ${item.unitPrice}</td>
                                                        <td class="text-danger">₹ ${item.discountAmount}</td>
                                                        <td class="text-end fw-bold">₹ ${item.lineTotal}</td>
                                                    </tr>
                                                </c:forEach>
                                                </tbody>
                                                <tfoot class="border-top">
                                                    <tr class="small">
                                                        <td colspan="4" class="text-end text-muted">Sub-Total:</td>
                                                        <td class="text-end text-dark">₹ ${s.totalAmount}</td>
                                                    </tr>
                                                </tfoot>
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<script>
    function toggleDetails(rowId, element) {
        const row = document.getElementById(rowId);
        const icon = element.querySelector('i');

        if (row.style.display === "table-row") {
            row.style.display = "none";
            icon.classList.replace('fa-caret-down', 'fa-caret-right');
        } else {
            row.style.display = "table-row";
            icon.classList.replace('fa-caret-right', 'fa-caret-down');
        }
    }
</script>
</body>
</html>