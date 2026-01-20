<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Monarch ERP | Product Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .sidebar { height: 100vh; background: #212529; color: white; position: fixed; width: 240px; }
        .main-content { margin-left: 240px; padding: 30px; }
        .card { border: none; box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075); }
        .table thead { background-color: #f1f3f5; }
    </style>
</head>
<body>

<div class="sidebar d-flex flex-column p-3">
    <h3>Monarch ERP</h3>
    <hr>
    <ul class="nav nav-pills flex-column mb-auto">
        <li class="nav-item">
            <a href="#" class="nav-link active"><i class="fas fa-box me-2"></i> Products</a>
        </li>
        <li><a href="#" class="nav-link text-white"><i class="fas fa-tags me-2"></i> Variants</a></li>
        <li><a href="#" class="nav-link text-white"><i class="fas fa-chart-line me-2"></i> Inventory</a></li>
    </ul>
</div>

<div class="main-content">
    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Product Catalog</h2>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addProductModal">
                <i class="fas fa-plus"></i> Add New Product
            </button>
        </div>

        <div class="row mb-4">
            <div class="col-md-4">
                <div class="card p-3 text-center">
                    <h6>Total Products</h6>
                    <h2 class="text-primary">${products.size()}</h2>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead>
                    <tr>
                        <th class="ps-3">ID</th>
                        <th>Product Name</th>
                        <th>Item Code</th>
                        <th>Created At</th>
                        <th class="text-end pe-3">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${products}" var="product">
                        <tr>
                            <td class="ps-3">${product.productId}</td>
                            <td><strong>${product.productName}</strong></td>
                            <td><span class="badge bg-secondary">${product.itemCode}</span></td>
                            <td>${product.createdAt}</td>
                            <td class="text-end pe-3">
                                <button class="btn btn-sm btn-outline-info"><i class="fas fa-edit"></i></button>
                                <button class="btn btn-sm btn-outline-danger"><i class="fas fa-trash"></i></button>
                            </td>
                         </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>