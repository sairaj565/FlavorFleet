package com.tap.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
//import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.OrderDao;
import com.tap.model.Order;
import com.tap.util.DBConnection;

public class OrderDaoImpl implements OrderDao {

    private static final String INSERT_ORDER = "INSERT INTO orders (restaurantId, userId, totalAmount, status, paymentMode, orderDate) "
            + "VALUES (?, ?, ?, ?, ?, ?)";

    private static final String SELECT_ORDER = "SELECT * FROM orders WHERE orderId = ?";

    private static final String UPDATE_ORDER = "UPDATE orders SET restaurantId = ?, userId = ?, totalAmount = ?, "
            + "status = ?, paymentMode = ?, orderDate = ? WHERE orderId = ?";

    private static final String DELETE_ORDER = "DELETE FROM orders WHERE orderId = ?";

    private static final String SELECT_ALL_ORDERS = "SELECT * FROM orders";

    private static final String SELECT_ORDERS_BY_USER = "SELECT * FROM orders WHERE userId = ?";

    @Override
    public int addOrder(Order order) {

        int generatedOrderId = 0;

        try (Connection con = DBConnection.getConnection();
                PreparedStatement pstmt = con.prepareStatement(INSERT_ORDER, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, order.getRestaurantId());
            pstmt.setInt(2, order.getUserId());
            pstmt.setDouble(3, order.getTotalAmount());
            pstmt.setString(4, order.getStatus());
            pstmt.setString(5, order.getPaymentMode());
            pstmt.setTimestamp(6, order.getOrderDate());

            pstmt.executeUpdate();

            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    generatedOrderId = rs.getInt(1);
                    order.setOrderId(generatedOrderId);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return generatedOrderId;
    }

    @Override
    public Order getOrder(int orderId) {

        Order order = null;

        try (Connection con = DBConnection.getConnection();
                PreparedStatement pstmt = con.prepareStatement(SELECT_ORDER)) {

            pstmt.setInt(1, orderId);

            try (ResultSet rs = pstmt.executeQuery()) {

                if (rs.next()) {

                    order = new Order();

                    order.setOrderId(rs.getInt("orderId"));
                    order.setRestaurantId(rs.getInt("restaurantId"));
                    order.setUserId(rs.getInt("userId"));
                    order.setTotalAmount(rs.getDouble("totalAmount"));
                    order.setStatus(rs.getString("status"));
                    order.setPaymentMode(rs.getString("paymentMode"));
                    order.setOrderDate(rs.getTimestamp("orderDate"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return order;
    }

    @Override
    public void updateOrder(Order order) {

        try (Connection con = DBConnection.getConnection();
                PreparedStatement pstmt = con.prepareStatement(UPDATE_ORDER)) {

            pstmt.setInt(1, order.getRestaurantId());
            pstmt.setInt(2, order.getUserId());
            pstmt.setDouble(3, order.getTotalAmount());
            pstmt.setString(4, order.getStatus());
            pstmt.setString(5, order.getPaymentMode());
            pstmt.setTimestamp(6, order.getOrderDate());
            pstmt.setInt(7, order.getOrderId());

            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteOrder(int orderId) {

        try (Connection con = DBConnection.getConnection();
                PreparedStatement pstmt = con.prepareStatement(DELETE_ORDER)) {

            pstmt.setInt(1, orderId);

            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Order> getAllOrders() {

        List<Order> orders = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
                PreparedStatement pstmt = con.prepareStatement(SELECT_ALL_ORDERS);
                ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {

                Order order = new Order();

                order.setOrderId(rs.getInt("orderId"));
                order.setRestaurantId(rs.getInt("restaurantId"));
                order.setUserId(rs.getInt("userId"));
                order.setTotalAmount(rs.getDouble("totalAmount"));
                order.setStatus(rs.getString("status"));
                order.setPaymentMode(rs.getString("paymentMode"));
                order.setOrderDate(rs.getTimestamp("orderDate"));

                orders.add(order);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    @Override
    public List<Order> getOrdersByUserId(int userId) {

        List<Order> orders = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
                PreparedStatement pstmt = con.prepareStatement(SELECT_ORDERS_BY_USER)) {

            pstmt.setInt(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {

                    Order order = new Order();

                    order.setOrderId(rs.getInt("orderId"));
                    order.setRestaurantId(rs.getInt("restaurantId"));
                    order.setUserId(rs.getInt("userId"));
                    order.setTotalAmount(rs.getDouble("totalAmount"));
                    order.setStatus(rs.getString("status"));
                    order.setPaymentMode(rs.getString("paymentMode"));
                    order.setOrderDate(rs.getTimestamp("orderDate"));

                    orders.add(order);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }
}