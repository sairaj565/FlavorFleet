package com.tap.dao;

import java.util.List;

import com.tap.model.Menu;

public interface MenuDao {

    void addMenu(Menu menu);

    Menu getMenu(int menuId);

    void updateMenu(Menu menu);

    void deleteMenu(int menuId);

    List<Menu> getAllMenus();

    List<Menu> getMenuByRestaurantId(int restaurantId);
}