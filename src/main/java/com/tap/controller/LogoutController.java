package com.tap.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * LogoutController invalidates user session and redirects to restaurant home.
 */
@WebServlet({"/logout", "/LogoutController"})
public class LogoutController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
    	
        HttpSession session = req.getSession(false);
        
        if (session != null) {
        	
            session.removeAttribute("user");
            
        }
        
        resp.sendRedirect(req.getContextPath() + "/restaurant");
    }
}
