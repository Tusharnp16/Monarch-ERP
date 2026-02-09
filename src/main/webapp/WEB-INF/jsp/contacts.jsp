<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="true" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Monarch ERP | Contact Management</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        :root { --sidebar-width:260px; --bg-soft:#f8f9fa; }
        body { background:var(--bg-soft); }
        .app-shell { display:grid; grid-template-columns:var(--sidebar-width) 1fr; min-height:100vh; }
        @media(max-width:992px){ .app-shell{grid-template-columns:1fr} }
    </style>
</head>

<body>
<div class="app-shell">
    <%@ include file="/WEB-INF/fragments/sidebar.html" %>

    <main>
        <div class="d-flex justify-content-between align-items-center p-3 bg-white border-bottom">
            <h5 class="mb-0">Contacts</h5>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addContactModal">
                <i class="fa fa-user-plus me-1"></i> Add Contact
            </button>
        </div>

        <div class="container-fluid p-4">
            <div class="card mb-3">
                <div class="card-body d-flex justify-content-between">
                    <input id="contactSearch" class="form-control w-50" placeholder="Search">
                    <span>Total: <b id="totalCount">0</b></span>
                </div>
            </div>

            <div class="card">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th>#</th><th>Name</th><th>Mobile</th><th>GST</th><th class="text-end">Actions</th>
                    </tr>
                    </thead>
                    <tbody id="contactTableBody">
                        <tr><td colspan="5" class="text-center">Loading...</td></tr>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<div class="modal fade" id="addContactModal">
    <div class="modal-dialog">
        <form class="modal-content" id="addContactForm">
            <div class="modal-header"><h5>Add Contact</h5></div>
            <div class="modal-body">
                <input name="name" class="form-control mb-2" placeholder="Name" required>
                <input name="mobileno" class="form-control mb-2" placeholder="Mobile" required>
                <input name="gstIn" class="form-control" placeholder="GST Code" required>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary w-100">Save</button>
            </div>
        </form>
    </div>
</div>

<!-- EDIT Contact Modal -->
<div class="modal fade" id="editContactModal">
    <div class="modal-dialog">
        <form class="modal-content" id="editContactForm">
            <input type="hidden" name="contactId" id="editId">
            <div class="modal-header"><h5>Edit Contact</h5></div>
            <div class="modal-body">
                <input id="editName" name="name" class="form-control mb-2" required>
                <input id="editMobile" name="mobileno" class="form-control mb-2" required>
                <input id="editGst" name="gstIn" class="form-control" required>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary w-100">Update</button>
            </div>
        </form>
    </div>
</div>

<!-- DELETE Confirmation Modal -->
<div class="modal fade" id="confirmDeleteModal">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-body text-center">
                Are you sure?
                <input type="hidden" id="deleteContactId">
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button class="btn btn-danger" id="confirmDeleteBtn">Delete</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
const API = '/api/contacts';

async function loadContacts() {
    try {
        const res = await fetch(API);
        const json = await res.json();
        const contactList = json.data || json;
        console.log("Rendering list:", contactList);
        render(Array.isArray(contactList) ? contactList : []);
    } catch (err) {
        console.error("Fetch error:", err);
        document.getElementById('contactTableBody').innerHTML =
            `<tr><td colspan="5" class="text-danger text-center">Failed to load data from server</td></tr>`;
    }
}

function render(list) {
    const body = document.getElementById('contactTableBody');
    const totalDisplay = document.getElementById('totalCount');

    if (!list || list.length === 0) {
        body.innerHTML = `<tr><td colspan="5" class="text-center">No contacts found</td></tr>`;
        totalDisplay.innerText = "0";
        return;
    }

    const html = list.map((c,i)=> `
        <tr>
            <td>${i + 1 ?? ''}</td>
            <td>${c.name ?? ''}</td>
            <td>${c.mobileno ?? ''}</td>
            <td>${c.gstIn ?? ''}</td>
            <td class="text-end">
                <button class="btn btn-sm btn-info edit-btn"
                    data-id="${c.contactId}"
                    data-name="${c.name}"
                    data-mobile="${c.mobileno}"
                    data-gst="${c.gstIn}">✏</button>
                <button class="btn btn-sm btn-danger delete-btn"
                    data-id="${c.contactId}">🗑</button>
            </td>
        </tr>`).join('');

    body.innerHTML = html;
    totalDisplay.innerText = list.length;
}

document.addEventListener('click', e => {
    const editBtn = e.target.closest('.edit-btn');
    if (editBtn) {
        editId.value = editBtn.dataset.id;
        editName.value = editBtn.dataset.name;
        editMobile.value = editBtn.dataset.mobile;
        editGst.value = editBtn.dataset.gst;
        new bootstrap.Modal(editContactModal).show();
    }

    const delBtn = e.target.closest('.delete-btn');
    if (delBtn) {
        deleteContactId.value = delBtn.dataset.id;
        new bootstrap.Modal(confirmDeleteModal).show();
    }
});

addContactForm.onsubmit = async e => {
    e.preventDefault();
    await fetch(API, {
        method:'POST',
        headers:{'Content-Type':'application/json'},
        body:JSON.stringify(Object.fromEntries(new FormData(e.target)))
    });
    bootstrap.Modal.getInstance(addContactModal).hide();
    e.target.reset();
    loadContacts();
};

editContactForm.onsubmit = async e => {
    e.preventDefault();
    const data = Object.fromEntries(new FormData(e.target));
    await fetch(`${API}/${data.contactId}`, {
        method:'PUT',
        headers:{'Content-Type':'application/json'},
        body:JSON.stringify(data)
    });
    bootstrap.Modal.getInstance(editContactModal).hide();
    loadContacts();
};

confirmDeleteBtn.onclick = async () => {
    await fetch(`${API}/${deleteContactId.value}`, { method:'DELETE' });
    bootstrap.Modal.getInstance(confirmDeleteModal).hide();
    loadContacts();
};

contactSearch.oninput = e => {
    const t = e.target.value.toLowerCase();
    document.querySelectorAll('#contactTableBody tr')
        .forEach(r => r.style.display = r.innerText.toLowerCase().includes(t) ? '' : 'none');
};

loadContacts();
</script>
</body>
</html>
