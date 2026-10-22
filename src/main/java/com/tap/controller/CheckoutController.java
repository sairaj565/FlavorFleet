package com.tap.controller;

import java.io.IOException;
import java.sql.Timestamp;

import com.tap.dao.OrderDao;
import com.tap.dao.OrderItemDao;
import com.tap.daoImpl.OrderDaoImpl;
import com.tap.daoImpl.OrderItemDaoImpl;
import com.tap.model.Cart;
import com.tap.model.CartItem;
import com.tap.model.Order;
import com.tap.model.OrderItem;
import com.tap.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * CheckoutController handles:
 * 1. GET requests: validates cart and loads the checkout.jsp page.
 * 2. POST requests: receives address & payment mode, creates the Order and
 * OrderItems in the database, clears the cart, and forwards to order
 * confirmation.
 */
@WebServlet({ "/checkout", "/CheckoutController" })
public class CheckoutController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private OrderDao orderDao;
    private OrderItemDao orderItemDao;

    @Override
    public void init() throws ServletException {
        // Initialize DAOs for database operations
        orderDao = new OrderDaoImpl();
        orderItemDao = new OrderItemDaoImpl();
    }

    /**
     * Handles GET /checkout
     * Checks if the cart exists and is not empty before showing checkout.jsp.
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        // 1. If cart is null or empty, redirect back to cart page
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart.jsp");
            return;
        }

        // 2. User authentication check (Swiggy/Zomato style)
        User user = (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?redirect=checkout.jsp");
            return;
        }

        // 3. Forward user to checkout.jsp
        req.getRequestDispatcher("checkout.jsp").forward(req, resp);
    }

    /**
     * Handles POST /checkout
     * Reads delivery details & payment method, saves Order & OrderItems, and clears
     * cart.
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        User user = (User) session.getAttribute("user");

        // 1. Validate user is logged in
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?redirect=checkout.jsp");
            return;
        }

        // 2. Validate cart exists
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart.jsp");
            return;
        }

        // 3. Get payment mode and address from checkout.jsp
        String paymentMode = req.getParameter("paymentMode");
        String address = req.getParameter("address");

        // 4. Validate payment mode
        if (paymentMode == null || paymentMode.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/checkout.jsp");
            return;
        }

        // Calculate final bill (subtotal + delivery fee + platform fee) to match checkout page
        double subtotal = cart.getTotalAmount();
        double deliveryFee = (subtotal >= 500) ? 0.0 : 40.0;
        double platformFee = 15.0;
        double grandTotal = subtotal + deliveryFee + platformFee;

        // 5. Create Order object
        Order order = new Order();
        order.setRestaurantId(cart.getRestaurantId());
        order.setUserId(user.getUserId());
        order.setTotalAmount(grandTotal);
        order.setStatus("PLACED");
        order.setPaymentMode(paymentMode);
        order.setOrderDate(new Timestamp(System.currentTimeMillis()));

        // 6. Insert Order and get generated orderId
        int orderId = orderDao.addOrder(order);

        // 7. Check whether Order was successfully created
        if (orderId <= 0) {
            req.setAttribute("checkoutError", "Unable to place the order. Please try again.");
            req.setAttribute("cart", cart);
            RequestDispatcher rd = req.getRequestDispatcher("checkout.jsp");
            rd.forward(req, resp);
            return;
        }

        // 8. Insert every CartItem into OrderItem table
        for (CartItem cartItem : cart.getItems()) {
            OrderItem orderItem = new OrderItem();
            orderItem.setOrderId(orderId);
            orderItem.setMenuId(cartItem.getMenu().getMenuId());
            orderItem.setQuantity(cartItem.getQuantity());
            orderItem.setItemTotal(cartItem.getSubtotal());

            orderItemDao.addOrderItem(orderItem);
        }

        // 9. Clear cart after successful order
        cart.clear();
        session.setAttribute("cart", cart);

        // 10. Store order details in session for confirmation page
        session.setAttribute("orderId", orderId);
        session.setAttribute("latestOrder", order);
        session.setAttribute("deliveryAddress", address);

        // 11. Redirect to order confirmation page
        resp.sendRedirect(req.getContextPath() + "/order_confirmation.jsp");
    }
}
