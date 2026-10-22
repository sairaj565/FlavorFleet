<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.tap.model.Cart, com.tap.model.CartItem, com.tap.model.User" %>

        <% Cart cart=(Cart) session.getAttribute("cart"); 
        if (cart==null || cart.isEmpty()) {
          	response.sendRedirect(request.getContextPath() + "/cart.jsp" ); 
          	return; 
      	} 
        
        User user=(User)session.getAttribute("user"); 
        
        if (user==null) { 
        	response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=checkout.jsp" ); 
        	return; 
        	} 
        
        String defaultPhone=(user.getPhone() !=null) ? user.getPhone() : "" ; 
        String defaultAddress=(user.getAddress() !=null) ? user.getAddress() : "" ; 
        String defaultName=(user.getUsername() !=null) ? user.getUsername() : "" ; 
        double subtotal=cart.getTotalAmount();
       	double deliveryFee=(subtotal>= 500) ? 0.0 : 40.0;
  		double platformFee = 15.0;
        double grandTotal = subtotal + deliveryFee + platformFee;
        
        %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Checkout | FlavorFleet</title>

                <!-- Favicon -->
                <link rel="icon" type="image/png"
                    href="<%= request.getContextPath() %>/images/flavorfleet-logo.png?v=2">
                <link rel="shortcut icon" type="image/png"
                    href="<%= request.getContextPath() %>/images/flavorfleet-logo.png?v=2">

                <!-- Master Common External Stylesheet -->
                <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
            </head>

            <body>

                <!-- Unified Reusable Navbar Component -->
                <jsp:include page="navbar.jsp" />

                <main class="checkout-wrapper">
                    <h1 class="checkout-title">Complete Your Order</h1>

                    <form action="<%= request.getContextPath() %>/checkout" method="post">
                        <div class="checkout-layout">

                            <!-- Left Column -->
                            <div>
                                <!-- Delivery Card -->
                                <div class="clay-card" style="margin-bottom:24px;">
                                    <h2
                                        style="font-size:18px;font-weight:800;color:var(--clay-text-dark);margin-bottom:18px;">
                                        1. Delivery Details
                                    </h2>

                                    <div
                                        style="display:grid;grid-template-columns:1fr 1fr;gap:14px;margin-bottom:14px;">
                                        <div class="clay-input-group" style="margin:0;">
                                            <label class="clay-label">Full Name</label>
                                            <input type="text" name="fullName" class="clay-input"
                                                value="<%= defaultName %>" placeholder="Your Name" required>
                                        </div>
                                        <div class="clay-input-group" style="margin:0;">
                                            <label class="clay-label">Phone Number</label>
                                            <input type="tel" name="phone" class="clay-input"
                                                value="<%= defaultPhone %>" placeholder="10-digit mobile"
                                                pattern="[0-9]{10}" required>
                                        </div>
                                    </div>

                                    <div class="clay-input-group">
                                        <label class="clay-label">Complete Delivery Address</label>
                                        <textarea name="address" class="clay-textarea"
                                            placeholder="Flat, Street, Landmark..." required
                                            style="min-height:80px;"><%= defaultAddress %></textarea>
                                    </div>

                                    <div style="display:grid;grid-template-columns:1fr 1fr;gap:14px;">
                                        <div class="clay-input-group" style="margin:0;">
                                            <label class="clay-label">City</label>
                                            <input type="text" name="city" class="clay-input" value="Bengaluru"
                                                required>
                                        </div>
                                        <div class="clay-input-group" style="margin:0;">
                                            <label class="clay-label">Pincode</label>
                                            <input type="text" name="pincode" class="clay-input"
                                                placeholder="e.g. 560001" pattern="[0-9]{6}" required>
                                        </div>
                                    </div>
                                </div>

                                <!-- Payment Method Card -->
                                <div class="clay-card">
                                    <h2
                                        style="font-size:18px;font-weight:800;color:var(--clay-text-dark);margin-bottom:18px;">
                                        2. Payment Method
                                    </h2>

                                    <label class="clay-payment-pill selected" onclick="selectPay(this)">
                                        <input type="radio" name="paymentMode" value="Cash on Delivery" checked
                                            style="accent-color:var(--clay-primary);">
                                        <div>
                                            <div style="font-size:15px;font-weight:800;color:var(--clay-text-dark);">
                                                &#128181; Cash on Delivery (COD)</div>
                                            <div style="font-size:12px;color:var(--clay-text-muted);">Pay with cash or
                                                UPI upon delivery</div>
                                        </div>
                                    </label>

                                    <label class="clay-payment-pill" onclick="selectPay(this)">
                                        <input type="radio" name="paymentMode" value="UPI"
                                            style="accent-color:var(--clay-primary);">
                                        <div>
                                            <div style="font-size:15px;font-weight:800;color:var(--clay-text-dark);">
                                                &#128241; UPI (GPay, PhonePe, Paytm)</div>
                                            <div style="font-size:12px;color:var(--clay-text-muted);">Direct and fast
                                                UPI payment</div>
                                        </div>
                                    </label>

                                    <label class="clay-payment-pill" onclick="selectPay(this)">
                                        <input type="radio" name="paymentMode" value="Credit/Debit Card"
                                            style="accent-color:var(--clay-primary);">
                                        <div>
                                            <div style="font-size:15px;font-weight:800;color:var(--clay-text-dark);">
                                                &#128179; Credit / Debit Card</div>
                                            <div style="font-size:12px;color:var(--clay-text-muted);">Visa, MasterCard,
                                                RuPay</div>
                                        </div>
                                    </label>
                                </div>
                            </div>

                            <!-- Right Column: Sticky Summary -->
                            <div class="clay-card" style="position:sticky;top:90px;">
                                <h2
                                    style="font-size:18px;font-weight:800;color:var(--clay-text-dark);margin-bottom:16px;">
                                    Order Summary
                                </h2>

                                <!-- Items List -->
                                <div style="max-height:220px;overflow-y:auto;margin-bottom:16px;">
                                    <% for (CartItem item : cart.getItems()) { String
                                        imgPath=item.getMenu().getImagePath(); String cleanImg=(imgPath==null) ? "" :
                                        imgPath.replaceFirst("^/+", "" ); String imgUrl=request.getContextPath() + "/" +
                                        cleanImg; %>
                                        <div class="summary-item-row">
                                            <div style="display:flex;align-items:center;gap:10px;">
                                                <img src="<%= imgUrl %>" alt="<%= item.getMenu().getItemName() %>"
                                                    class="summary-img"
                                                    onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/flavorfleet-logo.jpg';">
                                                <div>
                                                    <div style="font-size:14px;font-weight:700;">
                                                        <%= item.getMenu().getItemName() %>
                                                    </div>
                                                    <div style="font-size:12px;color:var(--clay-text-muted);">&#8377;<%=
                                                            String.format("%.2f", item.getMenu().getPrice()) %> &times;
                                                            <%= item.getQuantity() %>
                                                    </div>
                                                </div>
                                            </div>
                                            <div style="font-size:14px;font-weight:800;color:var(--clay-text-dark);">
                                                &#8377;<%= String.format("%.2f", item.getSubtotal()) %>
                                            </div>
                                        </div>
                                        <% } %>
                                </div>

                                <!-- Bill Breakdown -->
                                <div class="bill-line">
                                    <span>Items Total</span>
                                    <span>&#8377;<%= String.format("%.2f", subtotal) %></span>
                                </div>
                                <div class="bill-line">
                                    <span>Delivery Fee</span>
                                    <span style="<%= deliveryFee == 0 ? " color:var(--clay-green);font-weight:800;" : ""
                                        %>">
                                        <%= deliveryFee==0 ? "FREE" : ("&#8377;" + String.format("%.2f", deliveryFee))
                                            %>
                                    </span>
                                </div>
                                <div class="bill-line">
                                    <span>Platform Handling Fee</span>
                                    <span>&#8377;<%= String.format("%.2f", platformFee) %></span>
                                </div>

                                <div
                                    style="display:flex;justify-content:space-between;align-items:center;padding-top:14px;margin-top:10px;border-top:1.5px solid var(--clay-border-soft);margin-bottom:20px;">
                                    <span style="font-size:16px;font-weight:800;">To Pay</span>
                                    <span style="font-size:22px;font-weight:800;color:var(--clay-primary);">&#8377;<%=
                                            String.format("%.2f", grandTotal) %></span>
                                </div>

                                <button type="submit" class="clay-btn clay-btn-primary"
                                    style="width:100%;padding:14px;border-radius:14px;font-size:16px;">
                                    Place Order &rarr;
                                </button>
                            </div>

                        </div>
                    </form>
                </main>

                <!-- Unified Reusable Footer Component -->
                <jsp:include page="footer.jsp" />

                <script>
                    function selectPay(el) {
                        document.querySelectorAll('.clay-payment-pill').forEach(p => p.classList.remove('selected'));
                        el.classList.add('selected');
                    }
                </script>
            </body>

            </html>