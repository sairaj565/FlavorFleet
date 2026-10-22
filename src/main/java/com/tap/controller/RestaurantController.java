package com.tap.controller;

import java.io.IOException;
//import java.io.PrintWriter;
import java.util.List;

import com.tap.model.Restaurant;
import com.tap.daoImpl.RestaurantDaoImpl;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/restaurant")
public class RestaurantController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        RestaurantDaoImpl restaurantDao = new RestaurantDaoImpl();
        List<Restaurant> allRestaurants = restaurantDao.getAllRestaurants();
        
        
        req.setAttribute("restaurants", allRestaurants);
        
        
        RequestDispatcher rd = req.getRequestDispatcher("restaurant.jsp");
        rd.forward(req, resp);
        
    }
    
}