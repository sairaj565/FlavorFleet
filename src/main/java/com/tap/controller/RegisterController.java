package com.tap.controller;

import java.io.IOException;

import org.mindrot.jbcrypt.BCrypt;

import com.tap.dao.UserDao;
import com.tap.daoImpl.UserDaoImpl;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * RegisterController handles user sign up / registration:
 * - GET: Forwards to register.jsp
 * - POST: Validates input, checks duplicate email, inserts user, sets session, and redirects
 */
@WebServlet({ "/register", "/RegisterController", "/signup" })
public class RegisterController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        userDao = new UserDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String redirect = req.getParameter("redirect");

        // Basic validation
        if (username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {

            req.setAttribute("errorMessage", "Please fill in all required fields (Name, Email, Password).");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }

        email = email.trim().toLowerCase();

        // Check if user already exists
        User existingUser = userDao.getEmail(email);
        if (existingUser != null) {
            req.setAttribute("errorMessage", "An account with this email already exists. Please sign in.");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }

        // Create new user with Customer role
        User newUser = new User();
        newUser.setUsername(username.trim());
        newUser.setEmail(email);
        
        
        
        String encryptedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        newUser.setPassword(encryptedPassword);
        
        
        
        newUser.setPhone((phone != null) ? phone.trim() : "");
        newUser.setAddress((address != null) ? address.trim() : "");
        newUser.setRole("Customer");

        userDao.addUser(newUser);

        // Fetch newly created user from DB (with generated ID)
        User createdUser = userDao.getEmail(email);
        if (createdUser == null) {
            createdUser = newUser;
        }

        // Auto-login: bind user into session
        HttpSession session = req.getSession();
        session.setAttribute("user", createdUser);

        // Redirect
        if (redirect != null && !redirect.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/" + redirect.replaceFirst("^/+", ""));
        } else {
            resp.sendRedirect(req.getContextPath() + "/restaurant");
        }
    }
}
