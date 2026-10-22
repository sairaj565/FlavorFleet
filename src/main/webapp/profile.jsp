<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=profile.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | FlavorFleet</title>

    <!-- Favicon -->
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/flavorfleet-logo.png?v=2">
    <link rel="shortcut icon" type="image/png" href="<%= request.getContextPath() %>/images/flavorfleet-logo.png?v=2">

    <!-- Master Common External Stylesheet -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Unified Reusable Navbar Component -->
    <jsp:include page="navbar.jsp" />

    <main class="profile-wrapper">
        <div class="clay-card">
            <!-- Header with Avatar -->
            <div style="display:flex;align-items:center;gap:18px;margin-bottom:24px;padding-bottom:18px;border-bottom:1px solid #ede4d8;">
                <div class="avatar-clay">
                    <%= (user.getUsername() != null && !user.getUsername().isEmpty()) ? user.getUsername().substring(0, 1).toUpperCase() : "U" %>
                </div>
                <div>
                    <h1 style="font-size:22px;font-weight:800;color:var(--clay-text-dark);margin-bottom:4px;">
                        <%= (user.getUsername() != null) ? user.getUsername() : "User" %>
                    </h1>
                    <span class="clay-badge clay-badge-green">
                        <%= (user.getRole() != null) ? user.getRole() : "Customer" %>
                    </span>
                </div>
            </div>

            <!-- Details -->
            <div style="background:var(--clay-bg-soft);box-shadow:var(--clay-inset);border-radius:16px;padding:16px 20px;margin-bottom:24px;">
                <div class="profile-row">
                    <span style="color:var(--clay-text-muted);font-weight:600;">&#128231; Email</span>
                    <span style="font-weight:700;color:var(--clay-text-dark);"><%= (user.getEmail() != null) ? user.getEmail() : "-" %></span>
                </div>
                <div class="profile-row">
                    <span style="color:var(--clay-text-muted);font-weight:600;">&#128222; Phone</span>
                    <span style="font-weight:700;color:var(--clay-text-dark);"><%= (user.getPhone() != null && !user.getPhone().isEmpty()) ? user.getPhone() : "Not provided" %></span>
                </div>
                <div class="profile-row">
                    <span style="color:var(--clay-text-muted);font-weight:600;">&#128205; Address</span>
                    <span style="font-weight:700;color:var(--clay-text-dark);text-align:right;max-width:240px;"><%= (user.getAddress() != null && !user.getAddress().isEmpty()) ? user.getAddress() : "Not provided" %></span>
                </div>
            </div>

            <!-- Actions -->
            <div style="display:flex;gap:12px;">
                <a href="<%= request.getContextPath() %>/restaurant" class="clay-btn clay-btn-primary" style="flex:1;">
                    Order Food &rarr;
                </a>
                <button type="button" class="clay-btn clay-btn-danger" onclick="openLogoutModal()" style="padding:10px 18px;cursor:pointer;">
                    Log Out
                </button>
            </div>
        </div>
    </main>

    <!-- Unified Reusable Footer Component -->
    <jsp:include page="footer.jsp" />

</body>
</html>
