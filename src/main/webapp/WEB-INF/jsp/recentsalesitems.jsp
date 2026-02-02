<%--
  Created by IntelliJ IDEA.
  User: tusharparmar
  Date: 02-02-2026
  Time: 11:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
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
            <h2 class="h4">
                <i class="fa-solid fa-clock-rotate-left me-2"></i>Recent Sales Invoices
            </h2>
            <a href="/salesinvoice" class="btn btn-primary">
                <i class="fa-solid fa-plus me-1"></i> New Invoice
            </a>
        </div>

        <c:choose>
            <c:when test="${empty sales}">
                <div class="alert alert-info text-center">
                    No recent invoices found.
                </div>
            </c:when>

            <c:otherwise>
                <div class="accordion" id="invoiceAccordion">

                    <c:forEach var="inv" items="${sales}" varStatus="loop">
                        <div class="accordion-item mb-3 shadow-sm rounded invoice-card">
                            <h2 class="accordion-header invoice-header" id="heading${loop.index}">
                                <button class="accordion-button collapsed" type="button"
                                        data-bs-toggle="collapse"
                                        data-bs-target="#collapse${loop.index}">

                                    <div class="w-100 d-flex justify-content-between">
                                        <div>
                                            <span class="fw-bold text-primary">${inv.invoiceNumber}</span>
                                            <span class="ms-3 badge badge-soft">
                                                ${inv.customer.name}
                                            </span>
                                            <span class="ms-2 text-muted small">
                                                ${inv.customer.mobile}
                                            </span>
                                        </div>
                                        <div class="text-end">
                                            <div class="small text-muted">
                                                <i class="fa-regular fa-calendar me-1"></i>
                                                ${inv.invoiceDate}
                                            </div>
                                            <div class="fw-bold text-success">
                                                ₹ ${inv.grandTotal}
                                            </div>
                                        </div>
                                    </div>
                                </button>
                            </h2>

                            <div id="collapse${loop.index}" class="accordion-collapse collapse"
                                 data-bs-parent="#invoiceAccordion">
                                <div class="accordion-body bg-white">

                                    <h6 class="fw-bold mb-3">Items</h6>

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
                                                <c:forEach var="item" items="${inv.items}">
                                                    <tr>
                                                        <td>${item.variant.variantName}</td>
                                                        <td>${item.variant.colour} / ${item.variant.size}</td>
                                                        <td>${item.quantity}</td>
                                                        <td>₹ ${item.unitPrice}</td>
                                                        <td class="fw-bold">₹ ${item.quantity * item.unitPrice}</td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>

                                    <div class="row justify-content-end mt-3">
                                        <div class="col-md-4">
                                            <ul class="list-group list-group-flush">
                                                <li class="list-group-item d-flex justify-content-between">
                                                    <span>Subtotal</span>
                                                    <span>₹ ${inv.totalAmount}</span>
                                                </li>
                                                <li class="list-group-item d-flex justify-content-between text-danger">
                                                    <span>Discount</span>
                                                    <span>- ₹ ${inv.discountAmount}</span>
                                                </li>
                                                <li class="list-group-item d-flex justify-content-between fw-bold fs-5">
                                                    <span>Grand Total</span>
                                                    <span class="text-success">₹ ${inv.grandTotal}</span>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </c:forEach>

                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

