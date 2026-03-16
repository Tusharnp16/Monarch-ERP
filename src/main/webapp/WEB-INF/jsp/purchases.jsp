<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Monarch ERP | Purchases</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <style>
        :root { --sidebar-width: 260px; --bg-soft: #f8f9fa; }
        body { background-color: var(--bg-soft); font-family: 'Inter', sans-serif; }
        .app-shell { display: grid; grid-template-columns: var(--sidebar-width) 1fr; min-height: 100vh; }
        .topbar { background: #fff; border-bottom: 1px solid #e9ecef; padding: .75rem 1rem; position: sticky; top: 0; z-index: 1000; }
        .bill-link { cursor: pointer; color: #0d6efd; font-weight: 700; text-decoration: none; display: flex; align-items: center; }
        .detail-row { background-color: #fcfcfc; display: none; }
        .inner-table-wrapper { background: white; border-radius: 8px; border: 1px solid #dee2e6; margin: 10px 0; }
        .bill-badge { background: #fff4e6; color: #d9480f; border: 1px solid #ffd8a8; font-weight: 600; }
        .input-readonly { background-color: #e9ecef !important; font-weight: 600; }
        /* Removes spin-buttons from number inputs */
        input::-webkit-outer-spin-button,
        input::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }
        input[type=number] {
            -moz-appearance: textfield;
        }
        /* Ensure readonly text is visible and centered */
        .input-readonly {
            background-color: #e9ecef !important;
            font-weight: 600;
            padding-left: 5px !important;
            padding-right: 5px !important;
            text-overflow: ellipsis;
        }

        /* Adjust table to handle width better */
        .table-responsive { overflow-x: auto; }
    </style>
</head>
<body>

<div class="app-shell">
    <%@ include file="/WEB-INF/fragments/sidebar.html" %>

    <main class="main w-100">
        <div class="topbar d-flex justify-content-between align-items-center">
            <div>
                <h1 class="h5 mb-0">Purchases</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0" style="font-size: 0.75rem;">
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
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white py-3">
                    <h6 class="mb-0"><i class="fa-solid fa-file-invoice me-2 text-primary"></i>Recent Invoices</h6>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table align-middle mb-0">
                            <thead class="table-light text-uppercase small" style="letter-spacing: 0.5px;">
                                <tr>
                                    <th class="ps-3">Bill No</th>
                                    <th>Supplier</th>
                                    <th>Date</th>
                                    <th>Items</th>
                                    <th>Total Amount</th>
                                    <th class="text-end pe-3">Actions</th>
                                </tr>
                            </thead>
                            <tbody id="purchaseTableBody">
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
        <form class="modal-content" id="purchaseForm">
            <div class="modal-header bg-light">
                <h5 class="modal-title">New Purchase Invoice <span id="taxTypeBadge" class="badge bg-secondary ms-2">Select Supplier</span></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="row g-3 mb-4">
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Bill Number</label>
                        <input type="hidden" id="hiddenGstIn">
                        <input type="text" class="form-control" id="billNo" placeholder="BILL/2026/001" readonly>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Supplier</label>
                        <select class="form-select" id="supplierSelect" required>
                            <option value="">Loading Suppliers...</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Grand Total Amount</label>
                        <div class="input-group">
                            <span class="input-group-text bg-success text-white">₹</span>
                            <input type="number" step="0.01" class="form-control fw-bold input-readonly" id="totalBillAmount" readonly>
                        </div>
                    </div>
                </div>

                <hr>
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h6 class="mb-0 text-uppercase small fw-bold text-secondary">Purchase Items</h6>
                    <button type="button" class="btn btn-sm btn-outline-success" id="addRowBtn"><i class="fas fa-plus me-1"></i> Add Item</button>
                </div>

                <div class="table-responsive">
                    <table class="table table-bordered align-middle">
                        <thead class="table-light small">
                            <tr>
                                <th style="width: 25%;">Variant</th>
                                <th style="width: 8%;">Qty</th>
                                <th style="width: 12%;">Price (Ex)</th>
                                <th style="width: 12%;">Tax</th>
                                <th style="width: 12%;">Landing (Inc)</th>
                                <th style="width: 18%;">Net Total</th> <th style="width: 13%;">Expiry</th>
                                <th style="width: 5%;"></th>
                            </tr>
                        </thead>
                        <tbody id="purchaseItemsContainer">
                            <tr class="item-row">
                                <td><select class="form-select form-select-sm variant-select" required></select></td>
                                <td><input type="number" class="form-control form-control-sm qty-input" value="1" min="0" oninput="if(this.value<0)this.value=0" required></td>
                                <td><input type="number" step="0.01" class="form-control form-control-sm price-input" placeholder="0.00" min="0" oninput="if(this.value<0)this.value=0" required></td>
                                 <td><input type="number" class="form-control form-control-sm tax-amount-input input-readonly" readonly></td>
                                <td><input type="number" step="0.01" class="form-control form-control-sm landing-input input-readonly" readonly></td>
                                <td><input type="number" step="0.01" class="form-control form-control-sm net-input input-readonly text-primary" readonly></td>
                                <td><input type="date" class="form-control form-control-sm expire-input"></td>
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
                <button type="submit" class="btn btn-primary px-4">Save Invoice</button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const IGST_RATE = 0.18;
    let variantsData = [];

     fetch('/api/purchase/next-number')
         .then(res => res.text())
         .then(no => {
             const billInput = document.getElementById('billNo');
             if(billInput) billInput.value = no;
         });



    document.addEventListener('DOMContentLoaded', () => {
        fetchPurchases();
        loadMetadata();

        const today = new Date().toISOString().split('T')[0];
            document.querySelectorAll('.expire-input').forEach(input => input.setAttribute('min', today));
    });

    function fetchPurchases() {
        fetch('/api/purchase')
            .then(res => res.json())
            .then(response => {

                if (response.success && response.data) {
                    renderTable(response.data);
                } else {
                    document.getElementById('purchaseTableBody').innerHTML =
                        '<tr><td colspan="6" class="text-center text-muted">No purchases found.</td></tr>';
                }
            })
            .catch(err => console.error("Error fetching purchases:", err));
    }

    function renderTable(purchases) {
        const tbody = document.getElementById('purchaseTableBody');
        tbody.innerHTML = purchases.map(p => {
            const supplierName = p.supplierName || 'Unknown';
            const supplierMobile = p.supplierNumber || '-';
            const total = p.totalAmount || 0;
            const createdDate = p.date ? p.date.split('T')[0] : '-';

            return `
                <tr class="main-row">
                    <td class="ps-3">
                        <a class="bill-link" onclick="toggleDetails(${p.purchaseId}, this)">
                            <i class="fa-solid fa-caret-right me-2 text-muted"></i>
                            <span class="badge bill-badge px-2 py-1">${p.billNo || 'N/A'}</span>
                        </a>
                    </td>
                    <td>
                        <div class="fw-bold text-dark">${supplierName}</div>
                        <div class="text-muted small">${supplierMobile}</div>
                    </td>
                    <td><span class="text-muted">${createdDate}</span></td>
                    <td><span class="badge rounded-pill bg-light text-dark border">${p.itemCount || 0} Items</span></td>
                    <td class="fw-bold text-primary">₹ ${total.toLocaleString('en-IN')}</td>
                    <td class="text-end pe-3">
                        <button class="btn btn-sm btn-light border"><i class="fas fa-print"></i></button>
                    </td>
                </tr>
                <tr id="details-${p.purchaseId}" class="detail-row">
                    <td colspan="6" class="px-4 py-3 bg-light">
                        <div class="inner-table-wrapper p-3">
                            <h6 class="small fw-bold text-uppercase text-secondary mb-3">Itemized Breakdown</h6>
                            <table class="table table-sm table-hover mb-0">
                                <thead class="table-light">
                                    <tr class="small text-muted">
                                        <th>Product/Variant</th>
                                        <th class="text-center">Qty</th>
                                        <th>Unit Price</th>
                                        <th>Tax Amount</th>
                                        <th>Landing Cost</th>
                                        <th>Net Amount</th>
                                        <th class="text-end">Expire Date</th>
                                    </tr>
                                </thead>
                                <tbody id="items-body-${p.purchaseId}">
                                    <tr><td colspan="7" class="text-center py-3"><div class="spinner-border spinner-border-sm text-primary"></div> Loading...</td></tr>
                                </tbody>
                            </table>
                        </div>
                    </td>
                </tr>
            `;
        }).join('');
    }

    async function toggleDetails(purchaseId, element) {
        const row = document.getElementById(`details-${purchaseId}`);
        const itemsBody = document.getElementById(`items-body-${purchaseId}`);
        const icon = element.querySelector('i');
        const isOpen = row.style.display === "table-row";

        // 1. Toggle visibility
        row.style.display = isOpen ? "none" : "table-row";
        icon.classList.toggle('fa-caret-right', isOpen);
        icon.classList.toggle('fa-caret-down', !isOpen);


        if (!isOpen && itemsBody.getAttribute('data-loaded') !== 'true') {
            try {

                const res = await fetch(`/api/purchaseitem/pr/${purchaseId}`);
                const response = await res.json();

                if (response.success && response.data) {
                    renderItems(purchaseId, response.data);
                    itemsBody.setAttribute('data-loaded', 'true');
                } else {
                    itemsBody.innerHTML = '<tr><td colspan="7" class="text-center text-danger">Failed to load items.</td></tr>';
                }
            } catch (err) {
                console.error("Error fetching details:", err);
                itemsBody.innerHTML = '<tr><td colspan="7" class="text-center text-danger">Error loading items.</td></tr>';
            }
        }
    }

    function renderItems(purchaseId, items) {
        const itemsBody = document.getElementById(`items-body-${purchaseId}`);
        if (items.length === 0) {
            itemsBody.innerHTML = '<tr><td colspan="7" class="text-center">No items found.</td></tr>';
            return;
        }

        itemsBody.innerHTML = items.map(item => `
            <tr>
                <td>${item.productDisplay} <span class="text-muted small"> - ${item.variantDisplay}</span></td>
                <td class="text-center">${item.qty || 0}</td>
                <td>₹ ${item.unitPrice?.toLocaleString('en-IN') || 0}</td>
                <td>₹ ${item.taxAmount?.toLocaleString('en-IN') || 0}</td>
                <td>₹ ${item.landingCost?.toLocaleString('en-IN') || 0}</td>
                <td class="fw-bold text-dark">₹ ${item.netAmount?.toLocaleString('en-IN') || 0}</td>
                <td class="text-end text-muted small">${item.expireDate || '-'}</td>
            </tr>
        `).join('');
    }

    async function loadMetadata() {
        try {
            const [supRes, varRes] = await Promise.all([
                fetch('/api/contacts/lookup'),
                fetch('/api/variants/lookup'),
            ]);

            const suppliers = await supRes.json();
            const variants = await varRes.json();

            variantsData = variants.data || [];

            const sSelect = document.getElementById('supplierSelect');
            const supplierList = suppliers.data || [];

            sSelect.innerHTML = '<option value="">Choose Supplier...</option>' +
                supplierList.map(s => `<option value="${s.contactId}" data-gst="${s.gstIn}">${s.name} (${s.gstIn == 24 ? "Inter" : "Outer"})</option>`).join('');

            const firstVariantSelect = document.querySelector('.variant-select');
            if (firstVariantSelect) populateVariantDropdown(firstVariantSelect);

        } catch (err) {
            console.error("Metadata load failed:", err);
        }
    }

    function populateVariantDropdown(select) {
        // SAFETY: Check if variantsData is an array
        if (!Array.isArray(variantsData)) {
            console.error("variantsData is not an array:", variantsData);
            return;
        }

        select.innerHTML = variantsData.map(v => {
            const pName = v.product ? v.product.productName : 'Unknown';
            return `<option value="${v.variantId}">${pName} [${v.variantName} (${v.colour} / ${v.size})]</option>`;
        }).join('');
    }

    document.getElementById('addRowBtn').addEventListener('click', () => {
        const container = document.getElementById('purchaseItemsContainer');
        const newRow = document.querySelector('.item-row').cloneNode(true);

        const today = new Date().toISOString().split('T')[0];
            newRow.querySelectorAll('input').forEach(i => {
                i.value = i.classList.contains('qty-input') ? "1" : "";
                if(i.classList.contains('expire-input')) i.setAttribute('min', today);
            });

        newRow.querySelectorAll('input').forEach(i => i.value = i.classList.contains('qty-input') ? "1" : "");

        // Populate the dropdown in the new row
        const newSelect = newRow.querySelector('.variant-select');
        populateVariantDropdown(newSelect);

        container.appendChild(newRow);
        calculateFinalTotals();
    });

    document.getElementById('supplierSelect').addEventListener('change', function() {
        const gst = this.options[this.selectedIndex].getAttribute('data-gst') || "";
        document.getElementById('hiddenGstIn').value = gst;
        const badge = document.getElementById('taxTypeBadge');
        if (gst) {
            badge.innerText = gst == 24 ? "InterState (CGST + SGST)" : "OuterState (IGST)";
            badge.className = `badge ms-2 ${gst == 24 ? 'bg-success' : 'bg-primary'}`;
        }
    });

    document.addEventListener('input', e => {
        if (e.target.classList.contains('qty-input') || e.target.classList.contains('price-input')) {
            calculateFinalTotals();
        }
    });

    function calculateFinalTotals() {
        let billTotal = 0;
        document.querySelectorAll('.item-row').forEach(row => {
            const qty = parseFloat(row.querySelector('.qty-input').value) || 0;
            const basePrice = parseFloat(row.querySelector('.price-input').value) || 0;
            const tax = basePrice * IGST_RATE * qty;
            const landing = basePrice + tax;
            const net = landing * qty;

            row.querySelector('.tax-amount-input').value = tax.toFixed(2);
            row.querySelector('.landing-input').value = landing.toFixed(2);
            row.querySelector('.net-input').value = net.toFixed(2);
            billTotal += net;
        });
        document.getElementById('totalBillAmount').value = billTotal.toFixed(2);
    }

    document.getElementById('purchaseForm').onsubmit = async (e) => {
        e.preventDefault();
        const items = Array.from(document.querySelectorAll('.item-row')).map(row => ({
            variant: { variantId: row.querySelector('.variant-select').value },
            qty: parseInt(row.querySelector('.qty-input').value),
            price: { price: parseFloat(row.querySelector('.price-input').value) },
            taxAmount: { price: parseFloat(row.querySelector('.tax-amount-input').value) },
            landingCost: { price: parseFloat(row.querySelector('.landing-input').value) },
            netAmount: { price: parseFloat(row.querySelector('.net-input').value) },
            expireDate: row.querySelector('.expire-input').value || null
        }));

        const payload = {
            billNo: document.getElementById('billNo').value,
            supplier: { contactId: document.getElementById('supplierSelect').value },
            totalAmount: { price: parseFloat(document.getElementById('totalBillAmount').value) },
            items: items
        };

        try {
            const res = await fetch(`/api/purchase/add?gstIn=${document.getElementById('hiddenGstIn').value}`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            });

            const result = await res.json();
            if (result.success) {
                window.location.reload();
            } else {
                alert("Save failed: " + result.message);
            }
        } catch (err) {
            console.error("Submission error:", err);
            alert("Network error while saving.");
        }
    };


</script>
</body>
</html>