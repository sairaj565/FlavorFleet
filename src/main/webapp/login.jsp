<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String redirectParam = request.getParameter("redirect");
    String redirectVal = (redirectParam != null) ? redirectParam : "";
    boolean fromCheckout = (redirectParam != null && redirectParam.contains("checkout"));

    String error = (String) request.getAttribute("errorMessage");
    if (error == null) {
        error = request.getParameter("error");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In | FlavorFleet</title>

    <!-- Favicon -->
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/flavorfleet-logo.png?v=2">
    <link rel="shortcut icon" type="image/png" href="<%= request.getContextPath() %>/images/flavorfleet-logo.png?v=2">

    <!-- Master Common External Stylesheet -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Unified Reusable Navbar Component -->
    <jsp:include page="navbar.jsp" />

    <!-- Split-Screen Sign In Showcase (Left Hero Image, Right Form) -->
    <main class="login-grand-wrapper">
        <div class="login-grand-card">

            <!-- Left: Hero Showcase Banner (55% width, 100% Complete Composition) -->
            <section class="login-hero-side">
                <img src="<%= request.getContextPath() %>/images/flavorfleet-login-hero.jpg" 
                     alt="Welcome back, good food awaits! Delicious food. Local restaurants. Faster deliveries." 
                     class="login-hero-banner-img">
            </section>

            <!-- Right: Login Form Panel (45% width) -->
            <section class="login-form-side">
                <div class="login-form-container">
                    <!-- Mascot Badge -->
                    <div class="login-badge-icon">
                        &#127828;
                    </div>

                    <h1 class="login-title">Welcome Back!</h1>
                    <p class="login-subtitle">Please sign in to order your favourite food</p>

                    <!-- Notice when arriving from checkout -->
                    <% if (fromCheckout) { %>
                        <div class="clay-badge-orange" style="display:flex;align-items:center;justify-content:center;gap:8px;padding:11px 16px;border-radius:14px;margin-bottom:18px;font-size:13px;width:100%;font-weight:700;">
                            <span>&#128274;</span>
                            <span>Please sign in or create an account to place your order</span>
                        </div>
                    <% } %>

                    <!-- Error Banner -->
                    <% if (error != null && !error.trim().isEmpty()) { %>
                        <div class="clay-badge-orange" style="display:flex;align-items:center;justify-content:center;gap:8px;padding:10px 14px;border-radius:12px;margin-bottom:18px;font-size:13px;width:100%;">
                            <span>&#9888;&#65039;</span>
                            <span><%= error %></span>
                        </div>
                    <% } %>

                    <form action="<%= request.getContextPath() %>/login" method="post">
                        <input type="hidden" name="redirect" value="<%= redirectVal %>">

                        <div class="input-box-clay">
                            <span class="input-icon">&#128100;</span>
                            <input type="email" id="email" name="email" class="input-clay"
                                   placeholder="Username / Email" required autofocus>
                        </div>

                        <div class="input-box-clay">
                            <span class="input-icon">&#128274;</span>
                            <input type="password" id="password" name="password" class="input-clay"
                                   placeholder="Password" required>
                            <button type="button" class="password-toggle-btn" onclick="togglePasswordVisibility('password', this)" title="Show password" aria-label="Show password">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                    <circle cx="12" cy="12" r="3"></circle>
                                </svg>
                            </button>
                        </div>

                        <button type="submit" class="clay-btn clay-btn-primary" style="width:100%;padding:14px;border-radius:16px;font-size:15px;margin-top:6px;cursor:pointer;">
                            Sign In &rarr;
                        </button>
                    </form>

                    <div style="margin-top:22px;font-size:13.5px;color:#78716c;text-align:center;">
                        Don't have an account? <a href="<%= request.getContextPath() %>/register.jsp<%= !redirectVal.isEmpty() ? "?redirect=" + redirectVal : "" %>" style="color:var(--clay-primary);font-weight:700;text-decoration:none;">Sign Up</a>
                    </div>
                </div>
            </section>

        </div>
    </main>

    <!-- Unified Reusable Footer Component -->
    <jsp:include page="footer.jsp" />

    <script>
        function togglePasswordVisibility(inputId, btn) {
            const input = document.getElementById(inputId);
            if (!input) return;

            const isPassword = input.type === 'password';
            input.type = isPassword ? 'text' : 'password';

            btn.setAttribute('aria-label', isPassword ? 'Hide password' : 'Show password');
            btn.setAttribute('title', isPassword ? 'Hide password' : 'Show password');

            if (isPassword) {
                // Eye-off icon (password shown)
                btn.innerHTML = '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path><line x1="1" y1="1" x2="23" y2="23"></line></svg>';
            } else {
                // Eye icon (password masked)
                btn.innerHTML = '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>';
            }
        }
    </script>

</body>
</html>