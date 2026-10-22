package com.tap.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.RestaurantDao;
import com.tap.model.Restaurant;
import com.tap.util.DBConnection;

public class RestaurantDaoImpl implements RestaurantDao {

    private static final String INSERT_RESTAURANT =
            "INSERT INTO restaurant (name, cuisineType, deliveryTime, address, adminUserId, rating, isActive, imagePath) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String SELECT_RESTAURANT =
            "SELECT * FROM restaurant WHERE restaurantId = ?";

    private static final String UPDATE_RESTAURANT =
            "UPDATE restaurant SET name = ?, cuisineType = ?, deliveryTime = ?, address = ?, "
            + "adminUserId = ?, rating = ?, isActive = ?, imagePath = ? WHERE restaurantId = ?";

    private static final String DELETE_RESTAURANT =
            "DELETE FROM restaurant WHERE restaurantId = ?";

    private static final String SELECT_ALL_RESTAURANTS =
            "SELECT * FROM restaurant";

    @Override
    public void addRestaurant(Restaurant restaurant) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(INSERT_RESTAURANT)) {

            pstmt.setString(1, restaurant.getName());
            pstmt.setString(2, restaurant.getCuisineType());
            pstmt.setInt(3, restaurant.getDeliveryTime());
            pstmt.setString(4, restaurant.getAddress());
            pstmt.setInt(5, restaurant.getAdminUserId());
            pstmt.setDouble(6, restaurant.getRating());
            pstmt.setBoolean(7, restaurant.isActive());
            pstmt.setString(8, restaurant.getImagePath());

            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Restaurant getRestaurant(int restaurantId) {

        Restaurant restaurant = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(SELECT_RESTAURANT)) {

            pstmt.setInt(1, restaurantId);

            try (ResultSet rs = pstmt.executeQuery()) {

                if (rs.next()) {

                    restaurant = new Restaurant();

                    restaurant.setRestaurantId(rs.getInt("restaurantId"));
                    restaurant.setName(rs.getString("name"));
                    restaurant.setCuisineType(rs.getString("cuisineType"));
                    restaurant.setDeliveryTime(rs.getInt("deliveryTime"));
                    restaurant.setAddress(rs.getString("address"));
                    restaurant.setAdminUserId(rs.getInt("adminUserId"));
                    restaurant.setRating(rs.getDouble("rating"));
                    restaurant.setActive(rs.getBoolean("isActive"));
                    restaurant.setImagePath(rs.getString("imagePath"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurant;
    }

    @Override
    public void updateRestaurant(Restaurant restaurant) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(UPDATE_RESTAURANT)) {

            pstmt.setString(1, restaurant.getName());
            pstmt.setString(2, restaurant.getCuisineType());
            pstmt.setInt(3, restaurant.getDeliveryTime());
            pstmt.setString(4, restaurant.getAddress());
            pstmt.setInt(5, restaurant.getAdminUserId());
            pstmt.setDouble(6, restaurant.getRating());
            pstmt.setBoolean(7, restaurant.isActive());
            pstmt.setString(8, restaurant.getImagePath());
            pstmt.setInt(9, restaurant.getRestaurantId());

            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteRestaurant(int restaurantId) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(DELETE_RESTAURANT)) {

            pstmt.setInt(1, restaurantId);

            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Restaurant> getAllRestaurants() {

        List<Restaurant> restaurants = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(SELECT_ALL_RESTAURANTS);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {

                Restaurant restaurant = new Restaurant();

                restaurant.setRestaurantId(rs.getInt("restaurantId"));
                restaurant.setName(rs.getString("name"));
                restaurant.setCuisineType(rs.getString("cuisineType"));
                restaurant.setDeliveryTime(rs.getInt("deliveryTime"));
                restaurant.setAddress(rs.getString("address"));
                restaurant.setAdminUserId(rs.getInt("adminUserId"));
                restaurant.setRating(rs.getDouble("rating"));
                restaurant.setActive(rs.getBoolean("isActive"));
                restaurant.setImagePath(rs.getString("imagePath"));

                restaurants.add(restaurant);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurants;
    }
}