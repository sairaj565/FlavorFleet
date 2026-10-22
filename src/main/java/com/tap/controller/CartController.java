package com.tap.controller;

// Handles I/O operations and exceptions in servlet requests/responses
import java.io.IOException;

// Interface defining menu data operations (e.g. getMenu)
import com.tap.dao.MenuDao;
// Concrete database implementation of MenuDao using JDBC
import com.tap.daoImpl.MenuDaoImpl;
// Cart model class representing the user's shopping basket
import com.tap.model.Cart;
// Menu model class representing a dish/food item
import com.tap.model.Menu;

// Servlet API classes to handle HTTP requests, responses, and session state
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * CartController is the Servlet that handles shopping cart actions (add,
 * update, delete).
 * @WebServlet("/cart") maps any HTTP request to URL path "/cart" to this
 * controller.
 */
@WebServlet("/cart")
public class CartController extends HttpServlet {

    /**
     * Handles HTTP POST requests sent to "/cart" (e.g. adding or updating items).
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1. Read the hidden "action" parameter sent by the form (e.g. "add" or
        // "update")
        String action = req.getParameter("action");

        // 2. Extract menuId parameter safely (prevent NumberFormatException on empty string)
        String menuIdStr = req.getParameter("menuId");
        int menuId = 0;
        if (menuIdStr != null && !menuIdStr.trim().isEmpty()) {
            try {
                menuId = Integer.parseInt(menuIdStr.trim());
            } catch (NumberFormatException e) {
                menuId = 0;
            }
        }

        boolean isAjax = "XMLHttpRequest".equalsIgnoreCase(req.getHeader("X-Requested-With"))
                || "true".equalsIgnoreCase(req.getParameter("ajax"));

        // 3. Handle "add" action: adding a dish to the shopping cart
        if ("add".equals(action)) {

            // Create DAO instance to fetch dish details from MySQL
            MenuDao menuDao = new MenuDaoImpl();
            Menu menu = menuDao.getMenu(menuId);

            // Verify item exists and is marked available
            if (menu != null && menu.isAvailable()) {

                // Get current user session
                HttpSession session = req.getSession();

                // Retrieve cart from session
                Cart cart = (Cart) session.getAttribute("cart");

                // Initialize new cart if user doesn't have one yet
                if (cart == null) {
                    cart = new Cart();
                    session.setAttribute("cart", cart);
                }

                // Add item to cart (enforces single-restaurant restriction)
                boolean added = cart.addItem(menu);

                if (added) {
                    // Update cart in session
                    session.setAttribute("cart", cart);

                    if (isAjax) {
                        resp.setContentType("application/json");
                        resp.setCharacterEncoding("UTF-8");
                        resp.getWriter().write(String.format(
                                "{\"status\":\"success\",\"cartCount\":%d,\"totalAmount\":%.2f,\"itemQuantity\":%d}",
                                cart.getTotalQuantity(), cart.getTotalAmount(), cart.getItemQuantity(menuId)));
                        return;
                    }

                    resp.sendRedirect(
                            req.getContextPath()
                                    + "/menu?restaurantId="
                                    + menu.getRestaurantId());

                } else {
                    if (isAjax) {
                        resp.setContentType("application/json");
                        resp.setCharacterEncoding("UTF-8");
                        resp.getWriter().write("{\"status\":\"error\",\"message\":\"differentRestaurant\"}");
                        return;
                    }

                    // Item from different restaurant was rejected
                    resp.sendRedirect(
                            req.getContextPath()
                                    + "/menu?restaurantId="
                                    + menu.getRestaurantId()
                                    + "&cartError=differentRestaurant");

                }
            }
        }
        // 4. Handle "update" action: updating quantity of an existing item in cart
        else if ("update".equals(action)) {

            // Extract the new quantity value sent by the form safely
            String qtyStr = req.getParameter("quantity");
            int quantity = 0;
            if (qtyStr != null && !qtyStr.trim().isEmpty()) {
                try {
                    quantity = Integer.parseInt(qtyStr.trim());
                } catch (NumberFormatException e) {
                    quantity = 0;
                }
            }

            // Get current user session
            HttpSession session = req.getSession();

            // Retrieve existing cart from session
            Cart cart = (Cart) session.getAttribute("cart");

            // If cart exists, update the quantity for this menuId
            if (cart != null) {

                // Updates quantity, or removes item if quantity <= 0
                cart.updateQuantity(menuId, quantity);

                // Save updated cart back into session
                session.setAttribute("cart", cart);
            }

            if (isAjax) {
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.getWriter().write(String.format(
                        "{\"status\":\"success\",\"cartCount\":%d,\"totalAmount\":%.2f,\"itemQuantity\":%d}",
                        (cart != null ? cart.getTotalQuantity() : 0),
                        (cart != null ? cart.getTotalAmount() : 0.0),
                        (cart != null ? cart.getItemQuantity(menuId) : 0)));
                return;
            }

            // Check where the update request originated (e.g. "menu" page vs "cart" page)
            String from = req.getParameter("from");
            String restaurantId = req.getParameter("restaurantId");

            if ("menu".equals(from) && restaurantId != null && !restaurantId.trim().isEmpty()) {
                // If updated from menu page, stay on the menu page
                resp.sendRedirect(req.getContextPath() + "/menu?restaurantId=" + restaurantId.trim());
            } else {
                // Otherwise redirect back to the cart page to display updated quantities and total
                resp.sendRedirect(req.getContextPath() + "/cart.jsp");
            }

        }
        // 5. Handle "clear" action: completely wipe out all items from the cart
        else if ("clear".equals(action)) {

            // Get current user session
            HttpSession session = req.getSession();

            // Retrieve existing cart from session
            Cart cart = (Cart) session.getAttribute("cart");

            // If cart exists, clear all items and reset restaurant
            if (cart != null) {
                cart.clear();
                session.setAttribute("cart", cart);
            }

            // Redirect back to cart page
            resp.sendRedirect(
                    req.getContextPath() + "/cart.jsp");

        }

    }

    /**
     * Handles HTTP GET requests to "/cart".
     * Forwards the request internally to cart.jsp to display the user's cart.
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        RequestDispatcher rd = req.getRequestDispatcher("cart.jsp");
        rd.forward(req, resp);
    }
}
