<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Monarch ERP | Product Management</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <!-- App Styles -->
    <style>
        :root {
            --sidebar-width: 260px;
            --brand-color: #0d6efd;
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
        .main {
            padding: 0; display: flex; flex-direction: column;
        }

        /* Topbar */
        .topbar {
            position: sticky; top: 0; z-index: 1030; background: #fff; border-bottom: 1px solid #e9ecef;
        }
        .topbar .container-fluid { padding: .75rem 1rem; }

        /* Cards & Tables */
        .card { border: none; box-shadow: var(--card-shadow); }
        .table thead { background-color: #f1f3f5; }
        .table th { font-weight: 600; }
        .table td { vertical-align: middle; }
        .badge-soft { background: #e9ecef; color: #495057; }

        /* Utilities */
        .text-muted-small { color: #6c757d; font-size: .875rem; }
        .truncate { max-width: 360px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .clickable { cursor: pointer; }

        /* Responsive */
        @media (max-width: 992px) {
            .app-shell { grid-template-columns: 1fr; }
            .sidebar { position: fixed; left: -100%; width: var(--sidebar-width); transition: left .25s ease; }
            .sidebar.open { left: 0; }
            .main { margin-left: 0; }
        }

        /* Skeleton loader */
        .skeleton {
            display: inline-block; height: 1rem; width: 100%; background: linear-gradient(90deg, #eee, #f5f5f5, #eee);
            background-size: 200% 100%; animation: shimmer 1.2s infinite;
        }
        @keyframes shimmer { 0% { background-position: 200% 0; } 100% { background-position: -200% 0; } }

        /* Toasts */
        .toast-container { position: fixed; top: 1rem; right: 1rem; z-index: 1080; }
    </style>
</head>
<body>

<div class="app-shell">

    <!-- Sidebar -->
    <%@ include file="/WEB-INF/fragments/sidebar.html" %>

    <!-- Main -->
    <main class="main">

        <!-- Topbar -->
        <div class="topbar">
            <div class="container-fluid d-flex align-items-center justify-content-between">
                <div class="d-flex align-items-center gap-3">
                    <h1 class="h5 mb-0">Product Catalog</h1>
                    <span class="text-muted-small">Manage products, codes, and lifecycle</span>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <button class="btn btn-outline-secondary d-lg-none" id="openSidebar"><i class="fa-solid fa-bars"></i></button>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addProductModal">
                        <i class="fas fa-plus me-1"></i> Add Product
                    </button>
                </div>
            </div>
        </div>

        <!-- Content -->
        <div class="container-fluid py-4">

            <!-- KPIs -->
            <div class="row g-3 mb-3">
                <div class="col-md-3">
                    <div class="card p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="text-muted-small">Total products</div>
                                <div class="h3 mb-0 text-primary">
                                    <c:out value="${products.size()}"/>
                                </div>
                            </div>
                            <i class="fa-solid fa-box-open fa-2x text-primary"></i>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="text-muted-small">Active today</div>
                                <div class="h3 mb-0">
                                    <c:out value="${activeCount}"/>
                                </div>
                            </div>
                            <i class="fa-solid fa-bolt fa-2x text-warning"></i>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card p-3">
                        <div class="d-flex align-items-center gap-2">
                            <i class="fa-solid fa-magnifying-glass text-muted"></i>
                            <input type="search" class="form-control" id="searchInput" placeholder="Search by name or item code…">
                            <button class="btn btn-outline-secondary" data-bs-toggle="offcanvas" data-bs-target="#filtersCanvas">
                                <i class="fa-solid fa-filter me-1"></i> Filters
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Table -->
            <div class="card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                            <tr>
                                <th class="ps-3">ID</th>
                                <th>Product name</th>
                                <th>Item code</th>
                                <th>Created at</th>
                                <th class="text-end pe-3">Actions</th>
                            </tr>
                            </thead>
                            <tbody id="productTableBody">
                            <c:choose>
                                <c:when test="${not empty products}">
                                    <c:forEach items="${products}" var="product">
                                        <tr data-name="${product.productName}" data-code="${product.itemCode}">
                                            <td class="ps-3"><c:out value="${product.productId}"/></td>
                                            <td class="truncate">
                                                <strong><c:out value="${product.productName}"/></strong>
                                                <div class="text-muted-small">SKU: <c:out value="${product.itemCode}"/></div>
                                            </td>
                                            <td><span class="badge badge-soft"><c:out value="${product.itemCode}"/></span></td>
                                            <td>
                                                <span class="text-muted-small">
                                                    <c:out value="${product.createdAt}"/>
                                                </span>
                                            </td>
                                            <td class="text-end pe-3">
                                                <button class="btn btn-sm btn-outline-info me-1" data-bs-toggle="modal"
                                                        data-bs-target="#editProductModal"
                                                        data-id="${product.productId}"
                                                        data-name="${product.productName}"
                                                        data-code="${product.itemCode}">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-danger" data-bs-toggle="modal"
                                                        data-bs-target="#confirmDeleteModal"
                                                        data-id="${product.productId}">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="5" class="text-center py-5">
                                            <div class="mb-2"><i class="fa-regular fa-folder-open fa-2x text-muted"></i></div>
                                            <div class="mb-2">No products found</div>
                                            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addProductModal">
                                                <i class="fas fa-plus me-1"></i> Add your first product
                                            </button>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Pagination -->
                <div class="card-footer d-flex justify-content-between align-items-center">
                    <div class="text-muted-small">
                        Showing <strong id="pageStart">1</strong>–<strong id="pageEnd">10</strong> of
                        <strong id="pageTotal"><c:out value="${products.size()}"/></strong>
                    </div>
                    <nav aria-label="Product pagination">
                        <ul class="pagination mb-0">
                            <li class="page-item"><a class="page-link clickable" id="prevPage">Prev</a></li>
                            <li class="page-item"><a class="page-link clickable" id="nextPage">Next</a></li>
                        </ul>
                    </nav>
                </div>
            </div>

        </div>
    </main>
</div>

<!-- Filters Offcanvas -->
<div class="offcanvas offcanvas-end" tabindex="-1" id="filtersCanvas" aria-labelledby="filtersLabel">
    <div class="offcanvas-header">
        <h5 id="filtersLabel">Filters</h5>
        <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
    </div>
    <div class="offcanvas-body">
        <form id="filtersForm">
            <div class="mb-3">
                <label class="form-label">Created date range</label>
                <div class="d-flex gap-2">
                    <input type="date" class="form-control" id="dateFrom">
                    <input type="date" class="form-control" id="dateTo">
                </div>
            </div>
            <div class="mb-3">
                <label class="form-label">Item code prefix</label>
                <input type="text" class="form-control" id="codePrefix" placeholder="e.g., MON-">
            </div>
            <div class="d-flex justify-content-end gap-2">
                <button type="reset" class="btn btn-outline-secondary">Reset</button>
                <button type="button" class="btn btn-primary" id="applyFiltersBtn">Apply</button>
            </div>
        </form>
    </div>
</div>

<!-- Add Product Modal -->
<div class="modal fade" id="addProductModal" tabindex="-1" aria-labelledby="addProductLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <form class="modal-content needs-validation" novalidate method="post" action="/products/add">
            <div class="modal-header">
                <h5 class="modal-title" id="addProductLabel">Add new product</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label">Product name</label>
                    <input type="text" class="form-control" name="productName" required maxlength="120" placeholder="e.g., Monarch Premium Chair">
                    <div class="invalid-feedback">Please enter a product name.</div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary">
                    <i class="fa-solid fa-floppy-disk me-1"></i> Save
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Edit Product Modal -->
<div class="modal fade" id="editProductModal" tabindex="-1" aria-labelledby="editProductLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <form class="modal-content needs-validation" novalidate method="post" action="/products/update">
            <div class="modal-header">
                <h5 class="modal-title" id="editProductLabel">Edit product</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="productId" id="editProductId">
                <div class="mb-3">
                    <label class="form-label">Product name</label>
                    <input type="text" class="form-control" name="productName" id="editProductName" required maxlength="120">
                    <div class="invalid-feedback">Please enter a product name.</div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Item code</label>
                    <input type="text" class="form-control" name="itemCode" id="editItemCode" required maxlength="60">
                    <div class="invalid-feedback">Item code is required.</div>
                </div>
                <div class="alert alert-warning d-flex align-items-center gap-2">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <div>Changing item codes can affect existing transactions. Proceed with caution.</div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary">
                    <i class="fa-solid fa-floppy-disk me-1"></i> Update
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Confirm Delete Modal -->
<div class="modal fade" id="confirmDeleteModal" tabindex="-1" aria-labelledby="confirmDeleteLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <form class="modal-content" method="post" action="/products/delete">
            <div class="modal-header">
                <h5 class="modal-title" id="confirmDeleteLabel">Delete product</h5>
                <input type="hidden" name="id" id="deleteProductId">
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-danger">
                    <i class="fa-solid fa-trash me-1"></i> Delete
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Toasts -->
<div class="toast-container">
    <div class="toast align-items-center text-bg-success border-0" id="successToast" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body">
                <i class="fa-solid fa-check me-2"></i> Action completed successfully.
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    </div>
    <div class="toast align-items-center text-bg-danger border-0" id="errorToast" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body">
                <i class="fa-solid fa-xmark me-2"></i> Something went wrong. Please try again.
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Sidebar toggle for mobile
    const sidebar = document.querySelector('.sidebar');
    document.getElementById('openSidebar')?.addEventListener('click', () => sidebar.classList.add('open'));
    document.getElementById('toggleSidebar')?.addEventListener('click', () => sidebar.classList.toggle('open'));

    // Client-side search
    const searchInput = document.getElementById('searchInput');
    const tableBody = document.getElementById('productTableBody');
    searchInput?.addEventListener('input', () => {
        const q = searchInput.value.toLowerCase().trim();
        tableBody.querySelectorAll('tr').forEach(row => {
            const name = (row.dataset.name || '').toLowerCase();
            const code = (row.dataset.code || '').toLowerCase();
            row.style.display = (name.includes(q) || code.includes(q)) ? '' : 'none';
        });
    });

    // Filters (demo client-side)
    document.getElementById('applyFiltersBtn')?.addEventListener('click', () => {
        const prefix = document.getElementById('codePrefix').value.trim().toLowerCase();
        tableBody.querySelectorAll('tr').forEach(row => {
            const code = (row.dataset.code || '').toLowerCase();
            const match = prefix ? code.startsWith(prefix) : true;
            row.style.display = match ? '' : 'none';
        });
        const offcanvasEl = document.getElementById('filtersCanvas');
        bootstrap.Offcanvas.getOrCreateInstance(offcanvasEl).hide();
    });

    // Pagination (simple client-side demo)
    let page = 1, pageSize = 10;
    function paginate() {
        const rows = Array.from(tableBody.querySelectorAll('tr')).filter(r => r.style.display !== 'none');
        const total = rows.length;
        const start = (page - 1) * pageSize;
        const end = Math.min(start + pageSize, total);
        rows.forEach((r, i) => r.style.visibility = (i >= start && i < end) ? 'visible' : 'hidden');
        document.getElementById('pageStart').textContent = total ? (start + 1) : 0;
        document.getElementById('pageEnd').textContent = end;
        document.getElementById('pageTotal').textContent = total;
    }
    document.getElementById('prevPage')?.addEventListener('click', () => { page = Math.max(1, page - 1); paginate(); });
    document.getElementById('nextPage')?.addEventListener('click', () => { page = page + 1; paginate(); });
    paginate();

    // Bootstrap validation
    (() => {
        const forms = document.querySelectorAll('.needs-validation');
        Array.from(forms).forEach(form => {
            form.addEventListener('submit', event => {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        });
    })();

    // Edit modal population
    const editModalEl = document.getElementById('editProductModal');
    editModalEl?.addEventListener('show.bs.modal', event => {
        const btn = event.relatedTarget;
        document.getElementById('editProductId').value = btn.getAttribute('data-id');
        document.getElementById('editProductName').value = btn.getAttribute('data-name');
        document.getElementById('editItemCode').value = btn.getAttribute('data-code');
    });

    // Delete modal population
    const deleteModalEl = document.getElementById('confirmDeleteModal');
    deleteModalEl?.addEventListener('show.bs.modal', event => {
        const btn = event.relatedTarget;
        document.getElementById('deleteProductId').value = btn.getAttribute('data-id');
    });

    // Toast helpers
    function showToast(id) {
        const toastEl = document.getElementById(id);
        bootstrap.Toast.getOrCreateInstance(toastEl).show();
    }
    // Example: showToast('successToast'); showToast('errorToast');
</script>
</body>
</html>
