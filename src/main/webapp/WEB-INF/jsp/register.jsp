<%--
  Created by IntelliJ IDEA.
  User: tusharparmar
  Date: 28-01-2026
  Time: 11:47
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Monarch ERP | Create Account</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #1a237e;
            --accent-color: #0d47a1;
            --bg-gradient: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            --success-green: #2e7d32;
        }

        body {
            font-family: 'Inter', sans-serif;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            background: var(--bg-gradient);
            padding: 20px;
        }

        .reg-card {
            background: #ffffff;
            width: 100%;
            max-width: 450px;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
        }

        .brand-section {
            text-align: center;
            margin-bottom: 30px;
        }

        .brand-logo {
            font-size: 22px;
            font-weight: 600;
            color: var(--primary-color);
            letter-spacing: 1px;
            margin-bottom: 5px;
        }

        h2 {
            margin: 0;
            font-size: 1.5rem;
            color: #333;
        }

        .input-row {
            display: grid;
            grid-template-columns: 1fr;
            gap: 15px;
            margin-bottom: 20px;
        }

        .input-group {
            text-align: left;
        }

        label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 6px;
            color: #555;
        }

        input, select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            transition: all 0.3s ease;
            box-sizing: border-box;
            background-color: #f9f9f9;
        }

        input:focus, select:focus {
            outline: none;
            border-color: var(--primary-color);
            background-color: #fff;
            box-shadow: 0 0 0 3px rgba(26, 35, 126, 0.1);
        }

        button {
            width: 100%;
            padding: 14px;
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
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .footer-links {
            margin-top: 25px;
            text-align: center;
            font-size: 14px;
            color: #666;
        }

        .footer-links a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
        }

        #msg {
            font-size: 13px;
            padding: 12px;
            border-radius: 6px;
            display: none;
            margin-bottom: 20px;
            text-align: center;
        }

        .msg-error { background: #ffebee; color: #c62828; border: 1px solid #ef9a9a; }
        .msg-success { background: #e8f5e9; color: #2e7d32; border: 1px solid #a5d6a7; }
    </style>
</head>
<body>

<div class="reg-card">
    <div class="brand-section">
        <div class="brand-logo">MONARCH ERP</div>
        <h2>Create Admin Account</h2>
    </div>

    <div id="msg"></div>

    <form id="regForm">
        <div class="input-row">
            <div class="input-group">
                <label for="username">Username</label>
                <input type="text" id="username" placeholder="Pick a unique username" required>
            </div>

            <div class="input-group">
                <label for="email">Work Email</label>
                <input type="email" id="email" placeholder="name@company.com" required>
            </div>

            <div class="input-group">
                <label for="password">Password</label>
                <input type="password" id="password" placeholder="Min. 8 characters" required>
            </div>

            <div class="input-group">
                <label for="role">Access Level</label>
                <select id="role">
                    <option value="USER">Standard User</option>
                    <option value="MODERATOR">Moderator</option>
                    <option value="ADMIN">System Administrator</option>
                </select>
            </div>
        </div>

        <button type="submit">Complete Registration</button>
    </form>

    <div class="footer-links">
        Already using Monarch? <a href="/api/auth/login">Sign In</a>
    </div>
</div>
<script>
document.getElementById('regForm').onsubmit = async (e) => {
    e.preventDefault();
    const msgEl = document.getElementById('msg');
    msgEl.style.display = 'none';

    const data = {
        userName: document.getElementById('username').value,
        email: document.getElementById('email').value,
        password: document.getElementById('password').value,
        role: document.getElementById('role').value
    };

    try {
        const response = await fetch('/api/auth/register', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(data)
        });

        if (!response.ok) throw new Error();

        msgEl.innerText = "Account created successfully! Please login.";
        msgEl.className = "msg-success";
        msgEl.style.display = 'block';

        setTimeout(() => {
            window.location.href = "/api/auth/login";
        }, 1500);

    } catch (err) {
        msgEl.innerText = "Registration failed. Username or email might be taken.";
        msgEl.className = "msg-error";
        msgEl.style.display = 'block';
    }
};
</script>

</body>
</html>
