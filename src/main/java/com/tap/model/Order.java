package com.tap.model;

import java.sql.Timestamp;

public class Order {

    private int orderId;
    private int restaurantId;
    private int userId;
    private double totalAmount;
    private String status;
    private String paymentMode;
    private Timestamp orderDate;

    public Order() {
    }

    public Order(int orderId, int restaurantId, int userId, double totalAmount,
                 String status, String paymentMode, Timestamp orderDate) {
        this.orderId = orderId;
        this.restaurantId = restaurantId;
        this.userId = userId;
        this.totalAmount = totalAmount;
        this.status = status;
        this.paymentMode = paymentMode;
        this.orderDate = orderDate;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPaymentMode() {
        return paymentMode;
    }

    public void setPaymentMode(String paymentMode) {
        this.paymentMode = paymentMode;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
    }

    @Override
    public String toString() {
        return "Order [orderId=" + orderId
                + ", restaurantId=" + restaurantId
                + ", userId=" + userId
                + ", totalAmount=" + totalAmount
                + ", status=" + status
                + ", paymentMode=" + paymentMode
                + ", orderDate=" + orderDate + "]";
    }
}