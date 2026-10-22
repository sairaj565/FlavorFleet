<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.Cart, com.tap.model.CartItem" %>

<%
    Cart cart = (Cart) session.getAttribute("cart");
    String backUrl = request.getContextPath() + "/restaurant";
    if (cart != null && cart.getRestaurantId() > 0) {
        backUrl = request.getContextPath() + "/menu?restaurantId=" + cart.getRestaurantId();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Cart | FlavorFleet</title>

    <!-- Favicon -->
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/flavorfleet-logo.png?v=2">
    <link rel="shortcut icon" type="image/png" href="<%= request.getContextPath() %>/images/flavorfleet-logo.png?v=2">

    <!-- Master Common External Stylesheet -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Unified Reusable Navbar Component -->
    <jsp:include page="navbar.jsp" />

    <!-- Main Container -->
    <main class="cart-wrapper">
        <div class="cart-header-row">
            <h1 class="cart-title">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round" style="display:inline-block;vertical-align:middle;color:var(--clay-primary);">
                    <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/>
                    <line x1="3" y1="6" x2="21" y2="6"/>
                    <path d="M16 10a4 4 0 0 1-8 0"/>
                </svg>
                <span>Review Your Food Bag</span>
            </h1>

            <% if (cart != null && !cart.isEmpty()) { %>
                <a class="clay-btn clay-btn-secondary" href="<%= backUrl %>" style="display:inline-flex;align-items:center;gap:6px;padding:9px 18px;font-size:14px;font-weight:700;">
                    <span>&larr;</span> Add More Items
                </a>
            <% } %>
        </div>

        <% if (cart == null || cart.isEmpty()) { %>
            <!-- Empty Cart Card -->
            <div class="clay-card empty-cart-card">
                <div class="empty-icon">&#127857;</div>
                <h2 style="font-size:22px;margin-bottom:8px;font-weight:800;">Your cart is hungry!</h2>
                <p style="color:#78716c;margin-bottom:24px;font-size:14px;">Explore delicious dishes from top restaurants and add them here.</p>
                <a href="<%= request.getContextPath() %>/restaurant" class="clay-btn clay-btn-primary" style="padding:12px 24px;">
                    Explore Restaurants &rarr;
                </a>
            </div>
        <% } else { %>
            <!-- Populated Cart Items -->
            <div class="cart-items-card">
                <% for (CartItem item : cart.getItems()) { 
                       String imgPath = item.getMenu().getImagePath();
                       String cleanImg = (imgPath == null) ? "" : imgPath.replaceFirst("^/+", "");
                       String imgUrl = request.getContextPath() + "/" + cleanImg;
                %>
                    <div class="cart-item-row">
                        <!-- Thumbnail & Title -->
                        <div class="item-main">
                            <img src="<%= imgUrl %>" alt="<%= item.getMenu().getItemName() %>" class="item-thumb"
                                 onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/flavorfleet-logo.jpg';">
                            <div>
                                <h3 class="item-title"><%= item.getMenu().getItemName() %></h3>
                                <div class="item-unit-price">&#8377;<%= String.format("%.2f", item.getMenu().getPrice()) %> each</div>
                            </div>
                        </div>

                        <!-- Pillowy Quantity Stepper -->
                        <div class="clay-qty-control">
                            <!-- Minus Button -->
                            <form action="<%= request.getContextPath() %>/cart" method="post" class="clay-qty-form">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="menuId" value="<%= item.getMenu().getMenuId() %>">
                                <input type="hidden" name="quantity" value="<%= item.getQuantity() - 1 %>">
                                <button type="submit" class="clay-qty-btn" title="Decrease">&minus;</button>
                            </form>

                            <span class="clay-qty-count"><%= item.getQuantity() %></span>

                            <!-- Plus Button -->
                            <form action="<%= request.getContextPath() %>/cart" method="post" class="clay-qty-form">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="menuId" value="<%= item.getMenu().getMenuId() %>">
                                <input type="hidden" name="quantity" value="<%= item.getQuantity() + 1 %>">
                                <button type="submit" class="clay-qty-btn" title="Increase">&#43;</button>
                            </form>
                        </div>

                        <!-- Subtotal -->
                        <div class="item-subtotal">
                            &#8377;<%= String.format("%.2f", item.getSubtotal()) %>
                        </div>
                    </div>
                <% } %>

                <!-- Total Amount Inset Banner -->
                <div class="total-card">
                    <span class="total-label">Subtotal</span>
                    <span class="total-val">&#8377;<%= String.format("%.2f", cart.getTotalAmount()) %></span>
                </div>
            </div>

            <!-- Action Buttons Bar -->
            <div class="cart-actions-bar">
                <div>

                    <!-- Clear Cart Trigger Button -->
                    <form id="clearCartForm" action="<%= request.getContextPath() %>/cart" method="post" style="margin:0;">
                        <input type="hidden" name="action" value="clear">
                        <button type="button" class="clay-btn clay-btn-danger" onclick="openClearModal()">
                            &#128465; Clear Cart
                        </button>
                    </form>
                </div>

                <!-- Checkout CTA -->
                <% if (session.getAttribute("user") != null) { %>
                    <a class="clay-btn clay-btn-primary" href="<%= request.getContextPath() %>/checkout" style="padding:12px 24px;font-size:15px;">
                        Proceed to Checkout &rarr;
                    </a>
                <% } else { %>
                    <a class="clay-btn clay-btn-primary" href="<%= request.getContextPath() %>/login.jsp?redirect=checkout.jsp" style="padding:12px 24px;font-size:15px;">
                        Sign In to Checkout &rarr;
                    </a>
                <% } %>
            </div>
        <% } %>
    </main>

    <!-- Claymorphic Clear Cart Confirmation Modal -->
    <div id="clearCartModal" class="clay-modal-overlay" onclick="handleOverlayClick(event)">
        <div class="clay-modal-box">
            <div style="width:52px;height:52px;border-radius:50%;background:#fee2e2;color:#dc2626;display:flex;align-items:center;justify-content:center;font-size:24px;margin:0 auto 14px;">
                &#128465;
            </div>
            <h3 style="font-size:19px;font-weight:800;color:#1e1b18;margin-bottom:8px;">Clear your cart?</h3>
            <p style="font-size:15px;color:#1e1b18;font-weight:500;line-height:1.6;margin-bottom:22px;">All items will be removed from your cart. You can always add them back!</p>
            <div style="display:flex;gap:12px;">
                <button type="button" class="clay-btn clay-btn-secondary" style="flex:1;" onclick="closeClearModal()">Cancel</button>
                <button type="button" class="clay-btn clay-btn-danger" style="flex:1;background:#dc2626;color:#ffffff;" onclick="confirmClearCart()">Yes, Clear</button>
            </div>
        </div>
    </div>

    <!-- Unified Reusable Footer Component -->
    <jsp:include page="footer.jsp" />

    <script>
        function openClearModal() {
            var modal = document.getElementById('clearCartModal');
            if (modal) modal.classList.add('active');
        }

        function closeClearModal() {
            var modal = document.getElementById('clearCartModal');
            if (modal) modal.classList.remove('active');
        }

        function confirmClearCart() {
            var form = document.getElementById('clearCartForm');
            if (form) form.submit();
        }

        function handleOverlayClick(event) {
            if (event.target === document.getElementById('clearCartModal')) {
                closeClearModal();
            }
        }

        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') closeClearModal();
        });
    </script>
</body>
</html>