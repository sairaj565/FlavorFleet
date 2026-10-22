<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.tap.model.Menu, com.tap.model.Cart" %>

<%
    List<Menu> menuList = (List<Menu>) request.getAttribute("allMenu");

    String restaurantId = request.getParameter("restaurantId");
    if ((restaurantId == null || restaurantId.trim().isEmpty()) && menuList != null && !menuList.isEmpty()) {
        restaurantId = String.valueOf(menuList.get(0).getRestaurantId());
    }

    Cart cart = (Cart) session.getAttribute("cart");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menu | FlavorFleet</title>

    <!-- Favicon -->
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/flavorfleet-logo.png?v=2">
    <link rel="shortcut icon" type="image/png" href="<%= request.getContextPath() %>/images/flavorfleet-logo.png?v=2">

    <!-- Master Common External Stylesheet -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Unified Reusable Navbar Component -->
    <jsp:include page="navbar.jsp" />

    <!-- Hero Section -->
    <section class="menu-hero">
        <div class="menu-hero-inner">
            <div>
                <h1>Fresh & Handcrafted <span>Menu</span></h1>
                <p>Authentic recipes cooked fresh to order. Pick your favorites below.</p>
            </div>

            <!-- Search -->
            <div class="search-bar-clay">
                <span style="font-size:16px;color:#a8a29e;margin-right:8px;">&#128269;</span>
                <input type="search" id="menuSearch" placeholder="Search dishes by name..." aria-label="Search menu">
            </div>
        </div>
    </section>

    <!-- Main Content -->
    <main class="main-container">

        <!-- Error Notification for Different Restaurant -->
        <% if ("differentRestaurant".equals(request.getParameter("cartError"))) { %>
            <div class="clay-card" style="background:#fef2f2;border-color:#fca5a5;padding:14px 20px;margin-bottom:24px;display:flex;align-items:center;justify-content:space-between;gap:12px;">
                <span style="color:#991b1b;font-weight:700;font-size:14px;">
                    &#9888;&#65039; Your cart already contains dishes from another restaurant. Please clear your cart first before ordering from here.
                </span>
                <a href="<%= request.getContextPath() %>/cart.jsp" class="clay-btn clay-btn-danger" style="padding:6px 14px;font-size:12px;">
                    View Cart
                </a>
            </div>
        <% } %>

        <div class="menu-header-row">
            <h2 class="menu-title">
                Available Dishes
                <span class="clay-badge clay-badge-orange">
                    <%= (menuList != null) ? menuList.size() : 0 %> items
                </span>
            </h2>

            <a href="<%= request.getContextPath() %>/restaurant" class="clay-btn clay-btn-secondary" style="font-size:13px;padding:8px 14px;">
                &larr; All Restaurants
            </a>
        </div>

        <!-- Dishes Grid -->
        <div class="dish-grid" id="dishGrid">
            <% if (menuList != null && !menuList.isEmpty()) {
                   for (Menu m : menuList) {
                       String imgPath = m.getImagePath();
                       String cleanImg = (imgPath == null) ? "" : imgPath.replaceFirst("^/+", "");
                       String imgUrl = request.getContextPath() + "/" + cleanImg;
                       int currentQty = (cart != null) ? cart.getItemQuantity(m.getMenuId()) : 0;
            %>
                <article class="dish-clay-card" data-name="<%= m.getItemName().toLowerCase() %>">
                    <div class="dish-img-box">
                        <img class="dish-img" src="<%= imgUrl %>" alt="<%= m.getItemName() %>" loading="lazy"
                             onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/flavorfleet-logo.jpg';">
                    </div>

                    <div class="dish-content">
                        <h3 class="dish-name"><%= m.getItemName() %></h3>
                        <p class="dish-desc"><%= (m.getDescription() != null && !m.getDescription().isEmpty()) ? m.getDescription() : "Delicious and freshly prepared with authentic ingredients." %></p>

                        <div class="dish-footer">
                            <span class="dish-price">&#8377;<%= String.format("%.2f", m.getPrice()) %></span>

                            <!-- Add Button OR Clay Stepper Container -->
                            <div class="dish-action-container" id="dish-action-<%= m.getMenuId() %>">
                                <% if (!m.isAvailable()) { %>
                                    <button type="button" class="btn-add-dish" disabled>Unavailable</button>
                                <% } else if (currentQty > 0) { %>
                                    <!-- Claymorphic Stepper [ - qty + ] -->
                                    <div class="clay-qty-control">
                                        <form action="cart" method="post" class="clay-qty-form" onsubmit="handleMenuCartAction(event, this, <%= m.getMenuId() %>, <%= currentQty - 1 %>, '<%= restaurantId %>')">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="from" value="menu">
                                            <input type="hidden" name="menuId" value="<%= m.getMenuId() %>">
                                            <input type="hidden" name="restaurantId" value="<%= restaurantId %>">
                                            <input type="hidden" name="quantity" value="<%= currentQty - 1 %>">
                                            <button type="submit" class="clay-qty-btn" title="Decrease">&minus;</button>
                                        </form>

                                        <span class="clay-qty-count"><%= currentQty %></span>

                                        <form action="cart" method="post" class="clay-qty-form" onsubmit="handleMenuCartAction(event, this, <%= m.getMenuId() %>, <%= currentQty + 1 %>, '<%= restaurantId %>')">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="from" value="menu">
                                            <input type="hidden" name="menuId" value="<%= m.getMenuId() %>">
                                            <input type="hidden" name="restaurantId" value="<%= restaurantId %>">
                                            <input type="hidden" name="quantity" value="<%= currentQty + 1 %>">
                                            <button type="submit" class="clay-qty-btn" title="Increase">&#43;</button>
                                        </form>
                                    </div>
                                <% } else { %>
                                    <form action="cart" method="post" style="margin:0;" onsubmit="handleMenuCartAction(event, this, <%= m.getMenuId() %>, 1, '<%= restaurantId %>')">
                                        <input type="hidden" name="menuId" value="<%= m.getMenuId() %>">
                                        <input type="hidden" name="restaurantId" value="<%= restaurantId %>">
                                        <input type="hidden" name="action" value="add">
                                        <input type="hidden" name="quantity" value="1">
                                        <button type="submit" class="btn-add-dish">Add +</button>
                                    </form>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </article>
            <%   }
               } %>
        </div>

        <!-- Empty Filter State -->
        <div id="emptyMessage" class="clay-card" style="display:none;text-align:center;padding:50px 20px;max-width:440px;margin:30px auto;">
            <div style="font-size:42px;margin-bottom:10px;">&#127829;</div>
            <h3 style="font-size:18px;margin-bottom:6px;">No Dishes Found</h3>
            <p style="color:#78716c;font-size:13px;">Try searching with a different keyword.</p>
        </div>

    </main>

    <!-- Claymorphic Different Restaurant Modal -->
    <div id="diffRestaurantModal" class="clay-modal-overlay" onclick="handleDiffModalOverlay(event)">
        <div class="clay-modal-box">
            <div style="width:56px;height:56px;border-radius:50%;background:#fff1eb;color:var(--clay-primary);display:flex;align-items:center;justify-content:center;font-size:28px;margin:0 auto 14px;box-shadow:0 8px 18px rgba(255, 94, 40, 0.2);">
                &#127858;
            </div>
            <h3 style="font-size:20px;font-weight:800;color:#1e1b18;margin-bottom:8px;">Replace Cart Items?</h3>
            <p style="font-size:15px;color:#1e1b18;font-weight:500;line-height:1.6;margin-bottom:24px;">
                Your cart already contains dishes from another restaurant. Please view your cart to review or clear it before ordering from here.
            </p>
            <div style="display:flex;gap:12px;justify-content:center;">
                <button type="button" class="clay-btn clay-btn-secondary" onclick="closeDiffRestaurantModal()" style="flex:1;padding:11px;">
                    Keep Cart
                </button>
                <a href="<%= request.getContextPath() %>/cart.jsp" class="clay-btn clay-btn-primary" style="flex:1;padding:11px;">
                    View Cart &rarr;
                </a>
            </div>
        </div>
    </div>

    <!-- Unified Reusable Footer Component -->
    <jsp:include page="footer.jsp" />

    <!-- In-Place Seamless Cart Scripts (Zero Page Movement) -->
    <script>
        // Dish Search Filter
        const searchInput = document.getElementById("menuSearch");
        const cards = document.querySelectorAll(".dish-clay-card");
        const emptyMessage = document.getElementById("emptyMessage");

        if (searchInput) {
            searchInput.addEventListener("input", function () {
                const query = this.value.toLowerCase().trim();
                let visibleCount = 0;

                cards.forEach(card => {
                    const name = card.dataset.name || "";
                    const matches = name.includes(query);
                    card.style.display = matches ? "flex" : "none";
                    if (matches) visibleCount++;
                });

                if (emptyMessage) {
                    emptyMessage.style.display = (visibleCount === 0) ? "block" : "none";
                }
            });
        }

        // Seamless In-Place Cart Action (Page Never Jumps or Scrolls)
        function handleMenuCartAction(event, form, menuId, newQty, restaurantId) {
            if (event) event.preventDefault();

            const formData = new FormData(form);
            formData.append('ajax', 'true');

            fetch('<%= request.getContextPath() %>/cart', {
                method: 'POST',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: new URLSearchParams(formData)
            })
            .then(res => res.json())
            .then(data => {
                if (data.status === 'success') {
                    renderDishControl(menuId, data.itemQuantity, restaurantId);
                    updateNavCartBadge(data.cartCount);
                } else if (data.message === 'differentRestaurant') {
                    openDiffRestaurantModal();
                }
            })
            .catch(err => {
                console.error('Cart update error:', err);
                form.submit();
            });
        }

        // Re-renders the button or stepper in place without changing scroll position
        function renderDishControl(menuId, qty, restaurantId) {
            const container = document.getElementById('dish-action-' + menuId);
            if (!container) return;

            const safeMenuId = parseInt(menuId, 10);
            const safeQty = parseInt(qty, 10);
            const decQty = safeQty - 1;
            const incQty = safeQty + 1;
            const safeRestId = restaurantId || '<%= (restaurantId != null) ? restaurantId : "" %>';

            if (safeQty > 0) {
                container.innerHTML = 
                    '<div class="clay-qty-control">' +
                        '<form action="cart" method="post" class="clay-qty-form" onsubmit="handleMenuCartAction(event, this, ' + safeMenuId + ', ' + decQty + ', \'' + safeRestId + '\')">' +
                            '<input type="hidden" name="action" value="update">' +
                            '<input type="hidden" name="from" value="menu">' +
                            '<input type="hidden" name="menuId" value="' + safeMenuId + '">' +
                            '<input type="hidden" name="restaurantId" value="' + safeRestId + '">' +
                            '<input type="hidden" name="quantity" value="' + decQty + '">' +
                            '<button type="submit" class="clay-qty-btn" title="Decrease">&minus;</button>' +
                        '</form>' +
                        '<span class="clay-qty-count">' + safeQty + '</span>' +
                        '<form action="cart" method="post" class="clay-qty-form" onsubmit="handleMenuCartAction(event, this, ' + safeMenuId + ', ' + incQty + ', \'' + safeRestId + '\')">' +
                            '<input type="hidden" name="action" value="update">' +
                            '<input type="hidden" name="from" value="menu">' +
                            '<input type="hidden" name="menuId" value="' + safeMenuId + '">' +
                            '<input type="hidden" name="restaurantId" value="' + safeRestId + '">' +
                            '<input type="hidden" name="quantity" value="' + incQty + '">' +
                            '<button type="submit" class="clay-qty-btn" title="Increase">&#43;</button>' +
                        '</form>' +
                    '</div>';
            } else {
                container.innerHTML = 
                    '<form action="cart" method="post" style="margin:0;" onsubmit="handleMenuCartAction(event, this, ' + safeMenuId + ', 1, \'' + safeRestId + '\')">' +
                        '<input type="hidden" name="menuId" value="' + safeMenuId + '">' +
                        '<input type="hidden" name="restaurantId" value="' + safeRestId + '">' +
                        '<input type="hidden" name="from" value="menu">' +
                        '<input type="hidden" name="action" value="add">' +
                        '<input type="hidden" name="quantity" value="1">' +
                        '<button type="submit" class="btn-add-dish">Add +</button>' +
                    '</form>';
            }
        }

        // Live update for Cart count badge in navbar
        function updateNavCartBadge(count) {
            const cartPills = document.querySelectorAll('a[href*="cart.jsp"]');
            cartPills.forEach(cartPill => {
                let badge = cartPill.querySelector('.clay-badge-count-orange, .clay-badge-count');
                if (count > 0) {
                    if (!badge) {
                        badge = document.createElement('span');
                        badge.className = 'clay-badge-count-orange';
                        cartPill.appendChild(badge);
                    }
                    badge.textContent = count;
                } else {
                    if (badge) badge.remove();
                }
            });
        }

        // Different Restaurant Modal Handlers
        function openDiffRestaurantModal() {
            const modal = document.getElementById('diffRestaurantModal');
            if (modal) modal.classList.add('active');
        }

        function closeDiffRestaurantModal() {
            const modal = document.getElementById('diffRestaurantModal');
            if (modal) modal.classList.remove('active');
        }

        function handleDiffModalOverlay(e) {
            if (e.target.id === 'diffRestaurantModal') {
                closeDiffRestaurantModal();
            }
        }

        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') closeDiffRestaurantModal();
        });

        // If navigated with error parameter in URL, pop up the modal automatically
        window.addEventListener('DOMContentLoaded', function () {
            const params = new URLSearchParams(window.location.search);
            if (params.get('cartError') === 'differentRestaurant') {
                openDiffRestaurantModal();
            }
        });
    </script>
</body>
</html>
