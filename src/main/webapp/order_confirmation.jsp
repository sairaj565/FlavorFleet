<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.Order" %>

<%
    Order order = (Order) session.getAttribute("latestOrder");
    String address = (String) session.getAttribute("deliveryAddress");
    if (address == null || address.trim().isEmpty()) {
        address = "Home Address";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmed | FlavorFleet</title>

    <!-- Favicon -->
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/flavorfleet-logo.png?v=2">
    <link rel="shortcut icon" type="image/png" href="<%= request.getContextPath() %>/images/flavorfleet-logo.png?v=2">

    <!-- Master Common External Stylesheet -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Unified Reusable Navbar Component -->
    <jsp:include page="navbar.jsp" />

    <main style="max-width:580px;margin:40px auto 60px;padding:0 20px;flex:1;width:100%;">
        <div class="clay-card" style="text-align:center;padding:36px 28px;">
            <!-- Celebration Badge -->
            <div style="width:72px;height:72px;border-radius:50%;background:var(--clay-green-soft);color:var(--clay-green);font-size:34px;display:flex;align-items:center;justify-content:center;margin:0 auto 16px;box-shadow:0 8px 18px rgba(16, 185, 129, 0.25);">
                &#10003;
            </div>

            <h1 style="font-size:24px;font-weight:800;color:var(--clay-text-dark);margin-bottom:6px;">Order Placed Successfully!</h1>
            <p style="color:var(--clay-text-muted);font-size:14px;margin-bottom:24px;">The kitchen has received your order and is preparing it fresh.</p>

            <!-- Delivery Time Pill -->
            <div style="background:var(--clay-primary-soft);border:1.5px solid var(--clay-primary);color:var(--clay-primary);padding:12px;border-radius:14px;font-weight:800;font-size:14px;margin-bottom:24px;">
                &#128666; Estimated Delivery: 30 &ndash; 40 mins
            </div>

            <!-- Receipt Box -->
            <div style="background:var(--clay-bg-soft);box-shadow:var(--clay-inset);border-radius:16px;padding:18px 20px;text-align:left;margin-bottom:26px;">
                <div style="display:flex;justify-content:space-between;padding:8px 0;font-size:14px;border-bottom:1px solid #ede4d8;">
                    <span style="color:var(--clay-text-muted);font-weight:600;">Status</span>
                    <span style="color:var(--clay-green);font-weight:800;">&#9679; Placed</span>
                </div>
                <% if (order != null && order.getOrderId() > 0) { %>
                    <div style="display:flex;justify-content:space-between;padding:8px 0;font-size:14px;border-bottom:1px solid #ede4d8;">
                        <span style="color:var(--clay-text-muted);font-weight:600;">Order ID</span>
                        <span style="font-weight:800;color:var(--clay-text-dark);">#FF-<%= order.getOrderId() %></span>
                    </div>
                <% } %>
                <div style="display:flex;justify-content:space-between;padding:8px 0;font-size:14px;border-bottom:1px solid #ede4d8;">
                    <span style="color:var(--clay-text-muted);font-weight:600;">Amount Paid</span>
                    <span style="font-weight:800;color:var(--clay-primary);">&#8377;<%= (order != null) ? String.format("%.2f", order.getTotalAmount()) : "0.00" %></span>
                </div>
                <div style="display:flex;justify-content:space-between;padding:8px 0;font-size:14px;">
                    <span style="color:var(--clay-text-muted);font-weight:600;">Delivering To</span>
                    <span style="font-weight:700;color:var(--clay-text-dark);text-align:right;max-width:240px;"><%= address %></span>
                </div>
            </div>

            <a href="<%= request.getContextPath() %>/restaurant" class="clay-btn clay-btn-primary" style="padding:12px 28px;font-size:15px;">
                Order More Food &rarr;
            </a>
        </div>
    </main>

    <!-- Unified Reusable Footer Component -->
    <jsp:include page="footer.jsp" />

</body>
</html>
