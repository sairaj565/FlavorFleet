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
 * LoginController handles user authentication:
 * - GET: Forwards to login.jsp
 * - POST: Validates email & password, stores user in session, and redirects
 */
@WebServlet({ "/login", "/LoginController" })

public class LoginController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        userDao = new UserDaoImpl();
    }

    /**
     * Handles GET /login: Shows the login page
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("login.jsp").forward(req, resp);
    }

    /**
     * Handles POST /login: Authenticates user credentials
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String redirect = req.getParameter("redirect");

        // 1. Fetch user directly from DB by email
        User user = (email != null) ? userDao.getEmail(email.trim()) : null;

        // String encryptedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        // 2. Validate password match
        if (user != null && password != null && BCrypt.checkpw(password, user.getPassword())) {
            // Authentication successful: Save user in session
            HttpSession session = req.getSession();
            session.setAttribute("user", user);

            // Redirect back to checkout (if came from checkout) or to restaurant list
            if (redirect != null && !redirect.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/" + redirect.replaceFirst("^/+", ""));
            } else {
                resp.sendRedirect(req.getContextPath() + "/restaurant");
            }
        } else {
            // Authentication failed: Return to login.jsp with error message
            req.setAttribute("errorMessage", "Invalid email or password. Please try again.");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }
}
