<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Monarch ERP | Secure Login</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
  <style>
    :root {
      --primary-color: #1a237e;
      --accent-color: #0d47a1;
      --bg-gradient: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
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
    }
    .brand-subtitle {
      font-size: 14px;
      color: #666;
      margin-bottom: 30px;
    }
    .input-group { text-align: left; margin-bottom: 20px; }
    label { font-size: 13px; font-weight: 600; margin-bottom: 6px; display: block; }
    input {
      width: 100%; padding: 12px; border: 1px solid #ddd;
      border-radius: 6px; font-size: 14px; box-sizing: border-box;
    }
    button {
      width: 100%; padding: 12px; background-color: var(--primary-color);
      color: white; border: none; border-radius: 6px;
      font-size: 16px; font-weight: 600; cursor: pointer;
    }
    #error {
      font-size: 13px;
      background: #ffebee;
      padding: 10px;
      border-radius: 4px;
      display: none;
      margin-bottom: 15px;
      color: #c62828;
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
      <input type="text" id="username" required>
    </div>

    <div class="input-group">
      <label>Password</label>
      <input type="password" id="password" required>
    </div>

    <button type="submit">Sign In to Dashboard</button>
  </form>

  <div class="footer-links">
    Didn't have account!! <a href="/api/auth/register"> Register Here</a>
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
    const response = await fetch('/api/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ username, password })
    });

    if (!response.ok) throw new Error();

    const data = await response.json();

    localStorage.setItem("accessToken", data.accessToken);
    localStorage.setItem("refreshToken", data.refreshToken);

  document.cookie = "accessToken=" + data.accessToken + "; path=/; Max-Age=" + (60 * 60) + "; SameSite=Strict";

    window.location.href = "/products";

  } catch (err) {
    errorEl.innerText = "Invalid username or password.";
    errorEl.style.display = 'block';
  }
};
</script>

</body>
</html>
