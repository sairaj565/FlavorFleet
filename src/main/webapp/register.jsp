<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Join FlavorFleet | Create Account</title>

    <!-- Favicon -->
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/flavorfleet-logo.png?v=2">
    <link rel="shortcut icon" type="image/png" href="<%= request.getContextPath() %>/images/flavorfleet-logo.png?v=2">

    <!-- Master Common External Stylesheet -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Unified Reusable Navbar Component -->
    <jsp:include page="navbar.jsp" />

    <!-- Split-Screen Sign Up Showcase -->
    <main class="signup-grand-wrapper">
        <div class="signup-grand-card">
            
            <!-- Left: Hero Showcase Banner (100% Complete Composition) -->
            <section class="signup-hero-side">
                <img src="<%= request.getContextPath() %>/images/flavorfleet-signup-hero.png" 
                     alt="Good food, right to your door. Fresh meals. Local restaurants. Faster deliveries." 
                     class="signup-hero-banner-img">
            </section>

            <!-- Right: Sign Up Form Card -->
            <section class="signup-form-side">
                <!-- Sparkle Badge -->
                <div class="signup-sparkle-badge">
                    &#10024;
                </div>

                <h2 class="signup-form-title">Join FlavorFleet</h2>
                <p class="signup-form-sub">Create an account to order food and track deliveries</p>

                <!-- Notice when arriving from checkout -->
                <% 
                    String redirectParam = request.getParameter("redirect");
                    if (redirectParam != null && redirectParam.contains("checkout")) { 
                %>
                    <div class="clay-badge-orange" style="display:flex;align-items:center;justify-content:center;gap:8px;padding:10px 14px;border-radius:12px;margin-bottom:16px;font-size:12.5px;width:100%;font-weight:700;">
                        <span>&#128274;</span>
                        <span>Please sign up or sign in to complete your checkout</span>
                    </div>
                <% } %>

                <!-- Error Banner -->
                <% 
                    String error = (String) request.getAttribute("errorMessage");
                    if (error == null) error = request.getParameter("error");
                    if (error != null && !error.trim().isEmpty()) { 
                %>
                    <div class="clay-badge-orange" style="display:flex;align-items:center;justify-content:center;gap:8px;padding:10px 14px;border-radius:12px;margin-bottom:16px;font-size:12.5px;width:100%;">
                        <span>&#9888;&#65039;</span>
                        <span><%= error %></span>
                    </div>
                <% } %>

                <form action="<%= request.getContextPath() %>/register" method="post">
                    <input type="hidden" name="redirect" value="<%= request.getParameter("redirect") != null ? request.getParameter("redirect") : "" %>">

                    <div class="signup-grid">
                        <!-- Full Name -->
                        <div class="signup-field">
                            <label class="signup-label" for="username">Full Name</label>
                            <div class="signup-input-wrap">
                                <span class="signup-icon">&#128100;</span>
                                <input type="text" id="username" name="username" class="signup-input"
                                       placeholder="Enter your full name" required autofocus>
                            </div>
                        </div>

                        <!-- Email Address -->
                        <div class="signup-field">
                            <label class="signup-label" for="email">Email Address</label>
                            <div class="signup-input-wrap">
                                <span class="signup-icon">&#9993;&#65039;</span>
                                <input type="email" id="email" name="email" class="signup-input"
                                       placeholder="you@example.com" required>
                            </div>
                        </div>

                        <!-- Create Password -->
                        <div class="signup-field">
                            <label class="signup-label" for="password">Create Password</label>
                            <div class="signup-input-wrap">
                                <span class="signup-icon">&#128274;</span>
                                <input type="password" id="password" name="password" class="signup-input"
                                       placeholder="Create a strong password" minlength="4" required>
                                <button type="button" class="password-toggle-btn" onclick="togglePasswordVisibility('password', this)" title="Show password" aria-label="Show password">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                        <circle cx="12" cy="12" r="3"></circle>
                                    </svg>
                                </button>
                            </div>
                        </div>

                        <!-- Phone Number -->
                        <div class="signup-field">
                            <label class="signup-label" for="phone">Phone Number</label>
                            <div class="signup-input-wrap">
                                <span class="signup-icon">&#128222;</span>
                                <input type="tel" id="phone" name="phone" class="signup-input"
                                       placeholder="e.g. 9876543210">
                            </div>
                        </div>

                        <!-- Delivery Address (Full Width) -->
                        <div class="signup-field signup-col-span-2">
                            <label class="signup-label" for="address">Delivery Address</label>
                            <div class="signup-input-wrap">
                                <span class="signup-icon">&#128205;</span>
                                <input type="text" id="address" name="address" class="signup-input"
                                       placeholder="e.g. Indiranagar, Bengaluru">
                            </div>
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" class="signup-submit-btn">
                        Create Account &rarr;
                    </button>
                </form>

                <!-- OR Divider -->
                <div class="signup-or-divider">
                    <span>OR</span>
                </div>

                <!-- Footer Sign In Link -->
                <div class="signup-bottom-text">
                    Already have an account? <a href="<%= request.getContextPath() %>/login.jsp<%= request.getParameter("redirect") != null ? "?redirect=" + request.getParameter("redirect") : "" %>">Sign In</a>
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
