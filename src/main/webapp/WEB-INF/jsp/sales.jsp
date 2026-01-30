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
    </style>
</head>

<body class="bg-soft">
<div class="app-shell">
    <%@ include file="/WEB-INF/fragments/sidebar.html" %>

    <div class="container py-5">
        <form action="/salesinvoice/add" method="post">

            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="h4"><i class="fa-solid fa-file-invoice-dollar me-2"></i>New Sales Invoice</h2>
                <button type="submit" class="btn btn-primary">
                    <i class="fa-solid fa-check me-1"></i> Finalize Sale
                </button>
            </div>

            <div class="row g-4">

                <!-- CUSTOMER -->
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
                                <input type="text" class="form-control" name="customer.name" id="custName">
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Email</label>
                                <input type="email" class="form-control" name="customer.email" id="custEmail">
                            </div>

                            <div id="customerStatus" class="small"></div>
                        </div>
                    </div>
                </div>

                <!-- ITEMS -->
                <div class="col-md-8">
                    <div class="card invoice-card">
                        <div class="card-header bg-white d-flex justify-content-between align-items-center">
                            <span class="fw-bold">Billing Items</span>
                            <button type="button" class="btn btn-sm btn-outline-success" onclick="addRow()">
                                <i class="fa-solid fa-plus"></i> Add Item
                            </button>
                        </div>

                        <div class="card-body">
                            <table class="table align-middle" id="itemsTable">
                                <thead>
                                <tr class="text-muted small">
                                    <th style="width:40%">Variant</th>
                                    <th>Qty</th>
                                    <th>Price</th>
                                    <th>Total</th>
                                    <th></th>
                                </tr>
                                </thead>
                                <tbody>

                                <!-- FIRST ROW -->
                                <tr class="item-row">
                                    <td>
                                        <select class="form-select" name="items[0].inventory.variant.variantId">
                                            <option value="">Select Variant</option>
                                            <c:forEach items="${inventory}" var="i">
                                                <option value="${i.variant.variantId}">${i.variant.variantName}</option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                    <td><input type="number" class="form-control qty" name="items[0].quantity" value="1" min="1" oninput="calculate()"></td>
                                    <td><input type="number" class="form-control price" name="items[0].unitPrice" step="0.01" oninput="calculate()"></td>
                                    <td><span class="row-total fw-bold">0.00</span></td>
                                    <td><button type="button" class="btn btn-link text-danger" onclick="removeRow(this)"><i class="fa-solid fa-trash"></i></button></td>
                                </tr>

                                </tbody>
                            </table>
                        </div>

                        <div class="card-footer bg-light p-4">
                            <div class="row">
                                <div class="col-md-7">
                                    <label class="form-label">Internal Notes</label>
                                    <textarea class="form-control" rows="3"></textarea>
                                </div>
                                <div class="col-md-5">
                                    <div class="d-flex justify-content-between mb-2">
                                        <span>Subtotal</span>
                                        <span id="subtotal">0.00</span>
                                    </div>
                                    <div class="d-flex justify-content-between mb-2">
                                        <span>Discount</span>
                                        <input type="number" name="discountAmount" id="discount" class="form-control form-control-sm w-25" value="0" oninput="calculate()">
                                    </div>
                                    <hr>
                                    <div class="d-flex justify-content-between">
                                        <span class="h5">Grand Total</span>
                                        <span class="h5 text-primary" id="grandTotal">0.00</span>
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

<!-- PASS VARIANTS TO JS -->
<script>
    const variants = [
        <c:forEach items="${inventory}" var="i" varStatus="s">
            { id: "${i.variant.variantId}", name: "${i.variant.variantName}" }${!s.last ? ',' : ''}
        </c:forEach>
    ];
</script>

<script>

    function fetchCustomer() {
        const mobile = document.getElementById('custMobile').value.trim();
        const statusDiv = document.getElementById('customerStatus');

        if (mobile.length < 10) {
            statusDiv.innerHTML = '<span class="text-danger">Enter a valid mobile number</span>';
            return;
        }

        fetch('/customer/api/search?mobile=' + mobile)
            .then(response => {
                if (response.status === 204) return null;
                if (!response.ok) throw new Error("Server error");
                return response.json();
            })
            .then(data => {
                if (data) {
                    document.getElementById('custName').value = data.name || '';
                    document.getElementById('custEmail').value = data.email || '';
                    statusDiv.innerHTML =
                        '<span class="text-success"><i class="fa-solid fa-check-circle"></i> Existing customer loaded</span>';
                } else {
                    document.getElementById('custName').value = '';
                    document.getElementById('custEmail').value = '';
                    statusDiv.innerHTML =
                        '<span class="text-primary"><i class="fa-solid fa-info-circle"></i> New customer — enter details</span>';
                }
            })
            .catch(() => {
                statusDiv.innerHTML = '<span class="text-danger">Customer lookup failed</span>';
            });
    }

    let rowCount = 1;

    function addRow() {
        const table = document.getElementById('itemsTable').getElementsByTagName('tbody')[0];
        const newRow = table.insertRow();
        newRow.className = "item-row";

        let options = '<option value="">Select Variant</option>';
        variants.forEach(v => {
            options += `<option value="${i.variant.id}">${i.variant.name}</option>`;
        });

        newRow.innerHTML = `
            <td>
                <select class="form-select" name="items[${rowCount}].inventory.variant.variantId">
                    ${options}
                </select>
            </td>
            <td><input type="number" class="form-control qty" name="items[${rowCount}].quantity" value="1" min="1" oninput="calculate()"></td>
            <td><input type="number" class="form-control price" name="items[${rowCount}].unitPrice" step="0.01" oninput="calculate()"></td>
            <td><span class="row-total fw-bold">0.00</span></td>
            <td><button type="button" class="btn btn-link text-danger" onclick="removeRow(this)"><i class="fa-solid fa-trash"></i></button></td>
        `;
        rowCount++;
    }

    function removeRow(btn) {
        btn.closest('tr').remove();
        calculate();
    }

    function calculate() {
        let subtotal = 0;
        document.querySelectorAll('.item-row').forEach(row => {
            const qty = row.querySelector('.qty').value || 0;
            const price = row.querySelector('.price').value || 0;
            const total = qty * price;
            row.querySelector('.row-total').innerText = total.toFixed(2);
            subtotal += total;
        });

        const discount = document.getElementById('discount').value || 0;
        document.getElementById('subtotal').innerText = subtotal.toFixed(2);
        document.getElementById('grandTotal').innerText = (subtotal - discount).toFixed(2);
    }
</script>

</body>
</html>
