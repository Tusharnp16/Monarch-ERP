<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Monarch ERP | Purchase Items</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        :root { --sidebar-width: 260px; --brand-color: #0d6efd; --bg-soft: #f8f9fa; --card-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075); }
        html, body { height: 100%; }
        body { background-color: var(--bg-soft); }
        .app-shell { display: grid; grid-template-columns: var(--sidebar-width) 1fr; min-height: 100vh; }
        .sidebar { background: #212529; color: #fff; position: sticky; top: 0; height: 100vh; padding: 1rem; border-right: 1px solid rgba(255,255,255,0.08); }
        .main { padding: 0; display: flex; flex-direction: column; }
        .topbar { position: sticky; top: 0; z-index: 1030; background: #fff; border-bottom: 1px solid #e9ecef; padding: .75rem 1rem; }
        .card { border: none; box-shadow: var(--card-shadow); border-radius: 10px; }
        .table thead { background-color: #f1f3f5; }
        .table th { font-weight: 600; font-size: 0.85rem; text-transform: uppercase; color: #495057; }
        .supplier-cell { font-weight: 600; color: #0d6efd; }
        .money-cell { font-family: 'Courier New', Courier, monospace; font-weight: 600; }
        .text-muted-small { color: #6c757d; font-size: .875rem; }
    </style>
</head>
<body>

<div class="app-shell">
    <%@ include file="/WEB-INF/fragments/sidebar.html" %>

    <main class="main">
        <div class="topbar">
            <div class="d-flex align-items-center justify-content-between">
                <div>
                    <h1 class="h5 mb-0">Purchase Item Registry</h1>
                    <span class="text-muted-small">Detailed breakdown of items by Supplier</span>
                </div>
                <button class="btn btn-primary btn-sm"><i class="fas fa-download me-2"></i>Export Report</button>
            </div>
        </div>

        <div class="container-fluid py-4">
            <div class="card p-3 mb-4">
                <div class="row g-3">
                    <div class="col-md-8">
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0"><i class="fa-solid fa-magnifying-glass text-muted"></i></span>
                            <input type="search" class="form-control border-start-0" id="itemSearch" placeholder="Search by Supplier, Variant or Purchase ID...">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <select class="form-select" id="dateFilter">
                            <option value="">All Transactions</option>
                            <option value="today">Today</option>
                            <option value="month">This Month</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                            <tr>
                                <th class="ps-3">Item ID</th>
                                <th>Supplier Name</th>
                                <th>Variant / Product</th>
                                <th>Qty</th>
                                <th>Unit Price</th>
                                <th>Tax Amt</th>
                                <th>Landing Cost</th>
                                <th>Net Amount</th>
                                <th>Expiry</th>
                                <th class="text-end pe-3">Batch Ref</th>
                            </tr>
                            </thead>
                            <tbody id="itemTableBody">
                            <c:forEach items="${purchaseItems}" var="item">
                                <tr>
                                    <td class="ps-3 text-muted">#${item.purchaseItemId}</td>
                                    <td>
                                        <div class="supplier-cell">${item.purchase.supplier.name}</div>
                                        <div class="text-muted-small">Inv: ${item.purchase.billNo}</div>
                                    </td>
                                    <td>
                                        <div class="fw-bold">${item.variant.variantName}</div>
                                        <small class="text-muted">SKU: ${item.variant.variantId}</small>
                                    </td>
                                    <td><span class="badge bg-light text-dark border">${item.qty}</span></td>
                                    <td class="money-cell">${item.price.price}</td>
                                    <td class="text-danger small">+ ${item.taxAmount.price}</td>
                                    <td class="money-cell">${item.landingCost.price}</td>
                                    <td class="money-cell text-success">${item.netAmount.price}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty item.expireDate}">
                                                <fmt:parseDate value="${item.expireDate}" pattern="yyyy-MM-dd" var="parsedDate" type="date" />
                                                <fmt:formatDate value="${parsedDate}" pattern="dd MMM yyyy" />
                                            </c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end pe-3">
                                        <span class="badge badge-soft text-primary border border-primary">
                                            <i class="fas fa-box-open me-1"></i> ${item.stockMaster.batchNo}
                                        </span>
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

<script>
    // Live Search Logic
    document.getElementById('itemSearch').addEventListener('input', function(e) {
        const term = e.target.value.toLowerCase();
        document.querySelectorAll('#itemTableBody tr').forEach(row => {
            const text = row.textContent.toLowerCase();
            row.style.display = text.includes(term) ? '' : 'none';
        });
    });
</script>

</body>
</html>