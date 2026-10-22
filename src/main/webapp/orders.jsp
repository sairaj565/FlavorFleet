<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, java.text.SimpleDateFormat" %>
<%@ page import="com.tap.model.Order, com.tap.model.OrderItem, com.tap.model.Restaurant, com.tap.model.Menu" %>

<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    Map<Integer, Restaurant> restaurantMap = (Map<Integer, Restaurant>) request.getAttribute("restaurantMap");
    Map<Integer, List<OrderItem>> orderItemsMap = (Map<Integer, List<OrderItem>>) request.getAttribute("orderItemsMap");
    Map<Integer, Menu> menuMap = (Map<Integer, Menu>) request.getAttribute("menuMap");
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders | FlavorFleet</title>

    <!-- Favicon -->
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/flavorfleet-logo.png?v=2">
    <link rel="shortcut icon" type="image/png" href="<%= request.getContextPath() %>/images/flavorfleet-logo.png?v=2">

    <!-- Master Common External Stylesheet -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Unified Reusable Navbar Component -->
    <jsp:include page="navbar.jsp" />

    <main style="max-width:860px;margin:36px auto 60px;padding:0 20px;flex:1;width:100%;box-sizing:border-box;">

        <!-- Page Header -->
        <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:24px;flex-wrap:wrap;gap:12px;">
            <div>
                <h1 style="font-size:26px;font-weight:800;color:var(--clay-text-dark);margin-bottom:4px;display:flex;align-items:center;gap:10px;">
                    <span>🧾</span> My Orders
                </h1>
                <p style="color:var(--clay-text-muted);font-size:14px;margin:0;">Track live food orders and review past meals</p>
            </div>
            <% if (orders != null && !orders.isEmpty()) { %>
                <span class="clay-badge-orange" style="font-size:13px;padding:6px 14px;border-radius:20px;font-weight:700;">
                    <%= orders.size() %> <%= (orders.size() == 1) ? "Order" : "Orders" %> Placed
                </span>
            <% } %>
        </div>

        <% if (orders == null || orders.isEmpty()) { %>
            <!-- Empty State -->
            <div class="clay-card" style="text-align:center;padding:50px 24px;margin-top:20px;">
                <div style="width:72px;height:72px;border-radius:50%;background:#fff1eb;color:var(--clay-primary);font-size:36px;display:flex;align-items:center;justify-content:center;margin:0 auto 16px;box-shadow:0 8px 20px rgba(255, 94, 40, 0.2);">
                    🍲
                </div>
                <h2 style="font-size:22px;font-weight:800;color:var(--clay-text-dark);margin-bottom:8px;">No Orders Placed Yet</h2>
                <p style="color:var(--clay-text-muted);font-size:14px;max-width:380px;margin:0 auto 24px;line-height:1.5;">
                    Looks like you haven't placed an order yet. Explore top restaurants and order delicious food today!
                </p>
                <a href="<%= request.getContextPath() %>/restaurant" class="clay-btn clay-btn-primary" style="display:inline-flex;padding:12px 24px;font-size:14px;">
                    Explore Restaurants &rarr;
                </a>
            </div>
        <% } else { %>
            <!-- Orders List -->
            <div style="display:flex;flex-direction:column;gap:24px;">
                <% for (Order order : orders) { 
                    Restaurant restaurant = (restaurantMap != null) ? restaurantMap.get(order.getRestaurantId()) : null;
                    List<OrderItem> orderItems = (orderItemsMap != null) ? orderItemsMap.get(order.getOrderId()) : null;
                    String formattedDate = (order.getOrderDate() != null) ? sdf.format(order.getOrderDate()) : "Recent";
                    String status = (order.getStatus() != null && !order.getStatus().trim().isEmpty()) ? order.getStatus().toUpperCase() : "PLACED";
                %>
                    <div class="clay-card" style="padding:24px 26px;border-radius:20px;box-shadow:var(--clay-shadow-card);">
                        
                        <!-- 1. Card Header: Order #ID, Date and Status Badge -->
                        <div style="display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:18px;">
                            <div>
                                <h2 style="font-size:19px;font-weight:800;color:var(--clay-text-dark);margin:0 0 4px 0;">
                                    Order #<%= order.getOrderId() %>
                                </h2>
                                <span style="font-size:12.5px;color:var(--clay-text-muted);">
                                    <%= formattedDate %>
                                </span>
                            </div>
                            <div>
                                <span style="padding:6px 14px;border-radius:20px;font-size:11.5px;font-weight:800;letter-spacing:0.5px;background:#fff1eb;color:var(--clay-primary);border:1.5px solid rgba(255, 94, 40, 0.3);">
                                    <%= status %>
                                </span>
                            </div>
                        </div>

                        <!-- 2. Restaurant Row Banner -->
                        <% if (restaurant != null) { %>
                            <div style="background:var(--clay-bg-soft);border:1px solid #ede4d8;border-radius:14px;padding:12px 14px;display:flex;align-items:center;gap:14px;margin-bottom:20px;">
                                <% if (restaurant.getImagePath() != null && !restaurant.getImagePath().trim().isEmpty()) { %>
                                    <img src="<%= request.getContextPath() %>/<%= restaurant.getImagePath() %>" 
                                         alt="<%= restaurant.getName() %>"
                                         style="width:52px;height:52px;border-radius:12px;object-fit:cover;flex-shrink:0;box-shadow:0 3px 8px rgba(0,0,0,0.08);"
                                         onerror="this.style.display='none';this.nextElementSibling.style.display='flex';">
                                    <div style="display:none;width:52px;height:52px;border-radius:12px;background:#fee2e2;color:var(--clay-primary);align-items:center;justify-content:center;font-size:24px;flex-shrink:0;">
                                        🏪
                                    </div>
                                <% } else { %>
                                    <div style="width:52px;height:52px;border-radius:12px;background:#fff1eb;color:var(--clay-primary);display:flex;align-items:center;justify-content:center;font-size:24px;flex-shrink:0;">
                                        🏪
                                    </div>
                                <% } %>
                                <div style="flex:1;min-width:0;">
                                    <div style="font-size:16px;font-weight:800;color:var(--clay-text-dark);margin-bottom:2px;">
                                        <%= restaurant.getName() %>
                                    </div>
                                    <% if (restaurant.getCuisineType() != null && !restaurant.getCuisineType().trim().isEmpty()) { %>
                                        <div style="font-size:12.5px;font-weight:700;color:var(--clay-primary);margin-bottom:2px;">
                                            <%= restaurant.getCuisineType() %>
                                        </div>
                                    <% } %>
                                    <% if (restaurant.getAddress() != null && !restaurant.getAddress().trim().isEmpty()) { %>
                                        <div style="font-size:12px;color:var(--clay-text-muted);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
                                            📍 <%= restaurant.getAddress() %>
                                        </div>
                                    <% } %>
                                </div>
                            </div>
                        <% } %>

                        <!-- 3. Ordered Items Section -->
                        <div style="margin-bottom:20px;">
                            <h3 style="font-size:14px;font-weight:800;color:var(--clay-text-dark);margin:0 0 14px 0;letter-spacing:0.2px;">
                                Ordered Items
                            </h3>

                            <% if (orderItems != null && !orderItems.isEmpty()) { %>
                                <div style="display:flex;flex-direction:column;gap:12px;">
                                    <% for (OrderItem item : orderItems) { 
                                        Menu menu = (menuMap != null) ? menuMap.get(item.getMenuId()) : null;
                                        String dishName = (menu != null && menu.getItemName() != null) ? menu.getItemName() : "Dish #" + item.getMenuId();
                                        double unitPrice = (menu != null) ? menu.getPrice() : (item.getItemTotal() / Math.max(1, item.getQuantity()));
                                    %>
                                        <div style="display:flex;align-items:center;justify-content:space-between;gap:12px;padding:8px 0;">
                                            <!-- Dish Image + Details -->
                                            <div style="display:flex;align-items:center;gap:12px;min-width:0;flex:1;">
                                                <% if (menu != null && menu.getImagePath() != null && !menu.getImagePath().trim().isEmpty()) { %>
                                                    <img src="<%= request.getContextPath() %>/<%= menu.getImagePath() %>" 
                                                         alt="<%= dishName %>" 
                                                         style="width:48px;height:48px;border-radius:10px;object-fit:cover;flex-shrink:0;box-shadow:0 2px 6px rgba(0,0,0,0.06);"
                                                         onerror="this.style.display='none';this.nextElementSibling.style.display='flex';">
                                                    <div style="display:none;width:48px;height:48px;border-radius:10px;background:#fef3c7;color:#b45309;align-items:center;justify-content:center;font-size:20px;flex-shrink:0;">
                                                        🍲
                                                    </div>
                                                <% } else { %>
                                                    <div style="width:48px;height:48px;border-radius:10px;background:#fef3c7;color:#b45309;display:flex;align-items:center;justify-content:center;font-size:20px;flex-shrink:0;">
                                                        🍲
                                                    </div>
                                                <% } %>

                                                <div style="min-width:0;">
                                                    <div style="font-size:14px;font-weight:700;color:var(--clay-text-dark);margin-bottom:2px;">
                                                        <%= dishName %>
                                                    </div>
                                                    <div style="font-size:12px;color:var(--clay-primary);font-weight:600;margin-bottom:2px;">
                                                        &#8377;<%= String.format("%.2f", unitPrice) %> per item
                                                    </div>
                                                    <div style="font-size:11.5px;color:var(--clay-text-muted);">
                                                        Quantity: <%= item.getQuantity() %>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Item Total (Right-Aligned) -->
                                            <div style="font-size:15px;font-weight:800;color:var(--clay-text-dark);flex-shrink:0;">
                                                &#8377;<%= String.format("%.2f", item.getItemTotal()) %>
                                            </div>
                                        </div>
                                    <% } %>
                                </div>
                            <% } else { %>
                                <p style="font-size:13px;color:var(--clay-text-muted);margin:0;">No individual item details available.</p>
                            <% } %>
                        </div>

                        <!-- 4. Card Bottom: Payment Mode & Total Amount -->
                        <div style="border-top:1.5px solid #ede4d8;padding-top:16px;display:flex;justify-content:space-between;align-items:flex-end;">
                            <div>
                                <div style="font-size:11px;font-weight:800;color:var(--clay-text-muted);text-transform:uppercase;letter-spacing:0.8px;margin-bottom:4px;">
                                    PAYMENT
                                </div>
                                <div style="font-size:14px;font-weight:800;color:var(--clay-text-dark);">
                                    <%= (order.getPaymentMode() != null && !order.getPaymentMode().trim().isEmpty()) ? order.getPaymentMode().toUpperCase() : "COD" %>
                                </div>
                            </div>
                            <div style="text-align:right;">
                                <div style="font-size:12px;color:var(--clay-text-muted);font-weight:600;margin-bottom:2px;">
                                    Total Amount
                                </div>
                                <div style="font-size:20px;font-weight:800;color:var(--clay-primary);">
                                    &#8377;<%= String.format("%.2f", order.getTotalAmount()) %>
                                </div>
                            </div>
                        </div>

                    </div>
                <% } %>
            </div>
        <% } %>

    </main>

    <!-- Unified Reusable Footer Component -->
    <jsp:include page="footer.jsp" />

</body>
</html>
