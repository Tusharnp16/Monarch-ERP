<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Monarch ERP | Customer Management</title>
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
        html, body { height: 100%; }
        body { background-color: var(--bg-soft); font-family: 'Inter', sans-serif; }
        .app-shell { display: grid; grid-template-columns: var(--sidebar-width) 1fr; min-height: 100vh; }
        .sidebar { background: #212529; color: #fff; position: sticky; top: 0; height: 100vh; padding: 1rem; border-right: 1px solid rgba(255, 255, 255, 0.08); }
        .main { display: flex; flex-direction: column; }
        .topbar { position: sticky; top: 0; z-index: 1030; background: #fff; border-bottom: 1px solid #e9ecef; padding: .75rem 1rem; }
        .card { border: none; box-shadow: var(--card-shadow); border-radius: 0.5rem; }
        .table thead { background-color: #f1f3f5; font-size: 0.85rem; }
        .customer-avatar {
            width: 38px; height: 38px; background: #e9ecef; color: #495057;
            display: flex; align-items: center; justify-content: center;
            border-radius: 50%; font-weight: 600; font-size: 0.9rem;
        }
        .toast-container { z-index: 2000; }
        @media (max-width: 992px) { .app-shell { grid-template-columns: 1fr; } .sidebar { display: none; } }
    </style>
</head>
<body>

<div class="app-shell">
    <%@ include file="/WEB-INF/fragments/sidebar.html" %>

    <main class="main">
        <div class="topbar d-flex justify-content-between align-items-center">
            <h1 class="h5 mb-0">Customers & Directory</h1>
            <button class="btn btn-primary shadow-sm" data-bs-toggle="modal" data-bs-target="#addCustomerModal">
                <i class="fas fa-user-plus me-1"></i> Add Customer
            </button>
        </div>

        <div class="container-fluid py-4">
            <div class="card mb-4">
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-8">
                            <div class="input-group">
                                <span class="input-group-text bg-white border-end-0"><i class="fa-solid fa-magnifying-glass text-muted"></i></span>
                                <input type="text" class="form-control border-start-0" id="customerSearch" placeholder="Search by name, mobile or email...">
                            </div>
                        </div>
                        <div class="col-md-4 text-end">
                            <div class="text-muted-small">Total Customers: <span id="totalCount" class="fw-bold text-dark">0</span></div>
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
                                <th class="ps-3" style="width: 50px;">#</th>
                                <th>Customer Name</th>
                                <th>Mobile Number</th>
                                <th>Email</th>
                                <th>GST Code</th>
                                <th class="text-end pe-3">Actions</th>
                            </tr>
                            </thead>
                            <tbody id="customerTableBody">
                                <tr><td colspan="6" class="text-center py-5"><div class="spinner-border spinner-border-sm text-primary"></div> Loading...</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<div class="modal fade" id="addCustomerModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <form class="modal-content needs-validation" id="addCustomerForm" novalidate>
            <div class="modal-header">
                <h5 class="modal-title">New Customer Entry</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label fw-semibold">Full Name</label>
                    <input type="text" class="form-control" name="name" required maxlength="100">
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Mobile Number</label>
                    <input type="tel" class="form-control" name="mobile" required pattern="\d{10}">
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Email</label>
                    <input type="email" class="form-control" name="email" required>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold">GST State Code</label>
                    <input type="number" class="form-control" name="gstIn" required min="1" max="99">
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary w-100">Save Customer</button>
            </div>
        </form>
    </div>
</div>

<div class="modal fade" id="editCustomerModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <form class="modal-content" id="editCustomerForm">
            <div class="modal-header">
                <h5 class="modal-title">Edit Customer</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="id" id="editId">
                <div class="mb-3">
                    <label class="form-label fw-semibold">Full Name</label>
                    <input type="text" class="form-control" name="name" id="editName" required>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Mobile Number</label>
                    <input type="text" class="form-control" name="mobile" id="editMobile" required pattern="\d{10}">
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Email</label>
                    <input type="email" class="form-control" name="email" id="editEmail" required>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold">GST State Code</label>
                    <input type="number" class="form-control" name="gstIn" id="editGst" required>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary w-100">Update Customer</button>
            </div>
        </form>
    </div>
</div>

<div class="modal fade" id="confirmDeleteModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Delete Customer</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">Are you sure you want to remove this customer from the directory?</div>
            <div class="modal-footer">
                <input type="hidden" id="deleteCustomerId">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-danger" onclick="deleteCustomer()">Confirm Delete</button>
            </div>
        </div>
    </div>
</div>

<div class="toast-container position-fixed bottom-0 end-0 p-3">
    <div id="liveToast" class="toast hide" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="toast-header">
            <strong class="me-auto" id="toastTitle">Notification</strong>
            <button type="button" class="btn-close" data-bs-dismiss="toast"></button>
        </div>
        <div class="toast-body" id="toastMessage"></div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    const API_URL = '/api/customers';
    const toast = new bootstrap.Toast(document.getElementById('liveToast'));

    function showNotification(msg, isError = false) {
        document.getElementById('toastTitle').innerText = isError ? 'Error' : 'Success';
        document.getElementById('toastTitle').className = isError ? 'me-auto text-danger' : 'me-auto text-success';
        document.getElementById('toastMessage').innerText = msg;
        toast.show();
    }

    async function loadCustomers() {
        try {
            const response = await fetch(API_URL);
            const res = await response.json();
            if (res.success) {
                renderTable(res.data);
                document.getElementById('totalCount').innerText = res.data.length;
            }
        } catch (err) {
            showNotification("Failed to connect to server", true);
        }
    }

    function renderTable(customers) {
        const tbody = document.getElementById('customerTableBody');
        if (customers.length === 0) {
            tbody.innerHTML = '<tr><td colspan="6" class="text-center py-4 text-muted">No customers found.</td></tr>';
            return;
        }

        tbody.innerHTML = customers.map(c => {
            const avatar = c.name ? c.name.charAt(0).toUpperCase() : '?';
            const formattedGst = String(c.gstIn || 0).padStart(2, '0');
            return `
                <tr>
                    <td class="ps-3 text-muted-small">${c.customerId || c.id}</td>
                    <td>
                        <div class="d-flex align-items-center gap-3">
                            <div class="customer-avatar">${avatar}</div>
                            <div class="fw-bold">${c.name}</div>
                        </div>
                    </td>
                    <td><i class="fa-solid fa-phone-flip text-muted me-2 small"></i>${c.mobile}</td>
                    <td class="small text-muted">${c.email}</td>
                    <td><span class="badge bg-light text-dark border">Code: ${formattedGst}</span></td>
                    <td class="text-end pe-3">
                        <button class="btn btn-sm btn-outline-info"
                        onclick='openEditModal(${JSON.stringify(c)})'>
                            <i class="fas fa-pencil-alt"></i>
                        </button>
                        <button class="btn btn-sm btn-outline-danger ms-1" onclick="openDeleteModal(${c.customerId || c.id})">
                            <i class="fas fa-trash"></i>
                        </button>
                    </td>
                </tr>
            `;
        }).join('');
    }

    // 3. Form Submissions
    document.getElementById('addCustomerForm').addEventListener('submit', async (e) => {
        e.preventDefault();
        if (!e.target.checkValidity()) { e.target.classList.add('was-validated'); return; }

        const data = Object.fromEntries(new FormData(e.target));
        const res = await fetch(`${API_URL}/add`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        });
        const result = await res.json();

        if (res.ok && result.success) {
            bootstrap.Modal.getInstance(document.getElementById('addCustomerModal')).hide();
            e.target.reset();
            e.target.classList.remove('was-validated');
            showNotification(result.message);
            loadCustomers();
        } else {
            showNotification(result.message || "Error adding customer", true);
        }
    });

    document.getElementById('editCustomerForm').addEventListener('submit', async (e) => {
        e.preventDefault();
         const id = document.getElementById('editId').value;
        const data = Object.fromEntries(new FormData(e.target));
        const res = await fetch(`${API_URL}/update`, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        });
        const result = await res.json();

        if (res.ok) {
            bootstrap.Modal.getInstance(document.getElementById('editCustomerModal')).hide();
            showNotification("Customer updated successfully");
            loadCustomers();
        } else {
            showNotification(result.message || "Update failed", true);
        }
    });

    async function deleteCustomer() {
        const id = document.getElementById('deleteCustomerId').value;
        const res = await fetch(`${API_URL}/delete`, { method: 'DELETE' });
        if (res.ok) {
            bootstrap.Modal.getInstance(document.getElementById('confirmDeleteModal')).hide();
            showNotification("Customer removed successfully");
            loadCustomers();
        }
    }

    // Helpers
    function openEditModal(c) {
    console.log(c);
        document.getElementById('editId').value = c.customerId || c.id;
        document.getElementById('editName').value = c.name;
        document.getElementById('editMobile').value = c.mobile;
        document.getElementById('editEmail').value = c.email;
        document.getElementById('editGst').value = c.gstIn;
        new bootstrap.Modal(document.getElementById('editCustomerModal')).show();
    }

    function openDeleteModal(id) {
        document.getElementById('deleteCustomerId').value = id;
        new bootstrap.Modal(document.getElementById('confirmDeleteModal')).show();
    }

    document.getElementById('customerSearch').addEventListener('input', (e) => {
        const term = e.target.value.toLowerCase();
        document.querySelectorAll('#customerTableBody tr').forEach(row => {
            row.style.display = row.innerText.toLowerCase().includes(term) ? '' : 'none';
        });
    });

    // Initial load
    loadCustomers();
</script>

</body>
</html>