<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Monarch ERP | Sales Invoice</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <style>
        .invoice-card { border-top: 4px solid #0d6efd; }
        .item-row { border-bottom: 1px solid #eee; padding: 10px 0; }
        .bg-soft { background-color: #f8f9fa; }
        .stock-label { font-size: 0.75rem; display: block; margin-top: 4px; min-height: 1rem; }
        .low-stock { color: #dc3545; font-weight: bold; }
    </style>
</head>

<body class="bg-soft">
<div class="app-shell">
    <%@ include file="/WEB-INF/fragments/sidebar.html" %>

    <div class="container py-5">
        <form action="/salesinvoice/add" method="post" id="salesForm">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="h4"><i class="fa-solid fa-file-invoice-dollar me-2"></i>New Sales Invoice</h2>
                <button type="submit" class="btn btn-primary">
                    <i class="fa-solid fa-check me-1"></i> Finalize Sale
                </button>
            </div>

            <div class="row g-4">
                <div class="col-md-4">
                    <div class="card h-100 invoice-card">
                        <div class="card-header bg-white fw-bold">Customer Details</div>
                        <div class="card-body">
                            <div class="mb-3">
                                <label class="form-label">Mobile Number</label>
                                <div class="input-group">
                                    <input type="text" class="form-control" name="customer.mobile" id="custMobile" required>
                                    <button class="btn btn-outline-primary" type="button" onclick="fetchCustomer()">
                                        <i class="fa-solid fa-search"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Customer Name</label>
                                <input type="text" class="form-control" name="customer.name" id="custName" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Email</label>
                                <input type="email" class="form-control" name="customer.email" id="custEmail">
                            </div>
                            <div id="customerStatus" class="small"></div>
                        </div>
                    </div>
                </div>

                <div class="col-md-8">
                    <div class="card invoice-card">
                        <div class="card-header bg-white d-flex justify-content-between align-items-center">
                            <span class="fw-bold">Billing Items</span>
                            <button type="button" class="btn btn-sm btn-outline-success" onclick="addRow()">
                                <i class="fa-solid fa-plus"></i> Add Item
                            </button>
                        </div>

                        <div class="card-body">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Invoice Number</label>
                                <input type="text" id="invoiceNumber" class="form-control" readonly>
                            </div>
                            <table class="table align-middle" id="itemsTable">
                                <thead>
                                    <tr class="text-muted small">
                                        <th style="width:40%">Variant</th>
                                        <th>Qty</th>
                                        <th>MRP</th>
                                        <th>Price</th>
                                        <th>Total</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr class="item-row">
                                        <td>
                                            <select class="form-select variant-select" name="items[0].variant.variantId" onchange="updateRowDetails(this)" required>
                                                <option value="">Select Variant</option>
                                                <c:forEach items="${inventory}" var="i">
                                                    <c:if test="${not empty i.variant.variantName}">
                                                        <option value="${i.variant.variantId}">${i.variant.variantName}</option>
                                                    </c:if>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td>
                                            <input type="number" class="form-control qty" name="items[0].quantity" value="1" min="1" oninput="validateStock(this)" required>
                                            <small class="stock-label text-muted"></small>
                                        </td>
                                        <td><input type="number" class="form-control price" name="items[0].unitPrice" step="0.01" oninput="calculate()" required></td>
                                        <td><span class="row-total fw-bold">0.00</span></td>
                                        <td><button type="button" class="btn btn-link text-danger" onclick="removeRow(this)"><i class="fa-solid fa-trash"></i></button></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="card-footer bg-light p-4">
                            <div class="row">
                                <div class="col-md-7">
                                    <label class="form-label text-muted small fw-bold">Internal Notes</label>
                                    <textarea class="form-control" name="notes" rows="3" placeholder="Reference..."></textarea>
                                </div>
                                <div class="col-md-5">
                                    <div class="d-flex justify-content-between mb-2">
                                        <span class="text-muted">Subtotal</span>
                                        <span id="subtotal" class="fw-bold">0.00</span>
                                    </div>
                                    <div class="d-flex justify-content-between mb-2 align-items-center">
                                        <span class="text-muted">Discount</span>
                                        <input type="number" name="discountAmount" id="discount" class="form-control form-control-sm w-50" value="0" min="0" oninput="calculate()">
                                    </div>
                                    <hr>
                                    <div class="d-flex justify-content-between">
                                        <span class="h5">Grand Total</span>
                                        <span class="h5 text-primary fw-bold" id="grandTotal">0.00</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<script>
    // Data passed from Spring Controller
    const inventoryData = [
        <c:forEach items="${inventory}" var="i" varStatus="s">
            <c:if test="${not empty i.variant.variantName}">
                {
                    id: "${i.variant.variantId}",
                    name: "${i.variant.variantName}",
                    price: ${i.variant.sellingPrice != null ? i.variant.sellingPrice.price : 0},
                    mrp : ${i.variant.mrp!=null ? i.variant.mrp.price : 0},
                    stock: ${i.quantity != null ? i.quantity : 0}
                }<c:if test="${!s.last}">,</c:if>
            </c:if>
        </c:forEach>
    ];

    function fetchCustomer() {
        const mobile = document.getElementById('custMobile').value.trim();
        const statusDiv = document.getElementById('customerStatus');
        if (mobile.length < 10) return;

        fetch('/customer/api/search?mobile=' + mobile)
            .then(response => response.status === 204 ? null : response.json())
            .then(data => {
                if (data) {
                    document.getElementById('custName').value = data.name || '';
                    document.getElementById('custEmail').value = data.email || '';
                    statusDiv.innerHTML = '<span class="text-success small">Existing Customer Loaded</span>';
                } else {
                    statusDiv.innerHTML = '<span class="text-primary small">New Customer - Enter Details</span>';
                }
            });
    }

    let rowCount = 1;
    function addRow() {
        const table = document.getElementById('itemsTable').getElementsByTagName('tbody')[0];
        const newRow = table.insertRow();
        newRow.className = "item-row";

        let options = '<option value="">Select Variant</option>';
        inventoryData.forEach(v => {
            options += '<option value="' + v.id + '">' + v.name + '</option>';
        });

        newRow.innerHTML =
            '<td>' +
                '<select class="form-select variant-select" name="items[' + rowCount + '].variant.variantId" onchange="updateRowDetails(this)" required>' +
                    options +
                '</select>' +
            '</td>' +
            '<td>' +
                '<input type="number" class="form-control qty" name="items[' + rowCount + '].quantity" value="1" min="1" oninput="validateStock(this)" required>' +
                '<small class="stock-label text-muted"></small>' +
            '</td>' +
            '<td><input type="number" class="form-control price" name="items[' + rowCount + '].unitPrice" step="0.01" oninput="calculate()" readonly></td>' +
              '<td><span class="row-total fw-bold">0.00</span></td>' +
            '<td><button type="button" class="btn btn-link text-danger" onclick="removeRow(this)"><i class="fa-solid fa-trash"></i></button></td>';
        rowCount++;
    }

    function removeRow(btn) {
        btn.closest('tr').remove();
        calculate();
    }

    function updateRowDetails(select) {
        const row = select.closest('tr');
        const variantId = select.value;
        const priceInput = row.querySelector('.price');
        const qtyInput = row.querySelector('.qty');
        const stockLabel = row.querySelector('.stock-label');

        const data = inventoryData.find(v => v.id == variantId);

        if (data) {
            priceInput.value = data.price;
            qtyInput.max = data.stock;
            stockLabel.innerText = "In Stock: " + data.stock;
            if (data.stock < 5) stockLabel.classList.add('low-stock');
            else stockLabel.classList.remove('low-stock');
        } else {
            priceInput.value = 0;
            qtyInput.max = "";
            stockLabel.innerText = "";
        }
        calculate();
    }

    fetch('/salesinvoice/next-number')
        .then(res => res.text())
        .then(no => document.getElementById('invoiceNumber').value = no);

    function validateStock(input) {
        const max = parseInt(input.max);
        if (max && parseInt(input.value) > max) {
            alert("Insufficient Stock! Available: " + max);
            input.value = max;
        }
        calculate();
    }

    function calculate() {
        let subtotal = 0;
        document.querySelectorAll('.item-row').forEach(row => {
            const qty = parseFloat(row.querySelector('.qty').value) || 0;
            const price = parseFloat(row.querySelector('.price').value) || 0;
            const total = qty * price;
            row.querySelector('.row-total').innerText = total.toFixed(2);
            subtotal += total;
        });

        const discount = parseFloat(document.getElementById('discount').value) || 0;
        document.getElementById('subtotal').innerText = subtotal.toFixed(2);
        document.getElementById('grandTotal').innerText = (subtotal - discount).toFixed(2);
    }

    // Run calculation once on load
    window.onload = calculate;
</script>
</body>
</html>