<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Monarch ERP | Sales Invoice</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" />

    <style>
        .invoice-card { border: none; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); border-top: 4px solid #0d6efd; }
        .item-row { border-bottom: 1px solid #f1f1f1; padding: 10px 0; }
        .bg-soft { background-color: #f8f9fa; }
        .stock-label { font-size: 0.75rem; display: block; margin-top: 4px; min-height: 1rem; }
        .low-stock { color: #dc3545; font-weight: 600; }
        body { background-color: #f4f6f9; }
        #grandTotal { font-size: 1.4rem; color: #0d6efd; font-weight: bold; }
        #subtotal { font-weight: 600; }
    </style>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-soft">
<div class="app-shell">
    <%@ include file="/WEB-INF/fragments/sidebar.html" %>

    <div class="container py-5">
        <form action="/api/sales-invoices" method="post" id="salesForm">
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
                                    <input type="text" class="form-control" maxlength="10" name="customer.mobile" id="custMobile" required>
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
                                        <select class="form-select variant-select" name="items[0].variant.variantId" required>
                                            <option value="">Search Inventory...</option>
                                        </select>
                                    </td>
                                    <td>
                                        <input type="number" class="form-control qty" name="items[0].quantity" value="1" min="1" oninput="validateStock(this)" required>
                                        <small class="stock-label text-muted"></small>
                                    </td>
                                    <td><input type="number" class="form-control mrp" step="0.01" readonly required></td>
                                    <td><input type="number" class="form-control price" name="items[0].unitPrice" step="0.01" oninput="calculate()" readonly required></td>
                                    <td><span class="row-total fw-bold">0.00</span></td>
                                    <td>
                                        <button type="button" class="btn btn-link text-danger" onclick="removeRow(this)"><i class="fa-solid fa-trash"></i></button>
                                    </td>
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
                                        <span id="grandTotal">0.00</span>
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
                    <tr><th>Product</th><th>Variant</th><th>Specs</th><th>Sold</th><th>Total Amount</th></tr>
                </thead>
                <tbody>
                <c:forEach items="${topSellers}" var="item">
                    <tr>
                        <td>${item[0]}</td><td>${item[1]}</td>
                        <td><span class="badge bg-secondary">${item[2]}</span> <span class="badge bg-info">${item[3]}</span></td>
                        <td class="fw-bold text-primary">${item[4]}</td><td class="fw-bold text-primary">${item[5]}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
<div class="toast-container position-fixed bottom-0 end-0 p-3">
  <div id="liveToast" class="toast hide" role="alert" aria-live="assertive" aria-atomic="true">
    <div class="toast-header">
      <strong class="me-auto" id="toastTitle">System Notification</strong>
      <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
    </div>
    <div class="toast-body" id="toastMessage"></div>
  </div>
</div>

<script>
    // Configuration
    const MAX_DISCOUNT_PERCENT = 0.15; // Set your default limit here

    $(document).ready(function() {
        initializeSelect2($('.variant-select'));
        fetchInvoiceNumber();
        calculate();
    });

    function initializeSelect2(element) {
        element.select2({
            theme: 'bootstrap-5',
            placeholder: "Search Inventory...",
            allowClear: true,
            ajax: {
                url: "/api/inventory/search",
                dataType: "json",
                delay: 250,
                data: params => ({ name: params.term }),
                processResults: function(response) {
                    return {
                        results: (response.data || []).map(function(item) {
                            var v = item.variant;
                            return {
                                id: v.variantId,
                                text: v.variantName + " (" + v.colour + " / " + v.size + ")",
                                fullData: item
                            };
                        })
                    };
                }
            }
        });

        element.on("select2:select", function (e) {
            var item = e.params.data.fullData;
            var row = $(this).closest("tr");

            var mrp = (item.variant.mrp) ? item.variant.mrp.price : 0;
            var price = (item.variant.sellingPrice) ? item.variant.sellingPrice.price : 0;
            var stock = item.availableQuantity || 0;

            row.find(".mrp").val(mrp.toFixed(2));
            row.find(".price").val(price.toFixed(2));
            row.find(".qty").attr("max", stock);

            var stockLabel = row.find(".stock-label");
            stockLabel.text("Stock: " + stock);
            if (stock < 5) stockLabel.addClass('low-stock');
            else stockLabel.removeClass('low-stock');

            calculate();
        });
    }

    function addRow() {
        var tbody = $('#itemsTable tbody');
        var count = tbody.find('tr').length;
        var newRow = tbody.find('tr:first').clone();

        // Destroy and reset Select2 for the new row
        newRow.find('.select2-container').remove();
        newRow.find('select').removeClass('select2-hidden-accessible').removeAttr('data-select2-id').empty().append('<option value="">Search Inventory...</option>');

        newRow.find('input').val('').removeClass('is-invalid');
        newRow.find('.qty').val(1);
        newRow.find('.row-total').text('0.00');
        newRow.find('.stock-label').text('');

        newRow.find('select, input').each(function() {
            var name = $(this).attr('name');
            if(name) $(this).attr('name', name.replace(/\[\d+\]/, "[" + count + "]"));
        });

        tbody.append(newRow);
        initializeSelect2(newRow.find('.variant-select'));
    }

    function removeRow(btn) {
        if ($('#itemsTable tbody tr').length > 1) {
            $(btn).closest('tr').remove();
            calculate();
        }
    }

    function fetchCustomer() {
        const mobile = $('#custMobile').val().trim();
        if (mobile.length !== 10) return;

        fetch('/api/customers/search?mobile=' + mobile)
            .then(res => res.status === 204 ? null : res.json())
            .then(data => {
                if (data && data.success) {
                    $('#custName').val(data.data.name);
                    $('#custEmail').val(data.data.email);
                    $('#customerStatus').html('<span class="text-success small">Customer Found</span>');
                } else {
                    $('#custName').val('');
                    $('#custEmail').val('');
                    $('#customerStatus').html('<span class="text-primary small">New Customer</span>');
                }
            });
    }

    function fetchInvoiceNumber() {
        fetch('/api/sales-invoices/next-number')
            .then(res => res.json())
            .then(res => $('#invoiceNumber').val(res.data));
    }

    function validateStock(input) {
        var max = parseInt($(input).attr("max"));
        if (max && parseInt($(input).val()) > max) {
            alert("Insufficient Stock! Available: " + max);
            $(input).val(max);
        }
        calculate();
    }

    function calculate() {
        var subtotal = 0;
        $('.item-row').each(function() {
            var q = parseFloat($(this).find('.qty').val()) || 0;
            var p = parseFloat($(this).find('.price').val()) || 0;
            var total = q * p;
            $(this).find('.row-total').text(total.toFixed(2));
            subtotal += total;
        });

        var disc = parseFloat($('#discount').val()) || 0;
        var maxAllowed = subtotal * MAX_DISCOUNT_PERCENT;

        if (disc > maxAllowed) {
            showNotification("Error", "Maximum allowed discount is 15%", "bg-danger text-white");
            disc = maxAllowed;
            $('#discount').val(disc.toFixed(2)).addClass("is-invalid");
        } else {
            $('#discount').removeClass("is-invalid");
        }

        $('#subtotal').text(subtotal.toFixed(2));
        $('#grandTotal').text((subtotal - disc).toFixed(2));
    }

    $('#custMobile').on('input', function() {
        if (this.value.length === 10) fetchCustomer();
    });

    // Add this submission handler
    document.getElementById("salesForm").addEventListener("submit", function (e) {
        e.preventDefault(); // Stop standard form submission

        // 1. Validation
        const rows = document.querySelectorAll(".item-row");
        if (rows.length === 0) {
            showNotification("Error","Provide detailes", "bg-danger text-white");
            return;
        }

        // 2. Construct JSON object based on your SalesInvoice.java model
        const invoiceData = {
            invoiceNumber: document.getElementById("invoiceNumber").value,
            customer: {
                name: document.getElementById("custName").value,
                mobile: document.getElementById("custMobile").value,
                email: document.getElementById("custEmail").value
            },
            discountAmount: parseFloat(document.getElementById("discount").value) || 0,
            items: []
        };

        // 3. Map items to match SalesItem model
        rows.forEach(row => {
            const variantId = row.querySelector(".variant-select").value;
            if (variantId) {
                invoiceData.items.push({
                    variant: { variantId: parseInt(variantId) },
                    quantity: parseInt(row.querySelector(".qty").value),
                    unitPrice: parseFloat(row.querySelector(".price").value)
                });
            }
        });


        fetch('/api/sales-invoices', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(invoiceData)
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
               showNotification("Success", "Invoice #" + data.data.invoiceNumber + " saved successfully!", "bg-success text-white");
                window.location.reload();
            } else {
                alert("Error: " + data.message);
            }
        })
        .catch(err => {

            showNotification("Error", "Submission Error", "bg-danger text-white");
        });
    });

     function showNotification(title, message, bgClass) {
            const toastEl = document.getElementById('liveToast');
            const toast = new bootstrap.Toast(toastEl);

            document.getElementById('toastTitle').innerText = title;
            document.getElementById('toastMessage').innerText = message;
            toastEl.className = `toast ${bgClass}`; // Set color

            toast.show();
     }

     function resetButton(btn, text) {
                btn.disabled = false;
                btn.innerHTML = text;
    }



    $('#custMobile').on('input', function() {
        if (this.value.length === 10) fetchCustomer();
    });


</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>