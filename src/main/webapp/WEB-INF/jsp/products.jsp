<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page isELIgnored="true" %>
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
                <h1 class="h5 mb-0">Product Catalog</h1>
                <div class="d-flex align-items-center gap-2">
                    <button class="btn btn-outline-secondary d-lg-none" id="openSidebar"><i class="fa-solid fa-bars"></i></button>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addProductModal">
                        <i class="fas fa-plus me-1"></i> Add Product
                    </button>
                </div>
            </div>
        </div>

        <div class="container-fluid py-4">
            <div class="row g-3 mb-4">
                <div class="col-md-3">
                    <div class="card p-3 h-100">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="text-muted-small">Total Products</div>
                                <div class="h3 mb-0 text-primary" id="totalCount">0</div>
                            </div>
                            <div class="bg-primary bg-opacity-10 p-3 rounded">
                                <i class="fa-solid fa-box-open fa-xl text-primary"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-9">
                    <div class="card p-3">
                        <div class="row g-2">
                            <div class="col-md-6">
                                <label class="text-muted-small mb-1">Search Products</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white"><i class="fa-solid fa-magnifying-glass text-muted"></i></span>
                                    <input type="text" id="productSearch" class="form-control" placeholder="Search name or code...">
                                </div>
                            </div>
                            <div class="col-md-3">
                                <label class="text-muted-small mb-1">Start Date</label>
                                <input type="date" id="startDate" class="form-control">
                            </div>
                            <div class="col-md-3">
                                <label class="text-muted-small mb-1">End Date</label>
                                <input type="date" id="endDate" class="form-control">
                            </div>
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
                                    <th class="ps-3">#</th>
                                    <th>Product Name</th>
                                    <th>Item Code</th>
                                    <th>Created At</th>
                                    <th class="text-end pe-3">Actions</th>
                                </tr>
                            </thead>
                            <tbody id="productTableBody">
                                <tr><td colspan="5" class="text-center py-5">Loading products...</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="card-footer bg-white py-3">
                    <div id="paginationInfo" class="text-muted-small"></div>
                </div>
            </div>
        </div>
    </main>
</div>

<div class="modal fade" id="addProductModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <form class="modal-content" id="addProductForm">
            <div class="modal-header">
                <h5 class="modal-title">New Product</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label">Product Name</label>
                    <input type="text" class="form-control" name="productName" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Item Code</label>
                    <input type="text" class="form-control" name="itemCode" required placeholder="e.g. ITEM-001">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary">Save Product</button>
            </div>
        </form>
    </div>
</div>

<div class="modal fade" id="editProductModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <form class="modal-content" id="editProductForm">
            <input type="hidden" name="productId" id="editProductId">
            <input type="hidden" name="version" id="editVersion">
            <div class="modal-header border-bottom-0">
                <h5 class="modal-title">Edit Product</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label text-muted-small">Product Name</label>
                    <input type="text" class="form-control" name="productName" id="editProductName" required>
                </div>
                <div class="mb-3">
                    <label class="form-label text-muted-small">Item Code</label>
                    <input type="text" class="form-control" name="itemCode" id="editItemCode" required>
                </div>
            </div>
            <div class="modal-footer border-top-0">
                <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary">Update Changes</button>
            </div>
        </form>
    </div>

</div>

<div class="modal fade" id="confirmDeleteModal" tabindex="-1">
    <div class="modal-dialog modal-sm modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-body text-center p-4">
                <i class="fa-solid fa-circle-exclamation fa-3x text-danger mb-3"></i>
                <h5>Delete Product?</h5>
                <p class="text-muted small">This action cannot be undone.</p>
                <input type="hidden" id="deleteProductId">
                <div class="d-flex gap-2 justify-content-center mt-4">
                    <button class="btn btn-light flex-grow-1" data-bs-dismiss="modal">Cancel</button>
                    <button class="btn btn-danger flex-grow-1" id="confirmDeleteBtn">Delete</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>

const API = '/api/products';
let currentPage = 0;

async function loadProducts(page = 0) {
    currentPage = page;
    const search = document.getElementById('productSearch').value;
    const startDate = document.getElementById('startDate').value;
    const endDate = document.getElementById('endDate').value;


    const params = new URLSearchParams({
        page: page,
        size: 20,
        search: search || '',
        startDate: startDate || '',
        endDate: endDate || ''
    });


    try {
        const res = await fetch(`${API}?${params.toString()}`);
        if (!res.ok) throw new Error("Failed to fetch");

        const pageData = await res.json();
           console.log(pageData);
        console.log(pageData.data.content);
        renderTable(pageData.data.content);
        updatePaginationUI(pageData.data);

        document.getElementById('totalCount').innerText = pageData.data.totalElements;


    } catch (err) {
        console.error("Error:", err);
        document.getElementById('productTableBody').innerHTML =
            `<tr><td colspan="5" class="text-center text-danger">Error connecting to API.</td></tr>`;
    }
}

function renderTable(list) {
    const body = document.getElementById('productTableBody');
    console.log(list)
    if (!list || list.length === 0) {
        body.innerHTML = `<tr><td colspan="5" class="text-center py-5 text-muted">No products found.</td></tr>`;
        return;
    }

    body.innerHTML = list.map((p, i) => `
        <tr>
            <td class="ps-3 text-muted fw-medium">${(currentPage * 20) + (i + 1)}</td>
            <td class="truncate"><strong>${p.productName}</strong></td>
            <td><span class="badge badge-soft border text-dark">${p.itemCode}</span></td>
            <td class="text-muted-small">${p.createdAt ? p.createdAt : 'N/A'}</td>
            <td class="text-end pe-3">
                <button class="btn btn-sm btn-outline-info me-1 edit-trigger"
                    data-version="${p.version}" data-id="${p.productId}"
                    data-name="${p.productName}" data-code="${p.itemCode}">
                    <i class="fas fa-edit"></i>
                </button>
                <button class="btn btn-sm btn-outline-danger delete-trigger" data-id="${p.productId}">
                    <i class="fas fa-trash"></i>
                </button>
            </td>
        </tr>
    `).join('');
}

function updatePaginationUI(data) {
    const info = document.getElementById('paginationInfo');


    if (!data) {
        info.innerHTML = "";
        return;
    }

    const currentPageNum = data.number;
    const totalPages = data.totalPages;
    const totalElements = data.totalElements;

    info.innerHTML = `
        <div class="d-flex justify-content-between align-items-center">
            <div>
                Showing page <strong>${currentPageNum + 1}</strong> of <strong>${totalPages}</strong>
                <span class="text-muted ms-2">(${totalElements} total items)</span>
            </div>
            <div class="btn-group">
                <button class="btn btn-sm btn-outline-primary"
                    ${data.first ? 'disabled' : ''}
                    onclick="loadProducts(${currentPageNum - 1})">
                    <i class="fas fa-chevron-left me-1"></i> Previous
                </button>
                <button class="btn btn-sm btn-outline-primary"
                    ${data.last ? 'disabled' : ''}
                    onclick="loadProducts(${currentPageNum + 1})">
                    Next <i class="fas fa-chevron-right ms-1"></i>
                </button>
            </div>
        </div>
    `;
}

document.getElementById('productSearch').addEventListener('input', debounce(() => loadProducts(0), 500));
document.getElementById('startDate').addEventListener('change', () => loadProducts(0));
document.getElementById('endDate').addEventListener('change', () => loadProducts(0));

function debounce(func, timeout = 300) {
    let timer;
    return (...args) => {
        clearTimeout(timer);
        timer = setTimeout(() => { func.apply(this, args); }, timeout);
    };
}

document.getElementById('productTableBody').addEventListener('click', e => {
    // 1. Handle Edit Button Click
    const editBtn = e.target.closest('.edit-trigger');
    if (editBtn) {
        document.getElementById('editProductId').value = editBtn.dataset.id;
        document.getElementById('editVersion').value = editBtn.dataset.version;
        document.getElementById('editProductName').value = editBtn.dataset.name;
        document.getElementById('editItemCode').value = editBtn.dataset.code;
        new bootstrap.Modal(document.getElementById('editProductModal')).show();
    }


    const delBtn = e.target.closest('.delete-trigger');
    if (delBtn) {
        document.getElementById('deleteProductId').value = delBtn.dataset.id;
        new bootstrap.Modal(document.getElementById('confirmDeleteModal')).show();
    }
});

document.getElementById('addProductForm').onsubmit = async (e) => {
    e.preventDefault();
    const data = Object.fromEntries(new FormData(e.target));
    const res = await fetch(API, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    });
    if(res.ok) {
        bootstrap.Modal.getInstance(document.getElementById('addProductModal')).hide();
        e.target.reset();
        loadProducts(0);
    }
};

document.getElementById('editProductForm').onsubmit = async (e) => {
    e.preventDefault();
    const formData = new FormData(e.target);
    const id = formData.get('productId');
    const data = Object.fromEntries(formData);

    const res = await fetch(`${API}/${id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    });
    if(res.ok) {
        bootstrap.Modal.getInstance(document.getElementById('editProductModal')).hide();
        loadProducts(currentPage);
    }
};

document.getElementById('confirmDeleteBtn').onclick = async () => {
    const id = document.getElementById('deleteProductId').value;
    const res = await fetch(`${API}/${id}`, { method: 'DELETE' });
    if(res.ok) {
        bootstrap.Modal.getInstance(document.getElementById('confirmDeleteModal')).hide();
        loadProducts(currentPage);
    }
};


loadProducts();
</script>
</body>
</html>