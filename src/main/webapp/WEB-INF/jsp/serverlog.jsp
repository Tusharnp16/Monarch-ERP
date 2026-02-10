<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ page isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Monarch ERP | System Logs</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        :root { --sidebar-width: 260px; --bg-soft: #f8f9fa; --card-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075); }
        body { background-color: var(--bg-soft); min-height: 100vh; }
        .app-shell { display: grid; grid-template-columns: var(--sidebar-width) 1fr; min-height: 100vh; }

        /* Main Layout Parts */
        .sidebar { background: #212529; color: #fff; position: sticky; top: 0; height: 100vh; padding: 1rem; }
        .topbar { position: sticky; top: 0; z-index: 1030; background: #fff; border-bottom: 1px solid #e9ecef; padding: .75rem 1rem; }

        /* Table Styling */
        .card { border: none; box-shadow: var(--card-shadow); border-radius: 10px; }
        .table thead { background-color: #f1f3f5; color: #495057; text-transform: uppercase; font-size: 0.85rem; letter-spacing: 0.5px; }
        .log-icon-box { width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; border-radius: 8px; background: #e7f1ff; color: #0d6efd; }
        .text-muted-small { color: #6c757d; font-size: .875rem; }

        @media (max-width: 992px) { .app-shell { grid-template-columns: 1fr; } .sidebar { display: none; } }
    </style>
</head>
<body>

<div class="app-shell">
    <%-- Reusing your existing sidebar fragment --%>
    <%@ include file="/WEB-INF/fragments/sidebar.html" %>

    <main class="main">
        <div class="topbar d-flex align-items-center justify-content-between">
            <h1 class="h5 mb-0"><i class="fa-solid fa-clock-rotate-left me-2 text-primary"></i>Login History</h1>
            <div class="d-flex align-items-center gap-3">
                <span class="badge bg-light text-dark border">User: <span id="currentUserName"></span></span>
                <button class="btn btn-sm btn-outline-secondary" onclick="window.location.reload()"><i class="fa-solid fa-sync"></i> Refresh</button>
            </div>
        </div>

        <div class="container-fluid py-4">

            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="card p-3 d-flex flex-row align-items-center gap-3">
                        <div class="log-icon-box">
                            <i class="fa-solid fa-shield-halved"></i>
                        </div>
                        <div>
                            <div class="text-muted-small">Total Sessions</div>
                            <div id="totalSessionsCount" class="h4 mb-0 fw-bold">0</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-header bg-white py-3">
                    <h6 class="mb-0 fw-bold">Recent Activity</h6>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                                <tr>
                                    <th class="ps-4" style="width: 100px;">No.</th>
                                    <th>Login Timestamp</th>
                                    <th>Status</th>
                                    <th class="text-end pe-4">Device/IP</th>
                                </tr>
                            </thead>
                            <tbody id="loginLogTableBody">
                                <tr>
                                    <td colspan="4" class="text-center py-5">
                                        <div class="spinner-border text-primary" role="status"></div>
                                        <p class="mt-2">Loading logs...</p>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="card-footer bg-white text-center py-3">
                    <p class="text-muted-small mb-0">Security Note: If you don't recognize a login session, change your password immediately.</p>
                </div>
            </div>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>

const API = '/api/userlogs';
document.addEventListener('DOMContentLoaded', loadServerLog);

async function loadServerLog() {
    try {
        const res = await fetch(API);
        const result = await res.json();

        if (result.success && Array.isArray(result.data)) {
            const logs = result.data;

            const counterEl = document.getElementById('totalSessionsCount');
            if(counterEl) counterEl.innerText = logs.length;

             document.getElementById('currentUserName').innerText=logs[0].username;

            renderTable(logs);
        } else {
            throw new Error("Data format incorrect");
        }
    } catch (err) {
        console.error("Load failed:", err);
        document.getElementById('loginLogTableBody').innerHTML =
            `<tr><td colspan="4" class="text-center text-danger">Error loading data. Check console.</td></tr>`;
    }
}

function renderTable(list) {
    const body = document.getElementById('loginLogTableBody');

    if (!list || list.length === 0) {
        body.innerHTML = '<tr><td colspan="4" class="text-center py-5">No login history found.</td></tr>';
        return;
    }

    body.innerHTML = list.map((log, i) => {
        // Format the date (assuming log.loginTime is an ISO string)
        const date = new Date(log.loginTime);
        const dateStr = date.toLocaleDateString();
        const timeStr = date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });

        return `
            <tr>
                <td class="ps-4 fw-bold text-muted">${i + 1}</td>
                <td>
                    <div class="d-flex align-items-center gap-2">
                        <i class="fa-regular fa-calendar-check text-success"></i>
                        ${dateStr} ${timeStr}
                    </div>
                </td>
                <td>
                    <span class="badge rounded-pill bg-success-subtle text-success border border-success-subtle">Success</span>
                </td>
                <td class="text-end pe-4">
                    <span class="text-muted-small"><i class="fa-solid fa-display me-1"></i> ${log.loginIp || 'Unknown'}</span>
                </td>
            </tr>
        `;
    }).join('');
}




</script>
</body>
</html>