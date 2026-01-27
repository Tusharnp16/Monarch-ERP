<%--
  Monarch ERP | Purchase Invoices
  Final Version: Integrated IGST (18%) Auto-Calculation
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Monarch ERP | Purchase Invoices</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        :root { --sidebar-width: 260px; --bg-soft: #f8f9fa; --card-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075); }
        html, body { height: 100%; }
        body { background-color: var(--bg-soft); font-family: 'Inter', sans-serif; }
        .app-shell { display: grid; grid-template-columns: var(--sidebar-width) 1fr; min-height: 100vh; }

        /* Sidebar & Layout */
        .sidebar { background: #212529; color: #fff; position: sticky; top: 0; height: 100vh; padding: 1rem; }
        .main { display: flex; flex-direction: column; }
        .topbar { position: sticky; top: 0; z-index: 1030; background: #fff; border-bottom: 1px solid #e9ecef; padding: .75rem 1rem; }
        .card { border: none; box-shadow: var(--card-shadow); border-radius: 0.75rem; }

        /* Table Design */
        .table thead { background-color: #f1f3f5; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.5px; }
        .bill-badge { background: #fff4e6; color: #d9480f; border: 1px solid #ffd8a8; font-weight: 600; }
        .item-row:hover { background-color: #fcfcfc; }

        /* Form Styling */
        .input-readonly { background-color: #e9ecef !important; font-weight: 600; }
    </style>
</head>
<body>

<div class="app-shell">
    <%@ include file="/WEB-INF/fragments/sidebar.html" %>

    <main class="main">
        <div class="topbar d-flex justify-content-between align-items-center">
            <div>
                <h1 class="h5 mb-0">Purchase Invoices</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0" style="--bs-breadcrumb-divider: '>'; font-size: 0.75rem;">
                        <li class="breadcrumb-item text-primary">Procurement</li>
                        <li class="breadcrumb-item active">Invoices</li>
                    </ol>
                </nav>
            </div>
            <button class="btn btn-primary shadow-sm" data-bs-toggle="modal" data-bs-target="#createPurchaseModal">
                <i class="fas fa-plus-circle me-1"></i> Create Bill
            </button>
        </div>

        <div class="container-fluid py-4">
            <div class="row g-3 mb-4">
                <div class="col-md-3">
                    <div class="card p-3 border-start border-primary border-4">
                        <div class="text-muted small">Total Purchases</div>
                        <div class="h4 mb-0">${purchases.size()}</div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-header bg-white py-3">
                    <h6 class="mb-0"><i class="fa-solid fa-file-invoice me-2 text-primary"></i>Recent Invoices</h6>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                                <tr>
                                    <th class="ps-3">Bill No.</th>
                                    <th>Supplier</th>
                                    <th>Date</th>
                                    <th>Items</th>
                                    <th>Total Amount</th>
                                    <th class="text-end pe-3">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${purchases}" var="p">
                                    <tr>
                                        <td class="ps-3"><span class="badge bill-badge px-2 py-1">${p.billNo}</span></td>
                                        <td>
                                            <div class="fw-bold text-dark">${p.supplier.name}</div>
                                            <div class="text-muted small">${p.supplier.mobileno}</div>
                                        </td>
                                        <td><span class="text-muted">${p.createdDate}</span></td>
                                        <td><span class="badge rounded-pill bg-light text-dark border">${p.items.size()} Items</span></td>
                                        <td class="fw-bold text-primary">₹ ${p.totalAmount.price}</td>
                                        <td class="text-end pe-3">
                                            <button class="btn btn-sm btn-light border"><i class="fas fa-print"></i></button>
                                            <button class="btn btn-sm btn-outline-primary ms-1"><i class="fas fa-eye"></i></button>
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

<div class="modal fade" id="createPurchaseModal" tabindex="-1">
    <div class="modal-dialog modal-xl modal-dialog-centered">
        <form class="modal-content" method="post" action="/purchase/add">
            <div class="modal-header bg-light">
                <h5 class="modal-title">
                    New Purchase Invoice
                    <span id="taxTypeBadge" class="badge bg-secondary ms-2" >Select Supplier</span>
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="row g-3 mb-4">
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Bill Number</label>
                        <input type="text" class="form-control" name="billNo" placeholder="BILL/2026/001" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Supplier</label>
                        <select class="form-select" name="supplier.contactId" id="supplierSelect" required>
                            <option value="">Choose Supplier...</option>
                            <c:forEach items="${suppliers}" var="s">
                                <option value="${s.contactId}" data-gst="${s.gstIn}">${s.name} ${s.gstIn == 24 ? "(CGST + SGST)" : "(IGST)"} </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Grand Total Amount</label>
                        <div class="input-group">
                            <span class="input-group-text bg-success text-white">₹</span>
                            <input type="number" step="0.01" class="form-control fw-bold input-readonly" name="totalAmount.price" id="totalBillAmount" readonly>
                        </div>
                    </div>
                </div>

                <hr>
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h6 class="mb-0 text-uppercase small fw-bold text-secondary">Itemized Breakdown</h6>

                    <button type="button" class="btn btn-sm btn-outline-success" id="addRowBtn">
                        <i class="fas fa-plus me-1"></i> Add Item
                    </button>
                </div>

                <div class="table-responsive">
                    <table class="table table-bordered align-middle">
                        <thead class="table-light">
                            <tr class="small text-center">
                                <th style="width: 30%;">Variant</th>
                                <th style="width: 10%;">Qty</th>
                                <th style="width: 15%;">Unit Price (Ex)</th>
                                <th style="width: 15%;">Landing Cost (Inc)</th>
                                <th style="width: 15%;">Net Total</th>
                                <th>Expiry</th>
                                <th style="width: 5%;"></th>
                            </tr>
                        </thead>
                        <tbody id="purchaseItemsContainer">
                            <tr class="item-row">
                                <td>
                                    <select class="form-select form-select-sm" name="items[0].variant.variantId" required>
                                        <c:forEach items="${variants}" var="v">
                                            <option value="${v.variantId}">${v.variantName} (${v.colour} / ${v.size})</option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <input type="hidden" name="gstIn" id="hiddenGstIn">
                                <td><input type="number" class="form-control form-control-sm qty-input" name="items[0].qty" value="1" min="1" required></td>
                                <td><input type="number" class="form-control form-control-sm price-input" name="items[0].price" placeholder="0.00" required></td>

                                <input type="hidden" name="items[0].taxAmount.price" class="tax-amount-input">

                                <td><input type="number" step="0.01" class="form-control form-control-sm landing-input input-readonly" name="items[0].landingCost.price" readonly></td>
                                <td><input type="number" step="0.01" class="form-control form-control-sm net-input input-readonly text-primary" name="items[0].netAmount.price" readonly></td>

                                <td><input type="date" class="form-control form-control-sm" name="items[0].expireDate"></td>
                                <td class="text-center">
                                    <button type="button" class="btn btn-sm text-danger remove-row"><i class="fas fa-times"></i></button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-link text-muted" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary px-4 shadow-sm"  data-bs-target="#createPurchaseModal">Process Purchase</button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const IGST_RATE = 0.18; // Fixed 18% for now
    let rowIdx = 1;

    document.getElementById('addRowBtn').addEventListener('click', function() {
        const container = document.getElementById('purchaseItemsContainer');
        const firstRow = document.querySelector('.item-row');
        const newRow = firstRow.cloneNode(true);

        // Update index for the new row
        newRow.querySelectorAll('input, select').forEach(input => {
            const oldName = input.getAttribute('name');
            if (oldName) {
                // Correctly replace items[0] with items[1], items[2], etc.
                const newName = oldName.replace(/items\[\d*\]/, `items[${rowIdx}]`);
                input.setAttribute('name', newName);
            }

            // Reset values for the new row
            if (input.classList.contains('qty-input')) {
                input.value = '1';
            } else if (input.tagName === 'SELECT') {
                input.selectedIndex = 0;
            } else {
                input.value = '';
            }
        });

        container.appendChild(newRow);
        rowIdx++;

        // Recalculate just in case
        calculateFinalTotals();
    });

    document.querySelectorAll('.price-input').forEach(input => {
        input.addEventListener('keydown', e => {
            if (["e", "E", "+", "-"].includes(e.key)) e.preventDefault();
        });
    });


    // --- Remove Row Logic ---
    document.addEventListener('click', function(e) {
        if(e.target.closest('.remove-row')) {
            const rows = document.querySelectorAll('.item-row');
            if(rows.length > 1) {
                e.target.closest('.item-row').remove();
                calculateFinalTotals();
            }
        }
    });

    document.getElementById('supplierSelect').addEventListener('change', function() {
        // Get the selected option
        const selectedOption = this.options[this.selectedIndex];
        const gstIn = selectedOption.getAttribute('data-gst') || "";
        const badge = document.getElementById('taxTypeBadge');

        document.getElementById('hiddenGstIn').value = gstIn;

        // Logic: Check if GSTIN starts with '24' (Gujarat)
        if (gstIn == 24) {
            badge.innerText = "IntraState (CGST + SGST)";
            badge.className = "badge bg-success ms-2";
        } else if (gstIn !== "") {
            badge.innerText = "InterState (IGST)";
            badge.className = "badge bg-primary ms-2";
        } else {
            badge.innerText = "Select Supplier";
            badge.className = "badge bg-secondary ms-2";
        }
    });

    // --- Calculation Logic ---
    document.addEventListener('input', function(e) {
        if(e.target.classList.contains('qty-input') || e.target.classList.contains('price-input')) {
            calculateFinalTotals();
        }
    });

    function calculateFinalTotals() {
        let billTotal = 0;

        document.querySelectorAll('.item-row').forEach(row => {
            const qty = parseFloat(row.querySelector('.qty-input').value) || 0;
            const basePrice = parseFloat(row.querySelector('.price-input').value) || 0;

            const taxPerUnit = basePrice * IGST_RATE;

            const landingCost = basePrice + taxPerUnit;

            const netAmount = landingCost * qty;

            row.querySelector('.tax-amount-input').value = taxPerUnit.toFixed(2);
            row.querySelector('.landing-input').value = landingCost.toFixed(2);
            row.querySelector('.net-input').value = netAmount.toFixed(2);

            billTotal += netAmount;
        });

        // Update the main Invoice Total field
        document.getElementById('totalBillAmount').value = billTotal.toFixed(2);

        document.querySelector('#createPurchaseModal form')
            .addEventListener('submit', calculateFinalTotals);

    }


</script>

</body>
</html>