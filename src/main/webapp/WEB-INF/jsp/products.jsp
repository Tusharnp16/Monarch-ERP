<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Monarch ERP | Product Management</title>
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
        .topbar { position: sticky; top: 0; z-index: 1030; background: #fff; border-bottom: 1px solid #e9ecef; }
        .topbar .container-fluid { padding: .75rem 1rem; }
        .card { border: none; box-shadow: var(--card-shadow); }
        .table thead { background-color: #f1f3f5; }
        .truncate { max-width: 300px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .badge-soft { background: #e9ecef; color: #495057; }
        .text-muted-small { color: #6c757d; font-size: .875rem; }

        @media (max-width: 992px) {
            .app-shell { grid-template-columns: 1fr; }
            .sidebar { position: fixed; left: -100%; width: var(--sidebar-width); z-index: 1050; transition: left .25s ease; }
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
                    <h1 class="h5 mb-0">Product Catalog</h1>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <button class="btn btn-outline-secondary d-lg-none" id="openSidebar"><i class="fa-solid fa-bars"></i></button>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addProductModal">
                        <i class="fas fa-plus me-1"></i> Add Product
                    </button>
                </div>
            </div>
        </div>

        <div class="container-fluid py-4">
            <div class="row g-3 mb-3">
                <div class="col-md-3">
                    <div class="card p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="text-muted-small">Total Results</div>
                                <div class="h3 mb-0 text-primary">${products.totalElements}</div>
                            </div>
                            <i class="fa-solid fa-box-open fa-2x text-primary"></i>
                        </div>
                    </div>
                </div>
                <div class="col-md-9">
                    <div class="card p-3">
                        <form action="/products" method="get" class="d-flex gap-2">
                            <i class="fa-solid fa-magnifying-glass text-muted align-self-center"></i>
                            <input type="text" name="search" class="form-control" placeholder="Search by name or code..." value="${search}">
                              <div class="col-md-3">
                                    <label class="form-label">Start Date</label>
                                    <input type="date" name="startDate" class="form-control" value="${startDate}">
                                </div>

                                <div class="col-md-3">
                                    <label class="form-label">End Date</label>
                                    <input type="date" name="endDate" class="form-control" value="${endDate}">
                                </div>
                            <button type="submit" class="btn btn-primary">Search</button>
                            <a href="/products" class="btn btn-outline-secondary">Clear</a>
                        </form>
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
                                    <th>Product Details</th>
                                    <th>Item Code</th>
                                    <th>Created At</th>
                                    <th class="text-end pe-3">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty products.content}">
                                        <c:forEach items="${products.content}" var="product" varStatus="status">
                                            <tr>
                                                <td class="ps-3 fw-bold text-muted">
                                                     ${(products.number * products.size) + status.index + 1}
                                                 </td>
                                                  <td class="truncate">
                                                    <strong>${product.productName}</strong>
                                                </td>
                                                <td><span class="badge badge-soft">${product.itemCode}</span></td>
                                                <td class="text-muted-small">${product.createdAt.toLocalDate()}</td>
                                                <td class="text-end pe-3">
                                                    <button class="btn btn-sm btn-outline-info me-1"
                                                            data-bs-toggle="modal" data-bs-target="#editProductModal"
                                                            data-id="${product.productId}" data-name="${product.productName}"
                                                            data-code="${product.itemCode}">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    <button class="btn btn-sm btn-outline-danger"
                                                            data-bs-toggle="modal" data-bs-target="#confirmDeleteModal"
                                                            data-id="${product.productId}">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr><td colspan="5" class="text-center py-5 text-muted">No products found matching your criteria.</td></tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="card-footer d-flex justify-content-between align-items-center">
                    <div class="text-muted-small">
                        Page <strong>${products.number + 1}</strong> of <strong>${products.totalPages}</strong>
                        (${products.totalElements} total items)
                    </div>
                    <div class="card-footer d-flex justify-content-between align-items-center">
                        <div class="text-muted-small">
                            Page <strong>${products.totalPages > 0 ? products.number + 1 : 0}</strong> of <strong>${products.totalPages}</strong>
                            (${products.totalElements} total items)
                        </div>

                        <c:if test="${products.totalPages > 0}">
                            <nav>
                                <ul class="pagination mb-0">
                                    <li class="page-item ${products.first ? 'disabled' : ''}">
                                        <a class="page-link" href="/products?page=${products.number - 1}&search=${search}">Previous</a>
                                    </li>
                                    <c:set var="startPage" value="${products.number - 2 < 0 ? 0 : products.number - 2}" />
                                    <c:set var="endPage" value="${products.number + 2 >= products.totalPages ? products.totalPages - 1 : products.number + 2}" />

                                    <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                        <c:if test="${i >= products.number - 2 && i <= products.number + 2}">
                                            <li class="page-item ${products.number == i ? 'active' : ''}">
                                                <a class="page-link" href="/products?page=${i}&search=${search}&startDate=${startDate}&endDate=${endDate}">${i + 1}</a>
                                            </li>
                                        </c:if>
                                    </c:forEach>

                                    <li class="page-item ${products.last ? 'disabled' : ''}">
                                        <a class="page-link" href="/products?page=${products.number + 1}&search=${search}&startDate=${startDate}&endDate=${endDate}">Next</a>
                                    </li>
                                </ul>
                            </nav>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<div class="modal fade" id="editProductModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <form class="modal-content" method="post" action="/products/update">
            <div class="modal-header">
                <h5 class="modal-title">Edit Product</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="productId" id="editProductId">
                <div class="mb-3">
                    <label class="form-label">Product Name</label>
                    <input type="text" class="form-control" name="productName" id="editProductName" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Item Code</label>
                    <input type="text" class="form-control" name="itemCode" id="editItemCode" required>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary">Update Product</button>
            </div>
        </form>
    </div>
</div>

<div class="modal fade" id="confirmDeleteModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <form class="modal-content" method="post" action="/products/delete">
            <div class="modal-header">
                <h5 class="modal-title">Delete Product</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="id" id="deleteProductId">
                <p>Are you sure you want to delete this product? This action cannot be undone.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-danger">Delete Now</button>
            </div>
        </form>
    </div>
</div>

<div class="modal fade" id="addProductModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <form class="modal-content" method="post" action="/products/add">
            <div class="modal-header">
                <h5 class="modal-title">New Product</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label">Product Name</label>
                    <input type="text" class="form-control" name="productName" required placeholder="Enter product name">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary">Save Product</button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Sidebar Toggle
    document.getElementById('openSidebar')?.addEventListener('click', () => {
        document.querySelector('.sidebar').classList.add('open');
    });

    // Populate Edit Modal
    const editModal = document.getElementById('editProductModal');
    editModal.addEventListener('show.bs.modal', event => {
        const btn = event.relatedTarget;
        document.getElementById('editProductId').value = btn.getAttribute('data-id');
        document.getElementById('editProductName').value = btn.getAttribute('data-name');
        document.getElementById('editItemCode').value = btn.getAttribute('data-code');
    });

    // Populate Delete Modal
    const deleteModal = document.getElementById('confirmDeleteModal');
    deleteModal.addEventListener('show.bs.modal', event => {
        const btn = event.relatedTarget;
        document.getElementById('deleteProductId').value = btn.getAttribute('data-id');
    });
</script>
</body>
</html>