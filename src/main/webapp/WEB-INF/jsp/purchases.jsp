<%--
  Created by IntelliJ IDEA.
  User: tusharparmar
  Date: 22-01-2026
  Time: 17:13
  To change this template use File | Settings | File Templates.
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

    /* Sidebar */
    .sidebar { background: #212529; color: #fff; position: sticky; top: 0; height: 100vh; padding: 1rem; }
    .sidebar .nav-link { color: #adb5bd; border-radius: .375rem; margin-bottom: 2px; }
    .sidebar .nav-link.active { color: #fff; background: rgba(255,255,255,0.08); }

    /* Content Area */
    .main { display: flex; flex-direction: column; }
    .topbar { position: sticky; top: 0; z-index: 1030; background: #fff; border-bottom: 1px solid #e9ecef; padding: .75rem 1rem; }
    .card { border: none; box-shadow: var(--card-shadow); border-radius: 0.75rem; }

    /* Table Styles */
    .table thead { background-color: #f1f3f5; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.5px; }
    .bill-badge { background: #fff4e6; color: #d9480f; border: 1px solid #ffd8a8; font-weight: 600; }

    /* Item Table in Modal */
    .item-row:hover { background-color: #f8f9fa; }
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
          <div class="card p-3">
            <div class="text-muted-small">Total Purchases</div>
            <div class="h4 mb-0">${purchases.size()}</div>
          </div>
        </div>
      </div>

      <div class="card">
        <div class="card-header bg-white py-3">
          <div class="d-flex align-items-center">
            <i class="fa-solid fa-list-ul me-2 text-primary"></i>
            <h6 class="mb-0">Recent Invoices</h6>
          </div>
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
                  <td class="ps-3">
                    <span class="badge bill-badge px-2 py-1">${p.billNo}</span>
                  </td>
                  <td>
                    <div class="fw-bold text-dark">${p.supplier.name}</div>
                    <div class="text-muted-small">${p.supplier.mobileno}</div>
                  </td>
                  <td><span class="text-muted">${p.createdDate}</span></td>
                  <td>
                                            <span class="badge rounded-pill bg-light text-dark border">
                                                ${p.items.size()} Items
                                            </span>
                  </td>
                  <td class="fw-bold text-primary">₹ ${p.totalAmount.price}</td>
                  <td class="text-end pe-3">
                    <button class="btn btn-sm btn-light border" title="Print Bill">
                      <i class="fas fa-print"></i>
                    </button>
                    <button class="btn btn-sm btn-outline-primary ms-1" title="View Details">
                      <i class="fas fa-chevron-right"></i>
                    </button>
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
        <h5 class="modal-title">New Purchase Bill</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <div class="row g-3 mb-4">
          <div class="col-md-4">
            <label class="form-label fw-semibold">Bill Number</label>
            <input type="text" class="form-control" name="billNo" placeholder="e.g. BILL-2024-001" required>
          </div>
          <div class="col-md-4">
            <label class="form-label fw-semibold">Supplier / Contact</label>
            <select class="form-select" name="supplier.contactId" required>
              <option value="">Select Supplier...</option>
              <c:forEach items="${suppliers}" var="s">
                <option value="${s.contactId}">${s.name}</option>
              </c:forEach>
            </select>
          </div>
          <div class="col-md-4">
            <label class="form-label fw-semibold">Total Invoice Amount</label>
            <div class="input-group">
              <span class="input-group-text bg-primary text-white">₹</span>
              <input type="number" step="0.01" class="form-control fw-bold" name="totalAmount.price" id="totalBillAmount" readonly>
            </div>
          </div>
        </div>

        <hr>
        <div class="d-flex justify-content-between align-items-center mb-3">
          <h6 class="mb-0 text-uppercase small fw-bold">Itemized List</h6>
          <button type="button" class="btn btn-sm btn-outline-success" id="addRowBtn">
            <i class="fas fa-plus me-1"></i> Add Row
          </button>
        </div>

        <div class="table-responsive">
          <table class="table table-bordered align-middle">
            <thead class="table-light">
            <tr class="small text-center">
              <th style="width: 40%;">Variant</th>
              <th>Quantity</th>
              <th>Unit Price</th>
              <th>Landing Cost</th>
              <th>Expiry</th>
              <th>Action</th>
            </tr>
            </thead>
            <tbody id="purchaseItemsContainer">
            <tr class="item-row">
              <td>
                <select class="form-select form-select-sm" name="items[0].variant.variantId" required>
                  <c:forEach items="${variants}" var="v">
                    <option value="${v.variantId}">${v.variantName }(${v.colour}) (${v.size})</option>
                  </c:forEach>s
                </select>
              </td>
              <td><input type="number" class="form-control form-control-sm qty-input" name="items[0].qty" value="1" required></td>
              <td><input type="number" step="0.01" class="form-control form-control-sm price-input" name="items[0].price.price" required></td>
              <td><input type="number" step="0.01" class="form-control form-control-sm" name="items[0].landingCost.price"></td>
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
        <button type="button" class="btn btn-link text-muted" data-bs-dismiss="modal">Discard</button>
        <button type="submit" class="btn btn-primary px-4">Save Invoice</button>
      </div>
    </form>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // Logic to add rows dynamically for PurchaseItems
  let rowIdx = 1;
  document.getElementById('addRowBtn').addEventListener('click', function() {
    const container = document.getElementById('purchaseItemsContainer');
    const newRow = document.querySelector('.item-row').cloneNode(true);

    // Update names for Spring Auto-binding index items[x]
    newRow.querySelectorAll('[name]').forEach(input => {
      const name = input.getAttribute('name');
      input.setAttribute('name', name.replace('[0]', `[${rowIdx}]`));
      if(!input.classList.contains('qty-input')) input.value = '';
    });

    container.appendChild(newRow);
    rowIdx++;
  });

  // Remove row
  document.addEventListener('click', function(e) {
    if(e.target.closest('.remove-row')) {
      const rows = document.querySelectorAll('.item-row');
      if(rows.length > 1) e.target.closest('.item-row').remove();
      calculateTotal();
    }
  });

  // Simple Auto-calculation of Total Amount
  document.addEventListener('input', function(e) {
    if(e.target.classList.contains('qty-input') || e.target.classList.contains('price-input')) {
      calculateTotal();
    }
  });

  function calculateTotal() {
    let total = 0;
    document.querySelectorAll('.item-row').forEach(row => {
      const qty = row.querySelector('.qty-input').value || 0;
      const price = row.querySelector('.price-input').value || 0;
      total += (qty * price);
    });
    document.getElementById('totalBillAmount').value = total.toFixed(2);
  }
</script>

</body>
</html>
