<%--
  Created by IntelliJ IDEA.
  User: tusharparmar
  Date: 22-01-2026
  Time: 17:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Monarch ERP | Contact Management</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

  <style>
    :root {
      --sidebar-width: 260px;
      --brand-color: #0d6efd;
      --bg-soft: #f8f9fa;
      --card-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075);
    }

    html, body { height: 100%; }
    body { background-color: var(--bg-soft); font-family: 'Inter', sans-serif; }

    .app-shell { display: grid; grid-template-columns: var(--sidebar-width) 1fr; min-height: 100vh; }
    .sidebar { background: #212529; color: #fff; position: sticky; top: 0; height: 100vh; padding: 1rem; border-right: 1px solid rgba(255,255,255,0.08); }
    .sidebar .nav-link { color: #adb5bd; border-radius: .375rem; margin-bottom: 2px; }
    .sidebar .nav-link.active { color: #fff; background: rgba(255,255,255,0.08); }

    .main { display: flex; flex-direction: column; }
    .topbar { position: sticky; top: 0; z-index: 1030; background: #fff; border-bottom: 1px solid #e9ecef; padding: .75rem 1rem; }

    .card { border: none; box-shadow: var(--card-shadow); border-radius: 0.5rem; }
    .table thead { background-color: #f1f3f5; font-size: 0.85rem; }

    .contact-avatar {
      width: 38px; height: 38px; background: #e9ecef; color: #495057;
      display: flex; align-items: center; justify-content: center;
      border-radius: 50%; font-weight: 600; font-size: 0.9rem;
    }

    @media (max-width: 992px) {
      .app-shell { grid-template-columns: 1fr; }
      .sidebar { display: none; }
    }
  </style>
</head>
<body>

<div class="app-shell">

    <%@ include file="/WEB-INF/fragments/sidebar.html" %>

  <main class="main">
    <div class="topbar d-flex justify-content-between align-items-center">
      <h1 class="h5 mb-0">Contacts & Directory</h1>
      <button class="btn btn-primary shadow-sm" data-bs-toggle="modal" data-bs-target="#addContactModal">
        <i class="fas fa-user-plus me-1"></i> Add Contact
      </button>
    </div>

    <div class="container-fluid py-4">
      <div class="card mb-4">
        <div class="card-body">
          <div class="row g-3">
            <div class="col-md-8">
              <div class="input-group">
                <span class="input-group-text bg-white border-end-0"><i class="fa-solid fa-magnifying-glass text-muted"></i></span>
                <input type="text" class="form-control border-start-0" id="contactSearch" placeholder="Search by name or mobile number...">
              </div>
            </div>
            <div class="col-md-4 text-end">
              <div class="text-muted-small">Total Contacts: <span class="fw-bold text-dark">${contacts.size()}</span></div>
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
                <th>Contact Name</th>
                <th>Mobile Number</th>
                <th>GST State Code</th>
                <th>Created On</th>
                <th class="text-end pe-3">Actions</th>
              </tr>
              </thead>
              <tbody id="contactTableBody">
              <c:forEach items="${contacts}" var="c">
                <tr>
                  <td class="ps-3 text-muted-small">${c.contactId}</td>
                  <td>
                    <div class="d-flex align-items-center gap-3">
                      <div class="contact-avatar">
                          ${c.name.substring(0,1).toUpperCase()}
                      </div>
                      <div class="fw-bold">${c.name}</div>
                    </div>
                  </td>
                  <td>
                    <i class="fa-solid fa-phone-flip text-muted me-2 small"></i>
                      ${c.mobileno}
                  </td>
                  <td>
                                            <span class="badge bg-light text-dark border">
                                                Code: ${String.format("%02d", c.gstIn)}
                                            </span>
                  </td>
                  <td class="text-muted small">${c.createdDate}</td>
                  <td class="text-end pe-3">
                    <button class="btn btn-sm btn-outline-info"
                            data-bs-toggle="modal" data-bs-target="#editContactModal"
                            data-id="${c.contactId}" data-name="${c.name}"
                            data-mobile="${c.mobileno}" data-gst="${c.gstIn}">
                      <i class="fas fa-pencil-alt"></i>
                    </button>
                    <button class="btn btn-sm btn-outline-danger ms-1" onclick="deleteContact(${c.contactId})">
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

<div class="modal fade" id="addContactModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <form class="modal-content needs-validation" novalidate method="post" action="/contact/add">
      <div class="modal-header">
        <h5 class="modal-title">New Contact Entry</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">

        <div class="mb-3">
          <label class="form-label fw-semibold">Full Name</label>
          <input type="text" class="form-control" name="name" placeholder="e.g. John Doe" required maxlength="100">
          <div class="invalid-feedback">Please enter a name (max 100 characters).</div>
        </div>

        <div class="mb-3">
          <label class="form-label fw-semibold">Mobile Number</label>
          <input type="number" class="form-control" name="mobileno" placeholder="10 digit mobile number">
          <div class="invalid-feedback">Please enter exactly 10 digits.</div>
        </div>

        <div class="mb-3">
          <label class="form-label fw-semibold">GST State Code (First 2 digits)</label>
          <input type="number" class="form-control" name="gstIn" placeholder="e.g. 24"
                 required min="1" max="99">
          <div class="invalid-feedback">Enter a valid 2-digit state code (01-99).</div>
          <div class="form-text">Example: 24 for Gujarat, 27 for Maharashtra.</div>
        </div>

      </div>
      <div class="modal-footer">
        <button type="submit" class="btn btn-primary w-100">Save Contact</button>
      </div>
    </form>
  </div>
</div>

<div class="modal fade" id="editContactModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <form class="modal-content" method="post" action="/contact/update">
      <div class="modal-header">
        <h5 class="modal-title">Edit Contact</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <input type="hidden" name="contactId" id="editId">
        <div class="mb-3">
          <label class="form-label fw-semibold">Full Name</label>
          <input type="text" class="form-control" name="name" id="editName" required>
        </div>
        <div class="mb-3">
          <label class="form-label fw-semibold">Mobile Number</label>
          <input type="text" class="form-control" name="mobileno" id="editMobile" required pattern="\d{10}">
        </div>
        <div class="mb-3">
          <label class="form-label fw-semibold">GST State Code</label>
          <input type="number" class="form-control" name="gstIn" id="editGst" required>
        </div>
      </div>
      <div class="modal-footer">
        <button type="submit" class="btn btn-primary">Update Contact</button>
      </div>
    </form>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // Search Functionality
  document.getElementById('contactSearch')?.addEventListener('input', function(e) {
    const term = e.target.value.toLowerCase();
    document.querySelectorAll('#contactTableBody tr').forEach(row => {
      row.style.display = row.innerText.toLowerCase().includes(term) ? '' : 'none';
    });
  });

  // Populate Edit Modal
  const editModal = document.getElementById('editContactModal');
  editModal.addEventListener('show.bs.modal', function (event) {
    const btn = event.relatedTarget;
    document.getElementById('editId').value = btn.getAttribute('data-id');
    document.getElementById('editName').value = btn.getAttribute('data-name');
    document.getElementById('editMobile').value = btn.getAttribute('data-mobile');
    document.getElementById('editGst').value = btn.getAttribute('data-gst');
  });

  function deleteContact(id) {
    if(confirm('Are you sure you want to remove this contact?')) {
      window.location.href = '/contact/delete/' + id;
    }
  }

    (() => {
    'use strict'

    // Fetch all the forms we want to apply custom Bootstrap validation styles to
    const forms = document.querySelectorAll('.needs-validation')

    // Loop over them and prevent submission
    Array.from(forms).forEach(form => {
    form.addEventListener('submit', event => {
    if (!form.checkValidity()) {
    event.preventDefault()
    event.stopPropagation()
  }

    form.classList.add('was-validated')
  }, false)
  })
  })()
</script>

</body>
</html>
