<%--
  Created by IntelliJ IDEA.
  User: tusharparmar
  Date: 21-01-2026
  Time: 16:04
  To change this template use File | Settings | File Templates.
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
        :root {
            --sidebar-width: 260px;
            --brand-colour: #0d6efd;
            --bg-soft: #f8f9fa;
            --card-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075);
        }

        html, body { height: 100%; }
        body { background-colour: var(--bg-soft); }

        .app-shell { display: grid; grid-template-columns: var(--sidebar-width) 1fr; min-height: 100vh; }
        .sidebar {
            background: #212529; colour: #fff; position: sticky; top: 0; height: 100vh; padding: 1rem;
            border-right: 1px solid rgba(255,255,255,0.08);
        }
        .sidebar .brand { font-weight: 700; letter-spacing: 0.3px; }
        .sidebar .nav-link { colour: #adb5bd; border-radius: .375rem; }
        .sidebar .nav-link.active, .sidebar .nav-link:hover { colour: #fff; background: rgba(255,255,255,0.08); }

        .main { padding: 0; display: flex; flex-direction: column; }
        .topbar { position: sticky; top: 0; z-index: 1030; background: #fff; border-bottom: 1px solid #e9ecef; }
        .topbar .container-fluid { padding: .75rem 1rem; }

        .card { border: none; box-shadow: var(--card-shadow); }
        .table thead { background-colour: #f1f3f5; }
        .badge-soft { background: #e9ecef; colour: #495057; }
        .text-muted-small { colour: #6c757d; font-size: .875rem; }
        .truncate { max-width: 250px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }

        @media (max-width: 992px) {
            .app-shell { grid-template-columns: 1fr; }
            .sidebar { position: fixed; left: -100%; width: var(--sidebar-width); transition: left .25s ease; z-index: 1050;}
            .sidebar.open { left: 0; }
        }
    </style>
</head>
<body>

<div class="app-shell">
    <nav class="sidebar">
        <div class="d-flex align-items-center justify-content-between mb-3">
            <div class="brand d-flex align-items-center gap-2">
                <i class="fa-solid fa-crown text-warning"></i>
                <span>Monarch ERP</span>
            </div>
            <button class="btn btn-sm btn-outline-light d-lg-none" id="toggleSidebar"><i class="fa-solid fa-bars"></i></button>
        </div>
        <ul class="nav nav-pills flex-column gap-1">
            <li class="nav-item"><a href="/products" class="nav-link"><i class="fas fa-box me-2"></i> Products</a></li>
            <li class="nav-item"><a href="/variants" class="nav-link active"><i class="fas fa-tags me-2"></i> Variants</a></li>
            <li class="nav-item"><a href="/inventory" class="nav-link"><i class="fas fa-chart-line me-2"></i> Inventory</a></li>
        </ul>
    </nav>

    <main class="main">
        <div class="topbar">
            <div class="container-fluid d-flex align-items-center justify-content-between">
                <div class="d-flex align-items-center gap-3">
                    <h1 class="h5 mb-0">Product Variants</h1>
                    <span class="text-muted-small">Manage SKU-level details and attributes</span>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addVariantModal">
                        <i class="fas fa-plus me-1"></i> Add Variant
                    </button>
                </div>
            </div>
        </div>

        <div class="container-fluid py-4">
            <div class="card mb-4">
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-8">
                            <div class="input-group">
                                <span class="input-group-text bg-white border-end-0"><i class="fa-solid fa-magnifying-glass text-muted"></i></span>
                                <input type="search" class="form-control border-start-0" id="variantSearch" placeholder="Search by SKU or Variant name...">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <select class="form-select" id="productFilter">
                                <option value="">All Parent Products</option>
                                <c:forEach items="${parentProducts}" var="parent">
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
                                <th>Variant Id</th>
                                <th class="ps-3">SKU / Code</th>
                                <th>Parent Product</th>
                                <th>Attributes</th>
                                <th>MRP</th>
                                <th>Sellling Price</th>
                                <th class="text-end pe-3">Actions</th>
                            </tr>
                            </thead>
                            <tbody id="variantTableBody">
                            <c:forEach items="${variants}" var="variant">
                                <tr data-parent="${variant.product.productName}">
                                    <td class="truncate"><strong><c:out value="${variant.variantId}"/></strong></td>
                                    <td class="ps-3">
                                        <span class="badge badge-soft text-primary"><c:out value="${variant.product.itemCode}"/></span>
                                    </td>
                                    <td class="truncate"><strong><c:out value="${variant.product.productName}"/></strong></td>
                                    <td>
                                        <span class="badge bg-light text-dark border"><c:out value="${variant.colour}"/></span>
                                        <span class="badge bg-light text-dark border"><c:out value="${variant.size}"/></span>
                                    </td>
                                    <td><c:out value="${variant.mrp.price}"/></td>
                                    <td><c:out value="${variant.sellingPrice.price}"/></td>
                                    <td class="text-end pe-3">
                                    <td class="text-end pe-3">
                                    <button class="btn btn-sm btn-outline-info me-1"
                                            data-bs-toggle="modal"
                                            data-bs-target="#editVariantModal"
                                            data-id="${variant.variantId}"
                                            data-productid="${variant.product.productId}"
                                            data-colour="${variant.colour}"
                                            data-size="${variant.size}"
                                            data-mrp="${variant.mrp.price}"
                                            data-sellingprice="${variant.sellingPrice.price}">
                                        <i class="fas fa-edit"></i>
                                    </button>

                                    <button class="btn btn-sm btn-outline-danger"
                                            data-bs-toggle="modal"
                                            data-bs-target="#confirmDeleteVariantModal"
                                            data-id="${variant.variantId}">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                    </td>
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
                        <c:forEach items="${parentProducts}" var="p">
                            <option value="${p.productId}">${p.productName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Variant Name</label>
                    <input type="hidden" name="product.productId" value="${product.productId}">
                    <input type="text" class="form-control" name="variantName" placeholder="e.g. XL - Midnight Blue" required>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Colour</label>
                        <input type="text" class="form-control" name="colour">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Size</label>
                        <input type="text" class="form-control" name="size">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">MRP</label>
                        <input type="text" class="form-control" name="mrp">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Selling Price</label>
                        <input type="text" class="form-control" name="sellingPrice">
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

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Colour</label>
                        <input type="text" class="form-control" name="colour" id="editVariantColour">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Size</label>
                        <input type="text" class="form-control" name="size" id="editVariantSize">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">MRP</label>
                        <input type="number" step="0.01" class="form-control" name="mrp" id="editVariantMrp">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Selling Price</label>
                        <input type="number" step="0.01" class="form-control" name="sellingPrice" id="editVariantSellingPrice">
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
            <div class="modal-header">
                <h5 class="modal-title">Delete Variant?</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="id" id="deleteVariantId">
                <p>This action cannot be undone. Are you sure?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-danger">Delete</button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Search & Parent Product Filter Logic
    const variantSearch = document.getElementById('variantSearch');
    const productFilter = document.getElementById('productFilter');
    const rows = document.querySelectorAll('#variantTableBody tr');

    function filterTable() {
        const query = variantSearch.value.toLowerCase();
        const product = productFilter.value;

        rows.forEach(row => {
            const text = row.innerText.toLowerCase();
            const parent = row.dataset.parent;
            const matchesSearch = text.includes(query);
            const matchesProduct = product === "" || parent === product;

            row.style.display = (matchesSearch && matchesProduct) ? '' : 'none';
        });
    }

    variantSearch.addEventListener('input', filterTable);
    productFilter.addEventListener('change', filterTable);

    // Sidebar Mobile Toggle
    document.getElementById('toggleSidebar')?.addEventListener('click', () => {
        document.querySelector('.sidebar').classList.toggle('open');
    });


    // Populate Edit Variant Modal
    const editVariantModal = document.getElementById('editVariantModal');
    editVariantModal?.addEventListener('show.bs.modal', event => {
        const btn = event.relatedTarget;

        // Extract info from data-* attributes
        document.getElementById('editVariantId').value = btn.getAttribute('data-id');
        // Note: You need to add data-productid to your edit button in the table
        document.getElementById('prdid').value = btn.getAttribute('data-productid');
        document.getElementById('editVariantColour').value = btn.getAttribute('data-colour');
        document.getElementById('editVariantSize').value = btn.getAttribute('data-size');
        document.getElementById('editVariantMrp').value = btn.getAttribute('data-mrp');
        document.getElementById('editVariantSellingPrice').value = btn.getAttribute('data-sellingprice');
    });

    // Populate Delete Variant Modal
    const deleteVariantModal = document.getElementById('confirmDeleteVariantModal');
    deleteVariantModal?.addEventListener('show.bs.modal', event => {
        const btn = event.relatedTarget;
        document.getElementById('deleteVariantId').value = btn.getAttribute('data-id');
    });
</script>
</body>
</html>