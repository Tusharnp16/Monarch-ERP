<%--
  Created by IntelliJ IDEA.
  User: tusharparmar
  Date: 22-01-2026
  Time: 17:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Monarch ERP - Dashboard</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-100 font-sans">

<div class="flex h-screen">
  <aside class="w-64 bg-slate-900 text-white flex-shrink-0">
    <div class="p-6 text-2xl font-bold border-b border-slate-700">
      Monarch ERP
    </div>
    <nav class="mt-6">
      <a href="#" class="flex items-center py-3 px-6 bg-blue-600 text-white">
        <i class="fas fa-tachometer-alt mr-3"></i> Dashboard
      </a>
      <a href="#" class="flex items-center py-3 px-6 text-gray-400 hover:bg-slate-800 hover:text-white transition">
        <i class="fas fa-box mr-3"></i> Inventory
      </a>
      <a href="#" class="flex items-center py-3 px-6 text-gray-400 hover:bg-slate-800 hover:text-white transition">
        <i class="fas fa-users mr-3"></i> HR Management
      </a>
      <a href="#" class="flex items-center py-3 px-6 text-gray-400 hover:bg-slate-800 hover:text-white transition">
        <i class="fas fa-file-invoice-dollar mr-3"></i> Finance
      </a>
    </nav>
  </aside>

  <main class="flex-1 flex flex-col overflow-hidden">
    <header class="bg-white shadow-sm py-4 px-8 flex justify-between items-center">
      <h1 class="text-xl font-semibold text-gray-800">System Overview</h1>
      <div class="flex items-center space-x-4">
        <button class="text-gray-500 hover:text-blue-600"><i class="fas fa-bell"></i></button>
        <div class="h-8 w-8 rounded-full bg-blue-500 flex items-center justify-center text-white">
          <i class="fas fa-user"></i>
        </div>
      </div>
    </header>

    <div class="flex-1 overflow-y-auto p-8">
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
          <p class="text-sm text-gray-500 font-medium uppercase">Total Sales</p>
          <p class="text-2xl font-bold text-gray-800">₹4,25,000</p>
          <span class="text-green-500 text-sm font-semibold">+12% from last month</span>
        </div>
        <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
          <p class="text-sm text-gray-500 font-medium uppercase">Active Projects</p>
          <p class="text-2xl font-bold text-gray-800">18</p>
          <span class="text-blue-500 text-sm font-semibold">4 Due this week</span>
        </div>
        <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
          <p class="text-sm text-gray-500 font-medium uppercase">Pending Invoices</p>
          <p class="text-2xl font-bold text-gray-800">24</p>
          <span class="text-red-500 text-sm font-semibold">Action Required</span>
        </div>
        <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
          <p class="text-sm text-gray-500 font-medium uppercase">Employees</p>
          <p class="text-2xl font-bold text-gray-800">156</p>
          <span class="text-gray-400 text-sm font-semibold">Across 4 branches</span>
        </div>
      </div>

      <div class="bg-white rounded-xl shadow-sm border border-gray-100">
        <div class="p-6 border-b border-gray-100 flex justify-between items-center">
          <h2 class="text-lg font-bold text-gray-800">Recent Transactions</h2>
          <button class="text-blue-600 hover:underline text-sm font-medium">View All</button>
        </div>
        <div class="overflow-x-auto">
          <table class="w-full text-left">
            <thead class="bg-gray-50 text-gray-500 text-sm">
            <tr>
              <th class="px-6 py-4 font-semibold uppercase">ID</th>
              <th class="px-6 py-4 font-semibold uppercase">Entity</th>
              <th class="px-6 py-4 font-semibold uppercase">Amount</th>
              <th class="px-6 py-4 font-semibold uppercase">Status</th>
              <th class="px-6 py-4 font-semibold uppercase">Date</th>
            </tr>
            </thead>
            <tbody class="divide-y divide-gray-100">
            <tr>
              <td class="px-6 py-4 text-sm font-medium">#INV-001</td>
              <td class="px-6 py-4 text-sm">TechCorp Solutions</td>
              <td class="px-6 py-4 text-sm font-bold">₹12,400</td>
              <td class="px-6 py-4"><span class="px-3 py-1 bg-green-100 text-green-700 rounded-full text-xs">Paid</span></td>
              <td class="px-6 py-4 text-sm text-gray-500">Jan 22, 2026</td>
            </tr>
            <tr>
              <td class="px-6 py-4 text-sm font-medium">#INV-002</td>
              <td class="px-6 py-4 text-sm">Global Exports</td>
              <td class="px-6 py-4 text-sm font-bold">₹8,900</td>
              <td class="px-6 py-4"><span class="px-3 py-1 bg-yellow-100 text-yellow-700 rounded-full text-xs">Pending</span></td>
              <td class="px-6 py-4 text-sm text-gray-500">Jan 21, 2026</td>
            </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </main>
</div>

</body>
</html>