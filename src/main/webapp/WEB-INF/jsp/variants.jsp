<%--
  Created by IntelliJ IDEA.
  User: tusharparmar
  Date: 21-01-2026
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Monarch ERP | Variant Management</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        :root { height: 100%; --sidebar-width: 260px; --brand-colour: #0d6efd; --bg-soft: #f8f9fa; --card-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075); }
        html, body { height: 100%; }
        body { background-color: var(--bg-soft); }
        .app-shell { display: grid; grid-template-columns: var(--sidebar-width) 1fr; min-height: 100vh; background-color: var(--bg-soft); }
        .main { padding: 0; display: flex; flex-direction: column; min-width: 0; background-color: var(--bg-soft); }
        .sidebar { background: #212529; color: #fff; position: sticky; top: 0; height: 100vh; padding: 1rem; border-right: 1px solid rgba(255, 255, 255, 0.08); }
        .topbar { position: sticky; top: 0; z-index: 1030; background: #fff; border-bottom: 1px solid #e9ecef; }
        .topbar .container-fluid { padding: .75rem 1rem; }
        .card { border: none; box-shadow: var(--card-shadow); }
        .table thead { background-color: #f1f3f5; }
        .badge-soft { background: #e9ecef; color: #495057; }
        .text-muted-small { color: #6c757d; font-size: .875rem; }
        .truncate { max-width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        @media (max-width: 992px) {
            .app-shell { grid-template-columns: 1fr; }
            .sidebar { position: fixed; left: -100%; width: var(--sidebar-width); transition: left .25s ease; z-index: 1050; }
            .sidebar.open { left: 0; }
        }
        input::-webkit-outer-spin-button, input::-webkit-inner-spin-button { -webkit-appearance: none; margin: 0; }
        input[type=number] { -moz-appearance: textfield; }
    </style>
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" rel="stylesheet" />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
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
                            <select class="form-select variant-select" id="productFilter">
                                <option value="">All Parent Products</option>
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
                                <tr><td colspan="8" class="text-center py-5">Loading variants...</td></tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="d-flex justify-content-between align-items-center p-3 border-top">
                        <div id="paginationInfo" class="text-muted-small"></div>
                        <nav>
                            <ul class="pagination mb-0">
                                <li class="page-item">
                                    <button class="btn btn-sm btn-outline-secondary me-2" onclick="loadVariants(0)">
                                        <i class="fas fa-angle-double-left"></i> First Page
                                    </button>
                                </li>
                                <li class="page-item" id="nextPageItem" style="display:none;">
                                    <button id="btnNext" class="page-link">Next <i class="fas fa-chevron-right ms-1"></i></button>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<div class="modal fade" id="addVariantModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <form class="modal-content needs-validation" id="addVariantForm" novalidate>
            <div class="modal-header">
                <h5 class="modal-title">Create New Variant</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label">Parent Product</label>
                       <select class="form-select variant-select" name="productId" required>
                                                    <option value="" selected disabled>Select Product</option>
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
                    <div class="col-md-6 mb-3"><label class="form-label">MRP</label><input type="number" step="0.01" min="0" class="form-control price-input" name="mrp" required></div>
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
        <form class="modal-content needs-validation" id="editVariantForm" novalidate>
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
                    <div class="col-md-6 mb-3"><label class="form-label">MRP</label><input type="number" step="0.01" min="0" class="form-control price-input" name="mrp" id="editVariantMrp" required></div>
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
        <div class="modal-content">
            <div class="modal-header"><h5 class="modal-title">Delete Variant?</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
            <div class="modal-body"><input type="hidden" id="deleteVariantId"><p>This action cannot be undone. Are you sure?</p></div>
            <div class="modal-footer">
                <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-danger" id="confirmDeleteBtn">Delete</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const API = '/api/variants';
    let rowCounter = 1;


    async function loadVariants(lastId = 0) {

        if (lastId === 0) {
            rowCounter = 1;
        }

        try {
            const res = await fetch(`${API}?lastId=${lastId}`);
            const result = await res.json();
            if (result.success) {
                renderTable(result.data.variants);
                updatePagination(result.data);
            }
        } catch (err) { console.error("Load failed:", err); }
    }

    function renderTable(list) {


        const body = document.getElementById('variantTableBody');
        if (!list || list.length === 0) {
            body.innerHTML = '<tr><td colspan="8" class="text-center py-5">No variants found.</td></tr>';
            return;
        }
        body.innerHTML = list.map((v, i) => `
            <tr data-parent="${v.product?.productName || ''}">
                <td><strong>${rowCounter++}</strong></td>
                <td><span class="badge badge-soft text-primary">${v.product?.itemCode || 'N/A'}</span></td>
                <td class="truncate">${v.product?.productName || 'N/A'}</td>
                <td class="truncate">${v.variantName}</td>
                <td><span class="badge bg-light text-dark border">${v.colour}</span> <span class="badge bg-light text-dark border">${v.size}</span></td>
                <td>₹${v.mrp?.price || 0}</td>
                <td>₹${v.sellingPrice?.price || 0}</td>
                <td class="text-end pe-3">
                    <button class="btn btn-sm btn-outline-info me-1" data-bs-toggle="modal" data-bs-target="#editVariantModal"
                        data-id="${v.variantId}" data-productid="${v.product?.productId}" data-name="${v.variantName}"
                        data-colour="${v.colour}" data-size="${v.size}" data-mrp="${v.mrp?.price || 0}" data-sellingprice="${v.sellingPrice?.price || 0}">
                        <i class="fas fa-edit"></i>
                    </button>
                    <button class="btn btn-sm btn-outline-danger" data-bs-toggle="modal" data-bs-target="#confirmDeleteVariantModal" data-id="${v.variantId}">
                        <i class="fas fa-trash"></i>
                    </button>
                </td>
            </tr>
        `).join('');
    }

    function updatePagination(data) {
        const nextItem = document.getElementById('nextPageItem');
        const btnNext = document.getElementById('btnNext');
        if (data.hasNext) {
            nextItem.style.display = 'block';
            btnNext.onclick = () => loadVariants(data.nextCursor);
        } else { nextItem.style.display = 'none'; }
    }

    // 1. Edit Variant Modal Listener
    const editModal = document.getElementById('editVariantModal');
    editModal?.addEventListener('show.bs.modal', event => {
        const btn = event.relatedTarget;

        // Get values from button attributes
        const productId = btn.getAttribute('data-productid');
        const productName = btn.getAttribute('data-parent'); // Ensure your table row has this!


        const editSelect = $('#editVariantModal select[name="productId"]');
        if (productId && productName) {
            // new Option(text, id, defaultSelected, selected)
            const newOption = new Option(productName, productId, true, true);
            editSelect.append(newOption).trigger('change');
        }
        // -----------------------------

        // Populate the rest of the hidden and text fields
        document.getElementById('editVariantId').value = btn.getAttribute('data-id');
        document.getElementById('prdid').value = productId;
        document.getElementById('editVariantName').value = btn.getAttribute('data-name');
        document.getElementById('editVariantColour').value = btn.getAttribute('data-colour');
        document.getElementById('editVariantSize').value = btn.getAttribute('data-size');
        document.getElementById('editVariantMrp').value = btn.getAttribute('data-mrp');
        document.getElementById('editVariantSellingPrice').value = btn.getAttribute('data-sellingprice');
    });

    // 2. Delete Confirmation Modal Listener
    document.getElementById('confirmDeleteVariantModal')?.addEventListener('show.bs.modal', event => {
        const btn = event.relatedTarget;
        document.getElementById('deleteVariantId').value = btn.getAttribute('data-id');
    });
    document.getElementById('confirmDeleteVariantModal')?.addEventListener('show.bs.modal', event => {
        document.getElementById('deleteVariantId').value = event.relatedTarget.getAttribute('data-id');
    });

 function loadParentProducts() {

     $('.variant-select').each(function() {
         var $element = $(this);

         var $modal = $element.closest('.modal');

         $element.select2({
             theme: 'bootstrap-5',
             width: '100%',
             placeholder: 'Search for a product...',
             allowClear: true,
             minimumInputLength: 5,
             dropdownParent: $modal.length ? $modal : $(document.body),
             ajax: {
                 url: '/api/products/compact',
                 dataType: 'json',
                 delay: 300,
                 data: function (params) {
                     return {
                         name: params.term
                     };
                 },
                 processResults: function (response) {
                     var items = response.data || [];
                     return {
                         results: items.map(function(p) {
                             return {
                                 id: p.productId,
                                 text: p.productName
                             };
                         })
                     };
                 },
                 cache: true
             }
         });
     });

     $('#productFilter').on('select2:select select2:unselect', function () {
         filterTable();
     });

     // Event listener for the table filter dropdown
     $('#productFilter').on('select2:select select2:unselect', function () {
         filterTable();
     });
 }
    const handleForm = (formId, method, urlFunc) => {
        const form = document.getElementById(formId);
        form.addEventListener('submit', async e => {
            e.preventDefault();
            const mrp = parseFloat(form.querySelector('input[name="mrp"]').value) || 0;
            const selling = parseFloat(form.querySelector('input[name="sellingPrice"]').value) || 0;
            const sellingInput = form.querySelector('input[name="sellingPrice"]');

            if (selling > mrp) {
                sellingInput.setCustomValidity("Selling price cannot exceed MRP");
            } else { sellingInput.setCustomValidity(""); }

            if (!form.checkValidity()) {
                e.stopPropagation();
            } else {
                const formData = new FormData(form);
                const productId = formData.get('productId');
                const id = formData.get('variantId');
                const res = await fetch(urlFunc(id, productId), {
                    method: method,
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(Object.fromEntries(formData))
                });
                if (res.ok) {
                    bootstrap.Modal.getInstance(form.closest('.modal')).hide();
                    loadVariants(0);
                }
            }
            form.classList.add('was-validated');
        });
    };

    handleForm('addVariantForm', 'POST', (id, pid) => `${API}?productId=${pid}`);
    handleForm('editVariantForm', 'PUT', (id, pid) => `${API}/${id}?productId=${pid}`);

    document.getElementById('confirmDeleteBtn').onclick = async () => {
        const id = document.getElementById('deleteVariantId').value;
        await fetch(`${API}/${id}`, { method: 'DELETE' });
        bootstrap.Modal.getInstance(document.getElementById('confirmDeleteVariantModal')).hide();
        loadVariants(0);
    };


    document.getElementById('variantSearch').oninput = filterTable;
    document.getElementById('productFilter').onchange = filterTable;

    function filterTable() {
        const query = document.getElementById('variantSearch').value.toLowerCase();
        const product = document.getElementById('productFilter').value;
        document.querySelectorAll('#variantTableBody tr').forEach(row => {
            const text = row.innerText.toLowerCase();
            const parent = row.dataset.parent;
            row.style.display = (text.includes(query) && (product === "" || parent === product)) ? '' : 'none';
        });
    }


    loadParentProducts();
    loadVariants();
</script>
</body>
</html>