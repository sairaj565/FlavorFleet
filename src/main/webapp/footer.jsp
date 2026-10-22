<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<footer class="clay-footer">
    <div class="clay-footer-inner">
        <div class="clay-footer-top">
            <div style="display:flex;align-items:center;gap:12px;">
                <img src="<%= request.getContextPath() %>/images/flavorfleet-logo.png?v=2" alt="FlavorFleet"
                     style="height:40px;width:40px;border-radius:12px;object-fit:cover;"
                     onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/flavorfleet-logo.jpg';">
                <div>
                    <div class="clay-footer-logo">Flavor<span>Fleet</span></div>
                    <div style="font-size:13px;color:#a8a29e;">Delicious meals crafted with care, delivered fast.</div>
                </div>
            </div>
            <div style="font-size:13px;color:#78716c;">
                Crafted for genuine food lovers &#127858;
            </div>
        </div>
        <div class="clay-footer-bottom">
            &copy; 2026 FlavorFleet Technologies Pvt. Ltd. All rights reserved.
        </div>
    </div>
</footer>
