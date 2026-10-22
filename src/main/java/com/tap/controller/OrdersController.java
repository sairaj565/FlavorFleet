package com.tap.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.tap.dao.MenuDao;
import com.tap.dao.OrderDao;
import com.tap.dao.OrderItemDao;
import com.tap.dao.RestaurantDao;
import com.tap.daoImpl.MenuDaoImpl;
import com.tap.daoImpl.OrderDaoImpl;
import com.tap.daoImpl.OrderItemDaoImpl;
import com.tap.daoImpl.RestaurantDaoImpl;
import com.tap.model.Menu;
import com.tap.model.Order;
import com.tap.model.OrderItem;
import com.tap.model.Restaurant;
import com.tap.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet({ "/orders", "/orderHistory", "/OrdersController" })
public class OrdersController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User loggedInUser = (session != null) ? (User) session.getAttribute("user") : null;

        // If user not logged in, redirect to login
        if (loggedInUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?redirect=orders");
            return;
        }

        // Create DAOs
        OrderDao orderDao = new OrderDaoImpl();
        OrderItemDao orderItemDao = new OrderItemDaoImpl();
        RestaurantDao restaurantDao = new RestaurantDaoImpl();
        MenuDao menuDao = new MenuDaoImpl();

        // Get all orders of logged-in user
        List<Order> orders = orderDao.getOrdersByUserId(loggedInUser.getUserId());

        // Store restaurant details
        Map<Integer, Restaurant> restaurantMap = new HashMap<>();

        // Store order items for each order
        Map<Integer, List<OrderItem>> orderItemsMap = new HashMap<>();

        // Store menu details
        Map<Integer, Menu> menuMap = new HashMap<>();

        // Process every order
        if (orders != null) {
            for (Order order : orders) {

                // Get restaurant
                Restaurant restaurant = restaurantDao.getRestaurant(order.getRestaurantId());
                if (restaurant != null) {
                    restaurantMap.put(order.getRestaurantId(), restaurant);
                }

                // Get order items
                List<OrderItem> orderItems = orderItemDao.getOrderItemsByOrderId(order.getOrderId());
                orderItemsMap.put(order.getOrderId(), orderItems);

                // Get menu details for every order item
                if (orderItems != null) {
                    for (OrderItem orderItem : orderItems) {
                        int menuId = orderItem.getMenuId();

                        if (!menuMap.containsKey(menuId)) {
                            Menu menu = menuDao.getMenu(menuId);
                            if (menu != null) {
                                menuMap.put(menuId, menu);
                            }
                        }
                    }
                }
            }
        }

        // Send data to JSP
        req.setAttribute("orders", orders);
        req.setAttribute("restaurantMap", restaurantMap);
        req.setAttribute("orderItemsMap", orderItemsMap);
        req.setAttribute("menuMap", menuMap);

        // Forward to orders.jsp
        RequestDispatcher rd = req.getRequestDispatcher("orders.jsp");
        rd.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
