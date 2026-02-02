<%--
  Created by IntelliJ IDEA.
  User: tusharparmar
  Date: 02-02-2026
  Time: 10:19
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<c:forEach items="${stocks}" var="s">
  <tr data-batch="${s.stockMasterId}">
    <td class="ps-3"><strong>${s.stockMasterId}</strong></td>
    <td>
      <c:choose>
        <c:when test="${not empty s.variant}">
          <span class="text-dark fw-bold">${s.variant.variantName}</span>
        </c:when>
        <c:otherwise>
          <span class="text-danger small">
            <i class="fas fa-exclamation-triangle me-1"></i> Removed
          </span>
        </c:otherwise>
      </c:choose>
    </td>
    <td>${s.batchNo}</td>
    <td><span class="badge ${s.quantity < 10 ? 'bg-danger' : 'badge-soft'}">${s.quantity}</span></td>
    <td>${s.purchasePrice.price}</td>
    <td>${s.landingCost.price}</td>
    <td>${s.mrp.price}</td>
    <td>${s.sellingPrice.price}</td>
    <td>${s.expiryDate}</td>
    <td class="text-end pe-3">
      <button class="btn btn-sm btn-outline-info" data-bs-toggle="modal"
              data-bs-target="#editStockModal"
              data-id="${s.stockMasterId}"
              data-price="${s.sellingPrice.price}"
              data-mrp="${s.mrp.price}"
              data-batch="${s.batchNo}">
        <i class="fas fa-edit"></i>
      </button>
    </td>
  </tr>
</c:forEach>

