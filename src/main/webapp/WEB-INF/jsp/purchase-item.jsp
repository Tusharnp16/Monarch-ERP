<%--
  Created by IntelliJ IDEA.
  User: tusharparmar
  Date: 22-01-2026
  Time: 16:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Monarch ERP | Purchase Management</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

  <style>
    :root {
      --sidebar-width: 260px;
      --bg-soft: #f8f9fa;
      --card-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075);
    }
    html, body { height: 100%; }
    body { background-color: var(--bg-soft); font-family: 'Inter', sans-serif; }

    .app-shell { display: grid; grid-template-columns: var(--sidebar-width) 1fr; min-height: 100vh; }

    /* Sidebar */
    .sidebar { background: #212529; color: #fff; position: sticky; top: 0; height: 100vh; padding: 1rem; }
    .sidebar .brand { font-weight: 700; }
    .sidebar .nav-link { color: #adb5bd; border-radius: .375rem; margin-bottom: 2px; }
    .sidebar .nav-link.active { color: #fff; background: rgba(255,255,255,0.08); }

    /* Main */
    .main { display: flex; flex-direction: column; }
    .topbar { position: sticky; top: 0; z-index: 1030; background: #fff; border-bottom: 1px solid #e9ecef; padding: .75rem 1rem; }

    /* Tables & UI */
    .card { border: none; box-shadow: var(--card-shadow); }
    .table thead { background-color: #f1f3f5; }
    .badge-purchase { background: #e7f5ff; color: #1971c2; border: 1px solid #a5d8ff; }
    .text-muted-small { color: #6c757d; font-size: .875rem; }

    @media (max-width: 992px) {
      .app-shell { grid-template-columns: 1fr; }
      .sidebar { display: none; } /* Simplified for code length */
    }
  </style>
</head>
<body>

<div class="app-shell">
  <nav class="sidebar">
    <div class="brand d-flex align-items-center gap-2 mb-4">
      <i class="fa-solid fa-crown text-warning"></i>
      <span>Monarch ERP</span>
    </div>
    <ul class="nav nav-pills flex-column">
      <li class="nav-item"><a href="/products" class="nav-link"><i class="fas fa-box me-2"></i> Products</a></li>
      <li class="nav-item"><a href="/stockmaster" class="nav-link"><i class="fas fa-warehouse me-2"></i> Inventory</a></li>
      <li class="nav-item"><a href="/purchaseitem" class="nav-link active"><i class="fas fa-shopping-cart me-2"></i> Purchases</a></li>
    </ul>
  </nav>

  <main class="main">
    <div class="topbar d-flex justify-content-between align-items-center">
      <div>
        <h1 class="h5 mb-0">Purchase Logs</h1>
        <span class="text-muted-small">Track procurement and inbound items</span>
      </div>
      <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addPurchaseModal">
        <i class="fas fa-plus me-1"></i> New Purchase
      </button>
    </div>

    <div class="container-fluid py-4">
      <div class="row g-3 mb-4">
        <div class="col-md-4">
          <div class="card p-3 d-flex flex-row align-items-center justify-content-between">
            <div>
              <div class="text-muted-small">Total Orders</div>
              <div class="h3 mb-0">${purchaseItems.size()}</div>
            </div>
            <i class="fa-solid fa-file-invoice-dollar fa-2x text-light"></i>
          </div>
        </div>
        <div class="col-md-8">
          <div class="card p-3">
            <div class="input-group">
              <span class="input-group-text bg-white border-end-0"><i class="fa-solid fa-magnifying-glass text-muted"></i></span>
              <input type="text" class="form-control border-start-0" id="purchaseSearch" placeholder="Search by Variant or Purchase ID...">
            </div>
          </div>
        </div>
      </div>

      <div class="card">
        <div class="card-body p-0">
          <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
              <thead>
              <tr>
                <th class="ps-3">ID</th>
                <th>Variant Details</th>
                <th>Quantity</th>
                <th>Unit Price</th>
                <th>Landing Cost</th>
                <th>Expiry Date</th>
                <th class="text-end pe-3">Actions</th>
              </tr>
              </thead>
              <tbody id="purchaseTableBody">
              <c:forEach items="${purchaseItems}" var="item">
                <tr>
                  <td class="ps-3 text-muted-small">#${item.purchaseItemId}</td>
                  <td>
                    <div class="fw-bold">${item.variant.variantName}</div>
                    <div class="text-muted-small">Code: ${item.variant.variantCode}</div>
                  </td>
                  <td><span class="badge badge-purchase">${item.qty}</span></td>
                  <td>${item.price.price}</td>
                  <td>${item.landingCost.price}</td>
                  <td>
                    <i class="fa-regular fa-calendar-times me-1 text-danger"></i>
                      ${item.expireDate}
                  </td>
                  <td class="text-end pe-3">
                    <button class="btn btn-sm btn-outline-secondary" title="View Details">
                      <i class="fas fa-eye"></i>
                    </button>
                    <button class="btn btn-sm btn-outline-danger ms-1" onclick="confirmDelete(${item.purchaseItemId})">
                      <i class="fas fa-trash"></i>
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

<div class="modal fade" id="addPurchaseModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <form class="modal-content needs-validation" novalidate method="post" action="/purchaseitem/add">
      <div class="modal-header">
        <h5 class="modal-title">Log New Purchase Item</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <div class="row g-3">
          <div class="col-md-12">
            <label class="form-label">Select Variant</label>
            <select class="form-select" name="variant.variantId" required>
              <option value="">Choose variant...</option>
              <c:forEach items="${variants}" var="v">
                <option value="${v.variantId}">${v.variantName} (${v.variantCode})</option>
              </c:forEach>
            </select>
          </div>
          <div class="col-md-6">
            <label class="form-label">Quantity (Qty)</label>
            <input type="number" class="form-control" name="qty" required min="1">
          </div>
          <div class="col-md-6">
            <label class="form-label">Unit Purchase Price</label>
            <div class="input-group">
              <span class="input-group-text">₹</span>
              <input type="number" step="0.01" class="form-control" name="price.price" required>
            </div>
          </div>
          <div class="col-md-6">
            <label class="form-label">Landing Cost</label>
            <div class="input-group">
              <span class="input-group-text">₹</span>
              <input type="number" step="0.01" class="form-control" name="landingCost.price" required>
            </div>
          </div>
          <div class="col-md-6">
            <label class="form-label">Expiry Date</label>
            <input type="date" class="form-control" name="expireDate" required>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
        <button type="submit" class="btn btn-primary">
          <i class="fa-solid fa-cart-plus me-1"></i> Confirm Purchase
        </button>
      </div>
    </form>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // Simple filter for the table
  document.getElementById('purchaseSearch')?.addEventListener('input', function(e) {
    const val = e.target.value.toLowerCase();
    const rows = document.querySelectorAll('#purchaseTableBody tr');
    rows.forEach(row => {
      row.style.display = row.innerText.toLowerCase().includes(val) ? '' : 'none';
    });
  });

  function confirmDelete(id) {
    if(confirm('Are you sure you want to delete this purchase entry?')) {
      window.location.href = '/purchaseitem/delete/' + id;
    }
  }
</script>

</body>
</html>
