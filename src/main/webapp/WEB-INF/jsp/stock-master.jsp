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
    <title>Monarch ERP | Stock Master</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        :root { --sidebar-width: 260px; --brand-color: #0d6efd; --bg-soft: #f8f9fa; --card-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075); }
        html, body { height: 100%; }
        body { background-color: var(--bg-soft); }
        .app-shell { display: grid; grid-template-columns: var(--sidebar-width) 1fr; min-height: 100vh; }
        .sidebar { background: #212529; color: #fff; position: sticky; top: 0; height: 100vh; padding: 1rem; border-right: 1px solid rgba(255,255,255,0.08); }
        .sidebar .brand { font-weight: 700; letter-spacing: 0.3px; }
        .sidebar .nav-link { color: #adb5bd; border-radius: .375rem; }
        .sidebar .nav-link.active, .sidebar .nav-link:hover { color: #fff; background: rgba(255,255,255,0.08); }
        .main { padding: 0; display: flex; flex-direction: column; }
        .topbar { position: sticky; top: 0; z-index: 1030; background: #fff; border-bottom: 1px solid #e9ecef; }
        .topbar .container-fluid { padding: .75rem 1rem; }
        .card { border: none; box-shadow: var(--card-shadow); }
        .table thead { background-color: #f1f3f5; }
        .table th { font-weight: 600; }
        .table td { vertical-align: middle; }
        .badge-soft { background: #e9ecef; color: #495057; }
        .text-muted-small { color: #6c757d; font-size: .875rem; }
        .clickable { cursor: pointer; }
        @media (max-width: 992px) { .app-shell { grid-template-columns: 1fr; } .sidebar { position: fixed; left: -100%; width: var(--sidebar-width); transition: left .25s ease; } .sidebar.open { left: 0; } }
    </style>
</head>
<body>

<div class="app-shell">
    <nav class="sidebar" aria-label="Primary">
        <div class="d-flex align-items-center justify-content-between mb-3">
            <div class="brand d-flex align-items-center gap-2">
                <i class="fa-solid fa-crown text-warning"></i>
                <span>Monarch ERP</span>
            </div>
        </div>
        <ul class="nav nav-pills flex-column gap-1">
            <li class="nav-item"><a href="/products" class="nav-link"><i class="fas fa-box me-2"></i> Products</a></li>
            <li class="nav-item"><a href="/variants" class="nav-link"><i class="fas fa-tags me-2"></i> Variants</a></li>
            <li class="nav-item"><a href="/stockmaster" class="nav-link active"><i class="fas fa-warehouse me-2"></i> Inventory</a></li>
        </ul>
    </nav>

    <main class="main">
        <div class="topbar">
            <div class="container-fluid d-flex align-items-center justify-content-between">
                <div>
                    <h1 class="h5 mb-0">Stock Master</h1>
                    <span class="text-muted-small">Manage batches, pricing, and quantities</span>
                </div>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addStockModal">
                    <i class="fas fa-plus me-1"></i> Update Stock
                </button>
            </div>
        </div>

        <div class="container-fluid py-4">
            <div class="row g-3 mb-4">
                <div class="col-md-3">
                    <div class="card p-3">
                        <div class="text-muted-small">Total Quantity</div>
                        <div class="h3 mb-0 text-primary">${totalQuantity}</div>
                    </div>
                </div>
                <div class="col-md-9">
                    <div class="card p-3">
                        <div class="d-flex align-items-center gap-2">
                            <i class="fa-solid fa-magnifying-glass text-muted"></i>
                            <input type="search" class="form-control" id="stockSearch" placeholder="Search by Batch No or Variant...">
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
                                <th class="ps-3">Batch No</th>
                                <th>Variant</th>
                                <th>Quantity</th>
                                <th>Purchase/MRP</th>
                                <th>Expiry</th>
                                <th class="text-end pe-3">Actions</th>
                            </tr>
                            </thead>
                            <tbody id="stockTableBody">
                            <c:forEach items="${stocks}" var="s">
                                <tr data-batch="${s.batchNo}">
                                    <td class="ps-3">
                                        <strong><c:out value="${s.batchNo}"/></strong>
                                        <div class="text-muted-small">ID: ${s.stockMasterId}</div>
                                    </td>
                                    <td><c:out value="${s.variant.variantName}"/></td>
                                    <td>
                                            <span class="badge ${s.quantity < 10 ? 'bg-danger' : 'badge-soft'}">
                                                    ${s.quantity}
                                            </span>
                                    </td>
                                    <td>
                                        <div class="small">P: ${s.purchasePrice.price}</div>
                                        <div class="fw-bold">M: ${s.mrp.price}</div>
                                    </td>
                                    <td><c:out value="${s.expiryDate}"/></td>
                                    <td class="text-end pe-3">
                                        <button class="btn btn-sm btn-outline-info" data-bs-toggle="modal" data-bs-target="#editStockModal"
                                                data-id="${s.stockMasterId}" data-qty="${s.quantity}" data-batch="${s.batchNo}">
                                            <i class="fas fa-edit"></i>
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

<div class="modal fade" id="addStockModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <form class="modal-content needs-validation" novalidate method="post" action="/stockmaster/add">
            <div class="modal-header">
                <h5 class="modal-title">Stock Entry</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Variant</label>
                        <select class="form-select" name="variant.variantId" required>
                            <c:forEach items="${variants}" var="v">
                                <option value="${v.variantId}">${v.variantName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Quantity</label>
                        <input type="number" class="form-control" name="quantity" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Purchase Price</label>
                        <input type="number" step="0.01" class="form-control" name="purchasePrice.price" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">MRP</label>
                        <input type="number" step="0.01" class="form-control" name="mrp.price" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Selling Price</label>
                        <input type="number" step="0.01" class="form-control" name="sellingPrice.price" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Manufacture Date</label>
                        <input type="date" class="form-control" name="manufactureDate">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Expiry Date</label>
                        <input type="date" class="form-control" name="expiryDate">
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary">Save Stock Record</button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Simple client-side search for Batch No
    document.getElementById('stockSearch').addEventListener('input', function(e) {
        const term = e.target.value.toLowerCase();
        document.querySelectorAll('#stockTableBody tr').forEach(row => {
            const batch = row.dataset.batch.toLowerCase();
            row.style.display = batch.includes(term) ? '' : 'none';
        });
    });
</script>

</body>
</html>
