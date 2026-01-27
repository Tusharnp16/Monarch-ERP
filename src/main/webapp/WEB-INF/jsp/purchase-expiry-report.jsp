<%--
  Created by IntelliJ IDEA.
  User: tusharparmar
  Date: 27-01-2026
  Time: 17:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Monarch ERP | Expiry Watchlist</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        :root { --sidebar-width: 260px; --warning-orange: #f39c12; --danger-red: #e74c3c; }
        body { background-color: #f4f7f6; font-family: 'Inter', sans-serif; }
        .app-shell { display: grid; grid-template-columns: var(--sidebar-width) 1fr; min-height: 100vh; }

        /* Expiry Specific Styles */
        .supplier-header {
            background: #fff;
            border-left: 5px solid #0d6efd;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        }
        .item-card {
            transition: transform 0.2s;
            border: 1px solid #eee;
        }
        .item-card:hover { transform: translateY(-3px); box-shadow: 0 8px 15px rgba(0,0,0,0.1); }
        .expiry-badge { font-size: 0.75rem; padding: 0.4em 0.8em; border-radius: 50px; }
        .days-left { font-size: 1.1rem; font-weight: 800; color: var(--danger-red); }
        .money-text { font-family: monospace; font-weight: bold; color: #2c3e50; }
    </style>
</head>
<body>

<div class="app-shell">
    <%@ include file="/WEB-INF/fragments/sidebar.html" %>

    <main class="p-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold mb-1">Stock Expiry Report</h2>
                <p class="text-muted"><i class="fa-solid fa-calendar-day me-2"></i>Showing items expiring within the next 30 days</p>
            </div>
            <div class="btn-group">
                <button onclick="window.print()" class="btn btn-outline-dark"><i class="fa-solid fa-print me-2"></i>Print PDF</button>
                <button class="btn btn-primary"><i class="fa-solid fa-file-export me-2"></i>Export Excel</button>
            </div>
        </div>

        <c:forEach items="${groupedItems}" var="group">
            <div class="supplier-header p-3">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span class="text-uppercase text-muted small fw-bold">Supplier</span>
                        <h4 class="mb-0 text-primary">${group.key}</h4>
                    </div>
                    <span class="badge bg-primary-subtle text-primary rounded-pill">${group.value.size()} Items Found</span>
                </div>
            </div>

            <div class="row g-3 mb-5">
                <c:forEach items="${group.value}" var="item">
                    <div class="col-xl-4 col-md-6">
                        <div class="card item-card h-100">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div>
                                        <h6 class="fw-bold mb-0">${item.variant.variantName}</h6>
                                        <small class="text-muted">Batch: ${item.stockMaster.batchNo}</small>
                                    </div>
                                    <span class="badge bg-danger-subtle text-danger expiry-badge">
                                        Exp: ${item.expireDate}
                                    </span>
                                </div>

                                <div class="row g-2 mb-3 bg-light p-2 rounded">
                                    <div class="col-6">
                                        <small class="text-muted d-block">Quantity</small>
                                        <span class="fw-bold">${item.qty} units</span>
                                    </div>
                                    <div class="col-6 text-end">
                                        <small class="text-muted d-block">Loss Value</small>
                                        <span class="money-text text-danger">${item.netAmount.price}</span>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-between align-items-center">
                                    <small class="text-muted">Inv: #${item.purchase.billNo}</small>
                                    <button class="btn btn-sm btn-outline-primary py-0">Details</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:forEach>

        <c:if test="${empty groupedItems}">
            <div class="text-center py-5">
                <i class="fa-solid fa-shield-check text-success display-1 mb-3"></i>
                <h3>All Clear!</h3>
                <p class="text-muted">No items are expiring in the next 30 days.</p>
            </div>
        </c:if>
    </main>
</div>

</body>
</html>
