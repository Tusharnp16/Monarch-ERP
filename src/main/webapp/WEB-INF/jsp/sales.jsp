<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Monarch ERP | Sales Invoice</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <style>
        .invoice-card {
            border-top: 4px solid #0d6efd;
        }

        .item-row {
            border-bottom: 1px solid #eee;
            padding: 10px 0;
        }

        .bg-soft {
            background-color: #f8f9fa;
        }

        .stock-label {
            font-size: 0.75rem;
            display: block;
            margin-top: 4px;
            min-height: 1rem;
        }

        .low-stock {
            color: #dc3545;
            font-weight: bold;
        }

        body {
            background-color: #f4f6f9;
        }

        .is-invalid {
            border-color: #dc3545 !important;
            background-color: #fff5f5;
        }

        .stock-label.low-stock {
            color: #dc3545;
            font-weight: 600;
        }


        .invoice-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        }

        .invoice-card .card-header {
            border-bottom: 1px solid #eee;
            font-size: 15px;
        }

        .item-row {
            border-bottom: 1px solid #f1f1f1;
        }

        .bg-soft {
            background-color: #f8f9fa;
        }

        .stock-label {
            font-size: 0.75rem;
            margin-top: 4px;
            display: block;
        }

        .low-stock {
            color: #dc3545;
            font-weight: 600;
        }

        #grandTotal {
            font-size: 1.4rem;
        }

        #subtotal {
            font-weight: 600;
        }


        .card-footer {
            border-top: 1px solid #eee;
        }
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
                                    <input type="text" class="form-control" maxlength="10" name="customer.mobile"
                                           id="custMobile" required>
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
                                    <th>Selling Cost</th>
                                    <th>Price</th>
                                    <th>Total</th>
                                    <th></th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr class="item-row">
                                    <td>
                                        <select class="form-select variant-select" name="items[0].variant.variantId"
                                                onchange="updateRowDetails(this)" required>
                                            <option value="">Select Variant</option>
                                            <c:forEach items="${inventory}" var="i">
                                                <c:if test="${not empty i.variant.variantName}">
                                                    <option value="${i.variant.variantId}">${i.variant.variantName} ( ${i.variant.colour} / ${i.variant.size} )</option>
                                                </c:if>
                                            </c:forEach>
                                        </select>
                                    </td>
                                    <td>
                                        <input type="number" class="form-control qty" name="items[0].quantity" value="1"
                                               min="1" oninput="validateStock(this)" required>
                                        <small class="stock-label text-muted"></small>
                                    </td>
                                    <td><input type="number" class="form-control mrp" name="items[0].sellingPrice"
                                               step="0.01" readonly required></td>

                                    <td><input type="number" class="form-control price" name="items[0].unitPrice"
                                               step="0.01" oninput="calculate()" readonly required></td>
                                    <td><span class="row-total fw-bold">0.00</span></td>
                                    <td>
                                        <button type="button" class="btn btn-link text-danger"
                                                onclick="removeRow(this)"><i class="fa-solid fa-trash"></i></button>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="card-footer bg-light p-4">
                            <div class="row">
                                <div class="col-md-7">
                                    <label class="form-label text-muted small fw-bold">Internal Notes</label>
                                    <textarea class="form-control" name="notes" rows="3"
                                              placeholder="Reference..."></textarea>
                                </div>
                                <div class="col-md-5">
                                    <div class="d-flex justify-content-between mb-2">
                                        <span class="text-muted">Subtotal</span>
                                        <span id="subtotal" class="fw-bold">0.00</span>
                                    </div>
                                    <div class="d-flex justify-content-between mb-2 align-items-center">
                                        <span class="text-muted">Discount</span>
                                        <input type="number" name="discountAmount" id="discount"
                                               class="form-control form-control-sm w-50" value="0" min="0"
                                               oninput="calculate()">
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
        <div class="card mt-4 invoice-card">
            <div class="card-header bg-white fw-bold">
                <i class="fa-solid fa-fire text-danger me-2"></i>Top Selling (7 Days)
            </div>

            <table class="table">
                <thead>
                <tr>
                    <th>Product</th>
                    <th>Variant</th>
                    <th>Specs</th>
                    <th>Sold</th>
                    <th>Total Amount</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${topSellers}" var="item">
                    <tr>
                        <td>${item[0]}</td>
                        <td>${item[1]}</td>
                        <td>
                            <span class="badge bg-secondary">${item[2]}</span> <span
                                class="badge bg-info">${item[3]}</span></td>
                        <td class="fw-bold text-primary">${item[4]}</td>
                        <td class="fw-bold text-primary">${item[5]}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

    </div>
</div>

<script>

    let mobileTimer;
    document.getElementById("custMobile").addEventListener("input", function () {
        clearTimeout(mobileTimer);
        const mobile = this.value.trim();

        if (/^[0-9]{10}$/.test(mobile)) {
            mobileTimer = setTimeout(fetchCustomer, 400); // slight delay to avoid rapid API calls
        }

        if (mobile.length == 0) {
            document.getElementById('custName').value = '';
            document.getElementById('custEmail').value = '';
            document.getElementById('statusDiv').value = '';

            statusDiv.innerHTML = ' ';
        }
    });

    const inventoryData = [
        <c:forEach items="${inventory}" var="i" varStatus="s">
        <c:if test="${not empty i.variant.variantName}">
        {
            id: "${i.variant.variantId}",
            name: "${i.variant.variantName}",
            color: "${i.variant.colour}",
            size: "${i.variant.size}",
            price: ${i.variant.sellingPrice != null ? i.variant.sellingPrice.price : 0},
            mrp: ${i.variant.mrp!=null ? i.variant.mrp.price : 0},
            stock: ${i.availableQuantity != null ? i.availableQuantity : 0}
        }<c:if test="${!s.last}">, </c:if>
        </c:if>
        </c:forEach>
    ];

    console.log(inventoryData)

    function fetchCustomer() {
        const mobile = document.getElementById('custMobile').value.trim();
        const statusDiv = document.getElementById('customerStatus');
        if (mobile.length < 10) return;

        fetch('/api/customers/search?mobile=' + mobile)
            .then(response => response.status === 204 ? null : response.json())
            .then(data => {
                if (data) {
                    document.getElementById('custName').value = data.data.name || '';
                    document.getElementById('custEmail').value = data.data.email || '';
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
            options += '<option value="' + v.id + '">' + v.name + ' (' + v.color + ' / ' + v.size + ')</option>';
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
            '<td><input type="number" class="form-control mrp" name="items[' + rowCount + '].mrp" step="0.01" readonly></td>' +

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
        const mrpInput = row.querySelector('.mrp');
        const stockLabel = row.querySelector('.stock-label');

        const data = inventoryData.find(v => v.id == variantId);

        if (data) {
            priceInput.value = data.price
            mrpInput.value = data.mrp;
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

    // ===== FORM VALIDATION =====
    document.getElementById("salesForm").addEventListener("submit", function (e) {

        const mobile = document.getElementById("custMobile").value.trim();
        const name = document.getElementById("custName").value.trim();
        const rows = document.querySelectorAll(".item-row");

        if (!/^[0-9]{10}$/.test(mobile)) {
            alert("Enter valid 10-digit mobile number");
            e.preventDefault();
            return;
        }


        if (name.length < 2) {
            alert("Customer name is required");
            e.preventDefault();
            return;
        }

        if (rows.length === 0) {
            alert("Add at least one item to invoice");
            e.preventDefault();
            return;
        }

        let valid = true;

        rows.forEach(row => {
            const qty = row.querySelector(".qty");
            const price = row.querySelector(".price");

            if (parseFloat(qty.value) <= 0) {
                qty.classList.add("is-invalid");
                valid = false;
            } else qty.classList.remove("is-invalid");

            if (parseFloat(price.value) <= 0) {
                price.classList.add("is-invalid");
                valid = false;
            } else price.classList.remove("is-invalid");
        });

        const discount = parseFloat(document.getElementById("discount").value);
        if (discount < 0) {
            alert("Discount cannot be negative");
            e.preventDefault();
            return;
        }

        if (!valid) {
            alert("Please correct highlighted item fields");
            e.preventDefault();
        }
    });


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

        let discountInput = document.getElementById('discount');
        let discount = parseFloat(discountInput.value) || 0;

        const limitPercentage = ${maxDiscountLimit != null ? maxDiscountLimit : 0.15};
        const maxAllowedDiscount = subtotal * limitPercentage;

        if (discount > maxAllowedDiscount) {

            alert("Maximum allowed discount is " + (limitPercentage * 100) + "% (₹" + maxAllowedDiscount.toFixed(2) + ")");

            discount = maxAllowedDiscount;
            discountInput.value = maxAllowedDiscount.toFixed(2);
            discountInput.classList.add("is-invalid");
        } else {
            discountInput.classList.remove("is-invalid");
        }

        document.getElementById('subtotal').innerText = subtotal.toFixed(2);
        document.getElementById('grandTotal').innerText = (subtotal - discount).toFixed(2);
    }
    // function calculate() {
    //     let subtotal = 0;
    //
    //     document.querySelectorAll('.item-row').forEach(row => {
    //         const qty = parseFloat(row.querySelector('.qty').value) || 0;
    //         const price = parseFloat(row.querySelector('.price').value) || 0;
    //         const total = qty * price;
    //         row.querySelector('.row-total').innerText = total.toFixed(2);
    //         subtotal += total;
    //     });
    //
    //     let discountInput = document.getElementById('discount');
    //     let discount = parseFloat(discountInput.value) || 0;
    //
    //     const maxDiscount = subtotal * 0.5;
    //
    //
    //     if (discount > maxDiscount) {
    //         discount = maxDiscount;
    //         discountInput.value = maxDiscount.toFixed(2);
    //         discountInput.classList.add("is-invalid");
    //     } else {
    //         discountInput.classList.remove("is-invalid");
    //     }
    //
    //     document.getElementById('subtotal').innerText = subtotal.toFixed(2);
    //     document.getElementById('grandTotal').innerText = (subtotal - discount).toFixed(2);
    //
    //     // const subtotal = parseFloat(document.getElementById("subtotal").innerText) || 0;
    //     // const discount = parseFloat(document.getElementById("discount").value) || 0;
    //
    //     if (discount > subtotal * 0.5) {
    //         alert("Discount cannot exceed 50% of subtotal");
    //         document.getElementById("discount").classList.add("is-invalid");
    //         e.preventDefault();
    //         return;
    //     }
    //
    // }

    // Run calculation once on load
    window.onload = calculate;
</script>
</body>
</html>