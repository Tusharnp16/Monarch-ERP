<%--
  Created by IntelliJ IDEA.
  User: tusharparmar
  Date: 29-01-2026
  Time: 14:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>Access Denied</title>
  <style>
    body {
      font-family: 'Segoe UI', sans-serif;
      background-color: #f8f9fa;
      color: #333;
      text-align: center;
      padding-top: 100px;
    }
    .error-box {
      display: inline-block;
      padding: 40px;
      background-color: #fff;
      border: 1px solid #ddd;
      border-radius: 8px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }
    h1 {
      font-size: 36px;
      color: #dc3545;
    }
    p {
      font-size: 18px;
      margin-top: 20px;
    }
    a {
      display: inline-block;
      margin-top: 30px;
      text-decoration: none;
      color: #007bff;
      font-weight: bold;
    }
  </style>
</head>
<body>
<div class="error-box">
  <h1>403 - Forbidden</h1>
  <p>You don’t have access to this resource.</p>
  <a href="/">Go back to Home</a>
</div>
</body>
</html>
