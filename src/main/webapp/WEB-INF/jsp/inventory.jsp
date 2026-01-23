<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Monarch ERP | Inventory Management</title>
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
        body { background-color: var(--bg-soft); }

        /* Layout */
        .app-shell { display: grid; grid-template-columns: var(--sidebar-width) 1fr; min-height: 100vh; }
        .sidebar {
            background: #212529; color: #fff; position: sticky; top: 0; height: 100vh; padding: 1rem;
            border-right: 1px solid rgba(255,255,255,0.08);
        }
        .sidebar .brand { font-weight: 700; letter-spacing: 0.3px; }
        .sidebar .nav-link { color: #adb5bd; border-radius: .375rem; }
        .sidebar .nav-link.active, .sidebar .nav-link:hover { color: #fff; background: rgba(255,255,255,0.08); }
        .main { padding: 0; display: flex; flex-direction: column; }

        /* Topbar */
        .topbar { position: sticky; top: 0; z-index: 1030; background: #fff; border-bottom: 1px solid #e9ecef; }
        .topbar .container-fluid { padding: .75rem 1rem; }

        /* Status Styling */
        .status-pill { width: 10px; height: 10px; border-radius: 50%; display: inline-block; margin-right: 5px; }
        .status-instock { background-color: #198754; }
        .status-low { background-color: #fd7e14; }
        .status-out { background-color: #dc3545; }

        .card { border: none; box-shadow: var(--card-shadow); }
        .table thead { background-color: #f1f3f5; }
        .text-muted-small { color: #6c757d; font-size: .875rem; }

        @media (max-width: 992px) {
            .app-shell { grid-template-columns: 1fr; }
            .sidebar { position: fixed; left: -100%; width: var(--sidebar-width); transition: left .25s ease; z-index: 1040; }
            .sidebar.open { left: 0; }
        }
    </style>
</head>
<body>

<div class="app-shell">
    <%@ include file="/WEB-INF/fragments/sidebar.html" %>

    <main class="main">
        <div class="topbar">
            <div class="container-fluid d-flex align-items-center justify-content-between">
                <div class="d-flex align-items-center gap-3">
                    <h1 class="h5 mb-0">Inventory Levels</h1>
                    <span class="text-muted-small">Real-time stock monitoring</span>
                </div>
                <div class="d-flex gap-2">
                    <button class="btn btn-outline-primary" onclick="window.print()">
                        <i class="fas fa-print me-1"></i> Export PDF
                    </button>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#adjustStockModal">
                        <i class="fas fa-sync me-1"></i> Manual Adjustment
                    </button>
                </div>
            </div>
        </div>

        <div class="container-fluid py-4">
            <div class="row g-3 mb-4">
                <div class="col-md-4">
                    <div class="card p-3 border-start border-4 border-success">
                        <div class="text-muted-small text-uppercase">Total Items In Stock</div>
                        <div class="h4 mb-0"><c:out value="${totalStockCount != null ? totalStockCount : '0'}"/></div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card p-3 border-start border-4 border-warning">
                        <div class="text-muted-small text-uppercase">Low Stock Alerts</div>
                        <div class="h4 mb-0 text-warning"><c:out value="${lowStockCount != null ? lowStockCount : '0'}"/></div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card p-3 border-start border-4 border-danger">
                        <div class="text-muted-small text-uppercase">Out of Stock</div>
                        <div class="h4 mb-0 text-danger"><c:out value="${outOfStockCount != null ? outOfStockCount : '0'}"/></div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-header bg-white py-3">
                    <input type="text" id="inventorySearch" class="form-control" placeholder="Search by product name or SKU code...">
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                            <tr>
                                <th>Inventory Id</th>
                                <th class="ps-3">Variant / SKU</th>
                                <th>On Hand</th>
                                <th>Reserved</th>
                                <th>Available</th>
                                <th>Status</th>
                                <th class="text-end pe-3">Actions</th>
                            </tr>
                            </thead>
                            <tbody id="inventoryTableBody">
                            <c:choose>
                                <c:when test="${not empty inventoryList}">
                                    <c:forEach items="${inventoryList}" var="item">
                                        <tr data-name="${item.variant.variantName}" data-sku="${item.variant.product.itemCode}">
                                        <td><c:out value="${item.inventoryId}"/></td>
                                            <td class="ps-3"><strong><c:out value="${item.variant.variantName}"/></strong>
                                                <div class="text-muted-small">
                                                <span class="badge badge-soft text-primary"><c:out value="${item.variant.product.itemCode}"/></span></div>
                                            </td>
                                            <td><c:out value="${item.availableQuantity}"/></td>
                                            <td><c:out value="20"/></td>
                                            <td><span class="fw-bold"><c:out value="${item.quantity}"/></span></td>
                                            <td>
                                                <c:set var="avail" value="${30}" />
                                                <c:choose>
                                                    <c:when test="${avail <= 0}">
                                                        <span class="status-pill status-out"></span> Out of Stock
                                                    </c:when>
                                                    <c:when test="${avail < 10}">
                                                        <span class="status-pill status-low"></span> Low Stock
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-pill status-instock"></span> In Stock
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end pe-3">
                                                <button class="btn btn-sm btn-light action-history" data-id="${item.inventoryId}" title="View History">
                                                    <i class="fas fa-history text-secondary"></i>
                                                </button>
                                                <button class="btn btn-sm btn-light action-move" data-id="${item.inventoryId}" title="Stock Movement">
                                                    <i class="fas fa-exchange-alt text-primary"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="6" class="text-center py-5">
                                            <i class="fa-regular fa-face-frown fa-2x text-muted mb-2"></i>
                                            <p class="mb-0">No inventory data found.</p>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<div class="modal fade" id="adjustStockModal" tabindex="-1">
    <div class="modal-dialog">
        <form class="modal-content" action="/inventory/adjust" method="POST">
            <div class="modal-header">
                <h5 class="modal-title">Manual Stock Adjustment</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label">Select Product Variant</label>
                    <select class="form-select" name="inventoryId" required>
                        <option value="">Choose...</option>
                        <c:forEach items="${inventoryList}" var="item">
                            <option value="${item.inventoryId}">${item.variant.product.productName} (${item.variant.variantName})</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="row mb-3">
                    <div class="col">
                        <label class="form-label">Type</label>
                        <select class="form-select" name="adjustmentType">
                            <option value="ADD">Add (+)</option>
                            <option value="SUBTRACT">Remove (-)</option>
                            <option value="SET">Set Exact (=)</option>
                        </select>
                    </div>
                    <div class="col">
                        <label class="form-label">Quantity</label>
                        <input type="number" class="form-control" name="quantity" min="1" required>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Reason</label>
                    <textarea class="form-control" name="reason" rows="2" placeholder="e.g. Damage, Restock"></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
                <button type="submit" class="btn btn-primary">Update Stock</button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // 1. Client-side Search Functionality
    document.getElementById('inventorySearch')?.addEventListener('input', function(e) {
        const query = e.target.value.toLowerCase();
        const rows = document.querySelectorAll('#inventoryTableBody tr[data-name]');

        rows.forEach(row => {
            const name = row.getAttribute('data-name').toLowerCase();
            const sku = row.getAttribute('data-sku').toLowerCase();
            row.style.display = (name.includes(query) || sku.includes(query)) ? '' : 'none';
        });
    });

    // 2. Action Button Event Listeners
    document.querySelectorAll('.action-history').forEach(btn => {
        btn.addEventListener('click', function() {
            const id = this.getAttribute('data-id');
            window.location.href = '/inventory/history?id=' + id;
        });
    });

    document.querySelectorAll('.action-move').forEach(btn => {
        btn.addEventListener('click', function() {
            const id = this.getAttribute('data-id');
            // Logic for opening a transfer modal or redirecting
            alert('Initiating stock movement for Inventory ID: ' + id);
        });
    });
</script>
</body>
</html>