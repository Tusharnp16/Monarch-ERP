<%--
  Created by IntelliJ IDEA.
  User: tusharparmar
  Date: 05-02-2026
  Time: 17:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.io.*, java.util.*" %>

<%

    String logPath = "C:\\Windows\\System32\\winevt\\Logs"; // Update this to your actual log path
    List<String> logLines = new ArrayList<>();

    try (BufferedReader reader = new BufferedReader(new FileReader(logPath))) {
        String line;
        while ((line = reader.readLine()) != null) {
            logLines.add(line);
        }
    } catch (IOException e) {
        request.setAttribute("error", "Could not read log file: " + e.getMessage());
    }

    // Reverse the list to see newest logs first
    Collections.reverse(logLines);
    request.setAttribute("logs", logLines);
%>

<!DOCTYPE html>
<html>
<head>
    <title>System Log Viewer</title>
    <style>
        body { font-family: sans-serif; background: #f4f4f4; padding: 20px; }
        .container { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { text-align: left; padding: 12px; border-bottom: 1px solid #ddd; font-family: monospace; }
        tr:nth-child(even) { background-color: #f9f9f9; }
        .error { color: red; font-weight: bold; }
        .status-badge { padding: 4px 8px; border-radius: 4px; font-size: 0.8em; color: white; }
        .error-log { background: #e74c3c; }
        .info-log { background: #3498db; }
    </style>
</head>
<body>

<div class="container">
    <h2>System Activity Logs (SSR)</h2>
    <p>Viewing: <code><%= logPath %></code></p>

    <c:if test="${not empty error}">
        <p class="error">${error}</p>
    </c:if>

    <table>
        <thead>
        <tr>
            <th>Line #</th>
            <th>Log Entry</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="entry" items="${logs}" varStatus="status">
            <tr>
                <td>${status.count}</td>
                <td>
                    <c:choose>
                        <c:when test="${entry.contains('ERROR') || entry.contains('SEVERE')}">
                            <span class="status-badge error-log">ERROR</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-badge info-log">INFO</span>
                        </c:otherwise>
                    </c:choose>
                        ${entry}
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

</body>
</html>
