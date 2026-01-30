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

        :root {
            --sidebar-width: 260px;
            --brand-color: #0d6efd;
            --bg-soft: #f8f9fa;
            --card-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
        }

        html, body {
            height: 100%;
        }

        body {
            background-color: var(--bg-soft);
        }

        .app-shell {
            display: grid;
            grid-template-columns: var(--sidebar-width) 1fr;
            min-height: 100vh;
        }

        .sidebar {
            background: #212529;
            color: #fff;
            position: sticky;
            top: 0;
            height: 100vh;
            padding: 1rem;
            border-right: 1px solid rgba(255, 255, 255, 0.08);
        }

        .sidebar .brand {
            font-weight: 700;
            letter-spacing: 0.3px;
        }

        .sidebar .nav-link {
            color: #adb5bd;
            border-radius: .375rem;
        }

        .sidebar .nav-link.active, .sidebar .nav-link:hover {
            color: #fff;
            background: rgba(255, 255, 255, 0.08);
        }

        .main {
            padding: 0;
            display: flex;
            flex-direction: column;
        }

        .topbar {
            position: sticky;
            top: 0;
            z-index: 1030;
            background: #fff;
            border-bottom: 1px solid #e9ecef;
        }

        .topbar .container-fluid {
            padding: .75rem 1rem;
        }

        .card {
            border: none;
            box-shadow: var(--card-shadow);
        }

        .table thead {
            background-color: #f1f3f5;
        }

        .table th {
            font-weight: 600;
        }

        .table td {
            vertical-align: middle;
        }

        .badge-soft {
            background: #e9ecef;
            color: #495057;
        }

        .text-muted-small {
            color: #6c757d;
            font-size: .875rem;
        }

        .clickable {
            cursor: pointer;
        }

        @media (max-width: 992px) {
            .app-shell {
                grid-template-columns: 1fr;
            }

            .sidebar {
                position: fixed;
                left: -100%;
                width: var(--sidebar-width);
                transition: left .25s ease;
            }

            .sidebar.open {
                left: 0;
            }
        }
    </style>
</head>
<body>

<div class="app-shell">
    <%@ include file="/WEB-INF/fragments/sidebar.html" %>

    <main class="main">
        <div class="topbar">
            <div class="container-fluid d-flex align-items-center justify-content-between">
                <div>
                    <h1 class="h5 mb-0">Stock Master</h1>
                    <span class="text-muted-small">Manage batches, pricing, and quantities</span>
                </div>

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
                            <input type="search" class="form-control" id="stockSearch"
                                   placeholder="Search by Batch No or Variant...">
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
                                <th>SID</th>
                                <th>Variant</th>
                                <th class="ps-3">Batch No</th>
                                <th>Quantity</th>
                                <th>Purchase</th>
                                <th>Landing Cost</th>
                                <th>MRP</th>
                                <th>Selling Price</th>
                                <th>Expiry</th>
                                <th class="text-end pe-3">Actions</th>
                            </tr>
                            </thead>
                            <tbody id="stockTableBody">
                            <c:forEach items="${stocks}" var="s">
                                <tr data-batch="${s.stockMasterId}">
                                    <td class="ps-3">
                                        <strong><c:out value="${s.stockMasterId}"/></strong>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty s.variant}">
                                                <span class="text-dark fw-bold">${s.variant.variantName}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-danger small">
                                                        <i class="fas fa-exclamation-triangle me-1"></i> Removed
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><c:out value="${s.batchNo}"/></td>
                                    <td>
                                        <span class="badge ${s.quantity < 10 ? 'bg-danger' : 'badge-soft'}">${s.quantity}</span>
                                    </td>
                                    <td>
                                            ${s.purchasePrice.price}
                                    </td>
                                    <td>
                                            ${s.landingCost.price}
                                    </td>
                                    <td>
                                            ${s.mrp.price}
                                    </td>
                                    <td>
                                            ${s.sellingPrice.price}
                                    </td>
                                    <td><c:out value="${s.expiryDate}"/></td>
                                    <td class="text-end pe-3">
                                        <button class="btn btn-sm btn-outline-info" data-bs-toggle="modal"
                                                data-bs-target="#editStockModal"
                                                data-id="${s.stockMasterId}" data-price="${s.sellingPrice.price}"
                                                data-mrp="${s.mrp.price}" data-batch="${s.batchNo}">
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
<div class="modal fade" id="editStockModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <form class="modal-content needs-validation" novalidate method="post" action="/stockmaster/update">
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title"><i class="fas fa-edit me-2"></i>Edit Stock Record</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                        aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="stockMasterId" id="edit-stockId">

                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label fw-bold">Batch No</label>
                        <input type="text" class="form-control bg-light" id="edit-batchNo" name="batchNo" readonly>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold">MRP</label>
                        <input type="number" step="0.01" min="0" class="form-control price-input" id="edit-mrp"
                               name="mrp" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold">Selling Price</label>
                        <input type="number" step="0.01" min="0" class="form-control price-input" id="edit-sellingPrice"
                               name="sellingPrice" required>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-info text-white">Update Stock Record</button>
            </div>
        </form>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Simple client-side search for Batch No
    document.getElementById('stockSearch').addEventListener('input', function (e) {
        const term = e.target.value.toLowerCase();
        document.querySelectorAll('#stockTableBody tr').forEach(row => {
            const content = row.textContent.toLowerCase();
            row.style.display = content.includes(term) ? '' : 'none';
        });
    });

    (function () {
        'use strict'
        const forms = document.querySelectorAll('.needs-validation')
        Array.from(forms).forEach(form => {
            form.addEventListener('submit', event => {
                const mrpInput = form.querySelector('input[name="mrp"]');
                const sellingInput = form.querySelector('input[name="sellingPrice"]');

                const mrpVal = parseFloat(mrpInput.value) || 0;
                const sellingVal = parseFloat(sellingInput.value) || 0;

                // 2. Custom Validation Check
                if (sellingVal > mrpVal) {
                    sellingInput.setCustomValidity("Selling price is lower than MRP");
                } else {
                    sellingInput.setCustomValidity("");
                }

                if (!form.checkValidity()) {
                    event.preventDefault()
                    event.stopPropagation()
                }
                form.classList.add('was-validated')
            }, false)
        })
    })()

    document.querySelectorAll('.price-input').forEach(input => {
        input.addEventListener('keydown', e => {
            if (["e", "E", "+", "-"].includes(e.key)) e.preventDefault();
        });
    });


    const editStockModal = document.getElementById('editStockModal');
    if (editStockModal) {
        editStockModal.addEventListener('show.bs.modal', event => {
            // Button that triggered the modal
            const button = event.relatedTarget;

            // Extract info from data-attributes
            const stockId = button.getAttribute('data-id');
            const sellingPrice = button.getAttribute('data-price');
            const mrp = button.getAttribute('data-mrp');
            const batch = button.getAttribute('data-batch');

            // Update the modal's content
            editStockModal.querySelector('#edit-stockId').value = stockId;
            editStockModal.querySelector('#edit-sellingPrice').value = sellingPrice;
            editStockModal.querySelector('#edit-batchNo').value = batch;
            editStockModal.querySelector('#edit-mrp').value = mrp;
        });
    }
</script>

</body>
</html>
