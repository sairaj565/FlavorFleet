package com.tap.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.MenuDao;
import com.tap.model.Menu;
import com.tap.util.DBConnection;

public class MenuDaoImpl implements MenuDao {

    private static final String INSERT_MENU =
            "INSERT INTO menu (restaurantId, itemName, description, price, isAvailable, imagePath) "
            + "VALUES (?, ?, ?, ?, ?, ?)";

    private static final String SELECT_MENU =
            "SELECT * FROM menu WHERE menuId = ?";

    private static final String UPDATE_MENU =
            "UPDATE menu SET restaurantId = ?, itemName = ?, description = ?, price = ?, "
            + "isAvailable = ?, imagePath = ? WHERE menuId = ?";

    private static final String DELETE_MENU =
            "DELETE FROM menu WHERE menuId = ?";

    private static final String SELECT_ALL_MENUS =
            "SELECT * FROM menu";

    private static final String SELECT_MENU_BY_RESTAURANT =
            "SELECT * FROM menu WHERE restaurantId = ?";

    @Override
    public void addMenu(Menu menu) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(INSERT_MENU)) {

            pstmt.setInt(1, menu.getRestaurantId());
            pstmt.setString(2, menu.getItemName());
            pstmt.setString(3, menu.getDescription());
            pstmt.setDouble(4, menu.getPrice());
            pstmt.setBoolean(5, menu.isAvailable());
            pstmt.setString(6, menu.getImagePath());

            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Menu getMenu(int menuId) {

        Menu menu = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(SELECT_MENU)) {

            pstmt.setInt(1, menuId);

            try (ResultSet rs = pstmt.executeQuery()) {

                if (rs.next()) {

                    menu = new Menu();

                    menu.setMenuId(rs.getInt("menuId"));
                    menu.setRestaurantId(rs.getInt("restaurantId"));
                    menu.setItemName(rs.getString("itemName"));
                    menu.setDescription(rs.getString("description"));
                    menu.setPrice(rs.getDouble("price"));
                    menu.setAvailable(rs.getBoolean("isAvailable"));
                    menu.setImagePath(rs.getString("imagePath"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menu;
    }

    @Override
    public void updateMenu(Menu menu) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(UPDATE_MENU)) {

            pstmt.setInt(1, menu.getRestaurantId());
            pstmt.setString(2, menu.getItemName());
            pstmt.setString(3, menu.getDescription());
            pstmt.setDouble(4, menu.getPrice());
            pstmt.setBoolean(5, menu.isAvailable());
            pstmt.setString(6, menu.getImagePath());
            pstmt.setInt(7, menu.getMenuId());

            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteMenu(int menuId) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(DELETE_MENU)) {

            pstmt.setInt(1, menuId);

            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Menu> getAllMenus() {

        List<Menu> menus = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(SELECT_ALL_MENUS);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {

                Menu menu = new Menu();

                menu.setMenuId(rs.getInt("menuId"));
                menu.setRestaurantId(rs.getInt("restaurantId"));
                menu.setItemName(rs.getString("itemName"));
                menu.setDescription(rs.getString("description"));
                menu.setPrice(rs.getDouble("price"));
                menu.setAvailable(rs.getBoolean("isAvailable"));
                menu.setImagePath(rs.getString("imagePath"));

                menus.add(menu);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menus;
    }

    @Override
    public List<Menu> getMenuByRestaurantId(int restaurantId) {

        List<Menu> menus = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(SELECT_MENU_BY_RESTAURANT)) {

            pstmt.setInt(1, restaurantId);

            try (ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {

                    Menu menu = new Menu();

                    menu.setMenuId(rs.getInt("menuId"));
                    menu.setRestaurantId(rs.getInt("restaurantId"));
                    menu.setItemName(rs.getString("itemName"));
                    menu.setDescription(rs.getString("description"));
                    menu.setPrice(rs.getDouble("price"));
                    menu.setAvailable(rs.getBoolean("isAvailable"));
                    menu.setImagePath(rs.getString("imagePath"));

                    menus.add(menu);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menus;
    }
}