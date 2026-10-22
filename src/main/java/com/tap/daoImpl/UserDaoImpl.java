package com.tap.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.UserDao;
import com.tap.model.User;
import com.tap.util.DBConnection;

public class UserDaoImpl implements UserDao {

    private static final String INSERT_USER =
            "INSERT INTO users (username, password, email, phone, address, role) VALUES (?, ?, ?, ?, ?, ?)";

    private static final String SELECT_USER =
            "SELECT * FROM users WHERE userId = ?";
    
    private static final String SELECT_EMAIL =
            "SELECT * FROM users WHERE email = ?";

    private static final String UPDATE_USER =
            "UPDATE users SET username = ?, password = ?, email = ?, phone = ?, address = ?, role = ? WHERE userId = ?";

    private static final String DELETE_USER =
            "DELETE FROM users WHERE userId = ?";

    private static final String SELECT_ALL_USERS =
            "SELECT * FROM users";

    @Override
    public void addUser(User user) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(INSERT_USER)) {

            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getEmail());
            pstmt.setString(4, user.getPhone());
            pstmt.setString(5, user.getAddress());
            pstmt.setString(6, user.getRole());

            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public User getUser(int userId) {

        User user = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(SELECT_USER)) {

            pstmt.setInt(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {

                if (rs.next()) {

                    user = new User();

                    user.setUserId(rs.getInt("userId"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setAddress(rs.getString("address"));
                    user.setRole(rs.getString("role"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return user;
    }
    
    
    
    @Override
    public User getEmail(String userEmail) {

        User user = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(SELECT_EMAIL)) {

            pstmt.setString(1, userEmail);

            try (ResultSet rs = pstmt.executeQuery()) {

                if (rs.next()) {

                    user = new User();

                    user.setUserId(rs.getInt("userId"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setAddress(rs.getString("address"));
                    user.setRole(rs.getString("role"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return user;
    }

    @Override
    public void updateUser(User user) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(UPDATE_USER)) {

            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getEmail());
            pstmt.setString(4, user.getPhone());
            pstmt.setString(5, user.getAddress());
            pstmt.setString(6, user.getRole());
            pstmt.setInt(7, user.getUserId());

            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteUser(int userId) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(DELETE_USER)) {

            pstmt.setInt(1, userId);

            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<User> getAllUsers() {

        List<User> users = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(SELECT_ALL_USERS);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {

                User user = new User();

                user.setUserId(rs.getInt("userId"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));
                user.setRole(rs.getString("role"));

                users.add(user);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return users;
    }
}