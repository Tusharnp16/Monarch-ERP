<%--
  Created by IntelliJ IDEA.
  User: tusharparmar
  Date: 23-01-2026
  Time: 17:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Monarch ERP | System Update</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

  <style>
    body {
      background-color: #f8f9fa;
      height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      overflow: hidden;
    }

    .dev-card {
      text-align: center;
      max-width: 500px;
      padding: 3rem;
      background: white;
      border-radius: 20px;
      box-shadow: 0 10px 30px rgba(0,0,0,0.1);
    }

    /* The "Hard Working" Animation */
    .icon-box {
      position: relative;
      font-size: 4rem;
      color: #0d6efd;
      margin-bottom: 2rem;
    }

    .fa-keyboard {
      animation: type-hit 0.2s infinite alternate;
    }

    @keyframes type-hit {
      from { transform: translateY(0); }
      to { transform: translateY(-5px); }
    }

    .steam {
      position: absolute;
      top: -20px;
      left: 50%;
      transform: translateX(-50%);
      font-size: 1.5rem;
      color: #adb5bd;
      opacity: 0;
      animation: rise 2s infinite;
    }

    @keyframes rise {
      0% { opacity: 0; transform: translate(-50%, 0); }
      50% { opacity: 1; }
      100% { opacity: 0; transform: translate(-50%, -40px); }
    }

    .code-loader {
      font-family: monospace;
      color: #198754;
      background: #212529;
      padding: 10px;
      border-radius: 5px;
      margin: 20px 0;
      font-size: 0.9rem;
      min-height: 45px;
    }

    .btn-monarch {
      background-color: #0d6efd;
      color: white;
      border-radius: 50px;
      padding: 10px 25px;
      text-decoration: none;
      transition: 0.3s;
    }

    .btn-monarch:hover {
      background-color: #0b5ed7;
      transform: scale(1.05);
    }
  </style>
</head>
<body>

<div class="dev-card">
  <div class="icon-box">
    <i class="fa-solid fa-mug-hot steam"></i>
    <i class="fa-solid fa-keyboard"></i>
  </div>

  <h2 class="fw-bold text-dark">Developer is Brewing Code...</h2>
  <p class="text-muted">
    Our developer is currently fighting a rogue semicolon.
    <strong>Kindly cooperate</strong> while we force-feed the server some coffee.
  </p>

  <div class="code-loader" id="codeText">
    // Loading monarch-erp-v2.0...
  </div>

  <div class="mt-4">
    <a href="/products" class="btn btn-monarch">
      <i class="fa-solid fa-arrow-left me-2"></i> Take me back safely
    </a>
  </div>

  <p class="text-muted-small mt-4" style="font-size: 0.8rem;">
    Estimated completion: When the caffeine hits.
  </p>
</div>

<script>
  // Fun coding text animation
  const codeLines = [
    "fixing bugs...",
    "deleting system32... just kidding",
    "optimizing database queries...",
    "googling the solution...",
    "refactoring messy code...",
    "Monarch ERP is worth the wait!"
  ];

  let i = 0;
  const codeDiv = document.getElementById('codeText');

  setInterval(() => {
    codeDiv.innerText = "> " + codeLines[i];
    i = (i + 1) % codeLines.length;
  }, 2000);
</script>

</body>
</html>
