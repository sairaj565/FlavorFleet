package com.tap.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.OrderItemDao;
import com.tap.model.OrderItem;
import com.tap.util.DBConnection;

public class OrderItemDaoImpl implements OrderItemDao {

    private static final String INSERT_ORDER_ITEM =
            "INSERT INTO orderitem (orderId, menuId, quantity, itemTotal) VALUES (?, ?, ?, ?)";

    private static final String SELECT_ORDER_ITEM =
            "SELECT * FROM orderitem WHERE orderItemId = ?";

    private static final String UPDATE_ORDER_ITEM =
            "UPDATE orderitem SET orderId = ?, menuId = ?, quantity = ?, itemTotal = ? "
            + "WHERE orderItemId = ?";

    private static final String DELETE_ORDER_ITEM =
            "DELETE FROM orderitem WHERE orderItemId = ?";

    private static final String SELECT_ALL_ORDER_ITEMS =
            "SELECT * FROM orderitem";

    private static final String SELECT_ORDER_ITEMS_BY_ORDER_ID =
            "SELECT * FROM orderitem WHERE orderId = ?";

    @Override
    public void addOrderItem(OrderItem orderItem) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(INSERT_ORDER_ITEM)) {

            pstmt.setInt(1, orderItem.getOrderId());
            pstmt.setInt(2, orderItem.getMenuId());
            pstmt.setInt(3, orderItem.getQuantity());
            pstmt.setDouble(4, orderItem.getItemTotal());

            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public OrderItem getOrderItem(int orderItemId) {

        OrderItem orderItem = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(SELECT_ORDER_ITEM)) {

            pstmt.setInt(1, orderItemId);

            try (ResultSet rs = pstmt.executeQuery()) {

                if (rs.next()) {

                    orderItem = new OrderItem();

                    orderItem.setOrderItemId(rs.getInt("orderItemId"));
                    orderItem.setOrderId(rs.getInt("orderId"));
                    orderItem.setMenuId(rs.getInt("menuId"));
                    orderItem.setQuantity(rs.getInt("quantity"));
                    orderItem.setItemTotal(rs.getDouble("itemTotal"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderItem;
    }

    @Override
    public void updateOrderItem(OrderItem orderItem) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(UPDATE_ORDER_ITEM)) {

            pstmt.setInt(1, orderItem.getOrderId());
            pstmt.setInt(2, orderItem.getMenuId());
            pstmt.setInt(3, orderItem.getQuantity());
            pstmt.setDouble(4, orderItem.getItemTotal());
            pstmt.setInt(5, orderItem.getOrderItemId());

            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteOrderItem(int orderItemId) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(DELETE_ORDER_ITEM)) {

            pstmt.setInt(1, orderItemId);

            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<OrderItem> getAllOrderItems() {

        List<OrderItem> orderItems = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(SELECT_ALL_ORDER_ITEMS);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {

                OrderItem orderItem = new OrderItem();

                orderItem.setOrderItemId(rs.getInt("orderItemId"));
                orderItem.setOrderId(rs.getInt("orderId"));
                orderItem.setMenuId(rs.getInt("menuId"));
                orderItem.setQuantity(rs.getInt("quantity"));
                orderItem.setItemTotal(rs.getDouble("itemTotal"));

                orderItems.add(orderItem);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderItems;
    }

    @Override
    public List<OrderItem> getOrderItemsByOrderId(int orderId) {

        List<OrderItem> orderItems = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(SELECT_ORDER_ITEMS_BY_ORDER_ID)) {

            pstmt.setInt(1, orderId);

            try (ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {

                    OrderItem orderItem = new OrderItem();

                    orderItem.setOrderItemId(rs.getInt("orderItemId"));
                    orderItem.setOrderId(rs.getInt("orderId"));
                    orderItem.setMenuId(rs.getInt("menuId"));
                    orderItem.setQuantity(rs.getInt("quantity"));
                    orderItem.setItemTotal(rs.getDouble("itemTotal"));

                    orderItems.add(orderItem);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderItems;
    }
}