<%--
  Created by IntelliJ IDEA.
  User: tusharparmar
  Date: 28-01-2026
  Time: 11:48
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Monarch ERP | Secure Login</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
  <style>
    :root {
      --primary-color: #1a237e; /* Monarch Deep Blue */
      --accent-color: #0d47a1;
      --bg-gradient: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
      --text-main: #333;
      --error-red: #d32f2f;
    }

    body {
      font-family: 'Inter', sans-serif;
      margin: 0;
      display: flex;
      align-items: center;
      justify-content: center;
      height: 100vh;
      background: var(--bg-gradient);
    }

    .login-card {
      background: #ffffff;
      width: 100%;
      max-width: 400px;
      padding: 40px;
      border-radius: 12px;
      box-shadow: 0 10px 25px rgba(0,0,0,0.1);
      text-align: center;
    }

    .brand-logo {
      font-size: 24px;
      font-weight: 600;
      color: var(--primary-color);
      margin-bottom: 8px;
      letter-spacing: 1px;
    }

    .brand-subtitle {
      font-size: 14px;
      color: #666;
      margin-bottom: 30px;
    }

    .input-group {
      text-align: left;
      margin-bottom: 20px;
    }

    label {
      display: block;
      font-size: 13px;
      font-weight: 600;
      margin-bottom: 6px;
      color: #555;
    }

    input {
      width: 100%;
      padding: 12px;
      border: 1px solid #ddd;
      border-radius: 6px;
      font-size: 14px;
      transition: border-color 0.3s ease;
      box-sizing: border-box;
    }

    input:focus {
      outline: none;
      border-color: var(--primary-color);
      box-shadow: 0 0 0 3px rgba(26, 35, 126, 0.1);
    }

    button {
      width: 100%;
      padding: 12px;
      background-color: var(--primary-color);
      color: white;
      border: none;
      border-radius: 6px;
      font-size: 16px;
      font-weight: 600;
      cursor: pointer;
      transition: background 0.3s ease;
      margin-top: 10px;
    }

    button:hover {
      background-color: var(--accent-color);
    }

    .footer-links {
      margin-top: 25px;
      font-size: 13px;
    }

    .footer-links a {
      color: var(--primary-color);
      text-decoration: none;
    }

    .footer-links a:hover {
      text-decoration: underline;
    }

    #error {
      font-size: 13px;
      background: #ffebee;
      padding: 10px;
      border-radius: 4px;
      display: none; /* Hidden by default */
      margin-bottom: 15px;
    }
  </style>
</head>
<body>

<div class="login-card">
  <div class="brand-logo">MONARCH ERP</div>
  <div class="brand-subtitle">Enterprise Resource Planning Portal</div>

  <div id="error"></div>

  <form id="loginForm">
    <div class="input-group">
      <label>Username</label>
      <input type="text" id="username" placeholder="" required>
    </div>

    <div class="input-group">
      <label>Password</label>
      <input type="password" id="password" placeholder="••••••••" required>
    </div>

    <button type="submit">Sign In to Dashboard</button>
  </form>

  <div class="footer-links">
    <a href="/forgot-password">Forgot Password?</a><br><br>
    <span>New user?</span> <a href="/register">Create an account</a>
  </div>
</div>

<script>
  document.getElementById('loginForm').onsubmit = async (e) => {
    e.preventDefault();
    const errorEl = document.getElementById('error');
    errorEl.style.display = 'none';

    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;

    try {
      const response = await fetch('/login', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ username, password })
      });

      if (response.ok) {
        const data = await response.json();
        localStorage.setItem('token', data.token);
        window.location.href = "/products";
      } else {
        errorEl.innerText = "Invalid username or password. Please try again.";
        errorEl.style.display = 'block';
      }
    } catch (err) {
      errorEl.innerText = "Connection error. Check your server.";
      errorEl.style.display = 'block';
    }
  };
</script>

</body>
</html>