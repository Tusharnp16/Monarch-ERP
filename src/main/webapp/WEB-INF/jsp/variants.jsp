<%--
  Created by IntelliJ IDEA.
  User: tusharparmar
  Date: 21-01-2026
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Monarch ERP | Variant Management</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        :root { --sidebar-width: 260px; --brand-colour: #0d6efd; --bg-soft: #f8f9fa; --card-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075); }
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
        .badge-soft { background: #e9ecef; color: #495057; }
        .text-muted-small { color: #6c757d; font-size: .875rem; }
        .truncate { max-width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        @media (max-width: 992px) { .app-shell { grid-template-columns: 1fr; } .sidebar { position: fixed; left: -100%; width: var(--sidebar-width); transition: left .25s ease; z-index: 1050;} .sidebar.open { left: 0; } }
        /* Hide arrows for Chrome, Safari, Edge, Opera */
        input::-webkit-outer-spin-button, input::-webkit-inner-spin-button { -webkit-appearance: none; margin: 0; }
        /* Hide arrows for Firefox */
        input[type=number] { -moz-appearance: textfield; }
    </style>
</head>
<body>

<div class="app-shell">
    <%@ include file="/WEB-INF/fragments/sidebar.html" %>
    <main class="main">
        <div class="topbar">
            <div class="container-fluid d-flex align-items-center justify-content-between">
                <div class="d-flex align-items-center gap-3">
                    <h1 class="h5 mb-0">Product Variants</h1>
                    <span class="text-muted-small">Manage SKU-level details</span>
                </div>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addVariantModal">
                    <i class="fas fa-plus me-1"></i> Add Variant
                </button>
            </div>
        </div>

        <div class="container-fluid py-4">
            <div class="card mb-4">
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-8">
                            <div class="input-group">
                                <span class="input-group-text bg-white border-end-0"><i class="fa-solid fa-magnifying-glass text-muted"></i></span>
                                <input type="search" class="form-control border-start-0" id="variantSearch" placeholder="Search variants...">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <select class="form-select" id="productFilter">
                                <option value="">All Parent Products</option>
                                <c:forEach items="${parentProducts.content}" var="parent">
                                    <option value="${parent.productName}">${parent.productName}</option>
                                </c:forEach>
                            </select>
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
                                    <th>ID</th>
                                    <th>SKU</th>
                                    <th>Parent Product</th>
                                    <th>Variant Name</th>
                                    <th>Attributes</th>
                                    <th>MRP</th>
                                    <th>Selling Price</th>
                                    <th class="text-end pe-3">Actions</th>
                                </tr>
                            </thead>
                            <tbody id="variantTableBody">
                                <c:forEach items="${variants}" var="variant" varStatus="status">
                                    <tr data-parent="${variant.product.productName}">
                                        <td><strong>${status.index+1}</strong></td>
                                        <td><span class="badge badge-soft text-primary"><c:out value="${variant.product.itemCode}"/></span></td>
                                        <td class="truncate"><c:out value="${variant.product.productName}"/></td>
                                        <td class="truncate"><c:out value="${variant.variantName}"/></td>
                                        <td>
                                            <span class="badge bg-light text-dark border"><c:out value="${variant.colour}"/></span>
                                            <span class="badge bg-light text-dark border"><c:out value="${variant.size}"/></span>
                                        </td>
                                        <td>₹${variant.mrp.price}</td>
                                        <td>₹${variant.sellingPrice.price}</td>
                                        <td class="text-end pe-3">
                                            <button class="btn btn-sm btn-outline-info me-1" data-bs-toggle="modal" data-bs-target="#editVariantModal"
                                                    data-id="${variant.variantId}" data-productid="${variant.product.productId}"
                                                    data-name="${variant.variantName}" data-colour="${variant.colour}"
                                                    data-size="${variant.size}" data-mrp="${variant.mrp.price}"
                                                    data-sellingprice="${variant.sellingPrice.price}">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger" data-bs-toggle="modal" data-bs-target="#confirmDeleteVariantModal"
                                                    data-id="${variant.variantId}">
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

<div class="modal fade" id="addVariantModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <form class="modal-content needs-validation" novalidate method="post" action="/variants/add">
            <div class="modal-header">
                <h5 class="modal-title">Create New Variant</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label">Parent Product</label>
                    <select class="form-select" name="productId" required>
                        <option value="" selected disabled>Select Product</option>
                        <c:forEach items="${parentProducts.content}" var="p">
                            <option value="${p.productId}">${p.productName}</option>
                        </c:forEach>
                    </select>
                    <div class="invalid-feedback">Please select a parent product.</div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Variant Name</label>
                    <input type="text" class="form-control" name="variantName" placeholder="e.g. XL - Blue" required>
                    <div class="invalid-feedback">Name is required.</div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3"><label class="form-label">Colour</label><input type="text" class="form-control" name="colour" required></div>
                    <div class="col-md-6 mb-3"><label class="form-label">Size</label><input type="text" class="form-control" name="size" required></div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">MRP</label>
                        <input type="number" step="0.01" min="0" class="form-control price-input" name="mrp" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Selling Price</label>
                        <input type="number" step="0.01" min="0" class="form-control price-input selling-price" name="sellingPrice" required>
                        <div class="invalid-feedback">Selling price cannot exceed MRP.</div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary">Save Variant</button>
            </div>
        </form>
    </div>
</div>

<div class="modal fade" id="editVariantModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <form class="modal-content needs-validation" novalidate method="post" action="/variants/update">
            <div class="modal-header">
                <h5 class="modal-title">Edit Variant</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="variantId" id="editVariantId">
                <input type="hidden" name="productId" id="prdid">
                <div class="mb-3">
                    <label class="form-label">Variant Name</label>
                    <input type="text" class="form-control" name="variantName" id="editVariantName" required>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3"><label class="form-label">Colour</label><input type="text" class="form-control" name="colour" id="editVariantColour"></div>
                    <div class="col-md-6 mb-3"><label class="form-label">Size</label><input type="text" class="form-control" name="size" id="editVariantSize"></div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">MRP</label>
                        <input type="number" step="0.01" min="0" class="form-control price-input" name="mrp" id="editVariantMrp" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Selling Price</label>
                        <input type="number" step="0.01" min="0" class="form-control price-input selling-price" name="sellingPrice" id="editVariantSellingPrice" required>
                        <div class="invalid-feedback">Selling price cannot exceed MRP.</div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary">Update Variant</button>
            </div>
        </form>
    </div>
</div>

<div class="modal fade" id="confirmDeleteVariantModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <form class="modal-content" method="post" action="/variants/delete">
            <div class="modal-header"><h5 class="modal-title">Delete Variant?</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
            <div class="modal-body"><input type="hidden" name="id" id="deleteVariantId"><p>This action cannot be undone. Are you sure?</p></div>
            <div class="modal-footer"><button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button><button type="submit" class="btn btn-danger">Delete</button></div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Bootstrap Validation Logic
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

    // Block 'e', '+', '-' in numeric fields
    document.querySelectorAll('.price-input').forEach(input => {
        input.addEventListener('keydown', e => {
            if (["e", "E", "+", "-"].includes(e.key)) e.preventDefault();
        });
    });

    // Table Filtering
    const variantSearch = document.getElementById('variantSearch');
    const productFilter = document.getElementById('productFilter');
    const rows = document.querySelectorAll('#variantTableBody tr');

    function filterTable() {
        const query = variantSearch.value.toLowerCase();
        const product = productFilter.value;
        rows.forEach(row => {
            const text = row.innerText.toLowerCase();
            const parent = row.dataset.parent;
            row.style.display = (text.includes(query) && (product === "" || parent === product)) ? '' : 'none';
        });
    }
    variantSearch.addEventListener('input', filterTable);
    productFilter.addEventListener('change', filterTable);

    // Edit Modal Populating
    const editVariantModal = document.getElementById('editVariantModal');
    editVariantModal?.addEventListener('show.bs.modal', event => {
        const btn = event.relatedTarget;
        document.getElementById('editVariantId').value = btn.getAttribute('data-id');
        document.getElementById('prdid').value = btn.getAttribute('data-productid');
        document.getElementById('editVariantName').value = btn.getAttribute('data-name');
        document.getElementById('editVariantColour').value = btn.getAttribute('data-colour');
        document.getElementById('editVariantSize').value = btn.getAttribute('data-size');
        document.getElementById('editVariantMrp').value = btn.getAttribute('data-mrp');
        document.getElementById('editVariantSellingPrice').value = btn.getAttribute('data-sellingprice');
    });

    // Delete Modal Populating
    document.getElementById('confirmDeleteVariantModal')?.addEventListener('show.bs.modal', event => {
        document.getElementById('deleteVariantId').value = event.relatedTarget.getAttribute('data-id');
    });
</script>
</body>
</html>