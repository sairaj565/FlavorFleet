<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User, com.tap.model.Cart" %>

<%
    // Retrieve logged in user and cart from session
    User navUser = (User) session.getAttribute("user");
    Cart navCart = (Cart) session.getAttribute("cart");
    int navCartCount = (navCart != null) ? navCart.getTotalQuantity() : 0;

    // Retrieve user address if logged in, otherwise default to Bengaluru
    String displayLocation = "Bengaluru";
    if (navUser != null && navUser.getAddress() != null && !navUser.getAddress().trim().isEmpty()) {
        displayLocation = navUser.getAddress().trim();
    }
%>

<header class="clay-navbar">
    <div class="clay-nav-container">
        <!-- Left: Brand Logo & Dynamic Location -->
        <div style="display:flex;align-items:center;gap:14px;">
            <a href="<%= request.getContextPath() %>/restaurant" class="clay-brand" title="FlavorFleet Home">
                <img src="<%= request.getContextPath() %>/images/flavorfleet-logo.png?v=2" alt="FlavorFleet"
                     class="clay-brand-logo"
                     onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/flavorfleet-logo.jpg';">
                <div class="clay-brand-text">
                    Flavor<span>Fleet</span>
                </div>
            </a>

            <!-- Location Badge: Shows actual user address (e.g. BTM) when logged in, or Bengaluru -->
            <a href="<%= (navUser != null) ? request.getContextPath() + "/profile.jsp" : request.getContextPath() + "/restaurant" %>"
               class="clay-chip nav-hide-mobile"
               style="display:flex;align-items:center;gap:6px;font-size:12px;padding:6px 14px;text-decoration:none;color:inherit;max-width:210px;"
               title="Delivery to <%= displayLocation %> (Click to view profile)">
                <span>&#128205;</span>
                <span style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;font-weight:700;"><%= displayLocation %></span>
            </a>
        </div>

        <!-- Right: Actions (Home, Restaurants, Auth, Cart, Logout) -->
        <div class="clay-nav-right">
            <!-- Home Link: Shows the entire Home Page -->
            <a href="<%= request.getContextPath() %>/restaurant" class="clay-btn clay-btn-secondary" title="FlavorFleet Home">
                <span>&#127968;</span>
                <span class="nav-text">Home</span>
            </a>

            <!-- Restaurants Link: Left of Sign In/Profile, scrolls directly to Restaurants section -->
            <a href="<%= request.getContextPath() %>/restaurant#restaurant-section" class="clay-btn clay-btn-secondary" title="Browse Restaurants">
                <span>&#127869;&#65039;</span>
                <span class="nav-text">Restaurants</span>
            </a>

            <% if (navUser != null) { %>
                <!-- Logged In: Orders Link -->
                <a href="<%= request.getContextPath() %>/orders" class="clay-btn clay-btn-secondary" title="My Orders">
                    <span>&#129534;</span>
                    <span class="nav-text">Orders</span>
                </a>

                <!-- Logged In: Profile Pill -->
                <a href="<%= request.getContextPath() %>/profile.jsp" class="clay-btn clay-btn-secondary" title="My Profile">
                    <span>&#128100;</span>
                    <span><%= (navUser.getUsername() != null && !navUser.getUsername().isEmpty()) ? navUser.getUsername() : "Profile" %></span>
                </a>
            <% } else { %>
                <!-- Not Logged In: Sign In -->
                <a href="<%= request.getContextPath() %>/login.jsp" class="clay-btn clay-btn-secondary" title="Sign In">
                    <span>&#128273;</span>
                    <span>Sign In</span>
                </a>

                <!-- Not Logged In: Sign Up -->
                <a href="<%= request.getContextPath() %>/register.jsp" class="clay-btn clay-btn-secondary" title="Create Account">
                    <span>&#10024;</span>
                    <span>Sign Up</span>
                </a>
            <% } %>

            <!-- Unified Secondary Food Delivery Bag Cart Pill with Live Count Badge -->
            <a href="<%= request.getContextPath() %>/cart.jsp" class="clay-btn clay-btn-secondary" title="Food Bag / Cart">
                <!-- Authentic Food Delivery Takeaway Bag Icon -->
                <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round" style="display:inline-block;vertical-align:middle;color:var(--clay-primary);">
                    <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/>
                    <line x1="3" y1="6" x2="21" y2="6"/>
                    <path d="M16 10a4 4 0 0 1-8 0"/>
                </svg>
                <span>Cart</span>
                <% if (navCartCount > 0) { %>
                    <span class="clay-badge-count-orange"><%= navCartCount %></span>
                <% } %>
            </a>

            <% if (navUser != null) { %>
                <!-- Logged In: Logout Button Placed After the Cart on the Right Side -->
                <button type="button" class="clay-btn clay-btn-danger" onclick="openLogoutModal()" title="Sign Out" style="padding:10px 14px;">
                    <span>&#128682;</span>
                    <span class="nav-hide-mobile">Logout</span>
                </button>
            <% } %>
        </div>
    </div>
</header>

<% if (navUser != null) { %>
<!-- Claymorphic Logout Confirmation Modal -->
<div id="logoutModal" class="clay-modal-overlay" onclick="handleLogoutOverlay(event)">
    <div class="clay-modal-box">
        <div style="width:54px;height:54px;border-radius:50%;background:#fee2e2;color:#dc2626;display:flex;align-items:center;justify-content:center;font-size:26px;margin:0 auto 14px;">
            &#128682;
        </div>
        <h3 style="font-size:20px;font-weight:800;color:#1e1b18;margin-bottom:8px;">Sign out of FlavorFleet?</h3>
        <p style="font-size:15px;color:#1e1b18;font-weight:500;line-height:1.6;margin-bottom:24px;">Are you sure you want to log out of your account?</p>
        <div style="display:flex;gap:12px;justify-content:center;">
            <button type="button" class="clay-btn clay-btn-secondary" onclick="closeLogoutModal()" style="flex:1;padding:11px;">Cancel</button>
            <a href="<%= request.getContextPath() %>/logout" class="clay-btn clay-btn-danger" style="flex:1;padding:11px;">Log Out</a>
        </div>
    </div>
</div>

<script>
    function openLogoutModal() {
        var modal = document.getElementById('logoutModal');
        if (modal) modal.classList.add('active');
    }

    function closeLogoutModal() {
        var modal = document.getElementById('logoutModal');
        if (modal) modal.classList.remove('active');
    }

    function handleLogoutOverlay(e) {
        if (e.target.id === 'logoutModal') {
            closeLogoutModal();
        }
    }

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeLogoutModal();
        }
    });
</script>
<% } %>
