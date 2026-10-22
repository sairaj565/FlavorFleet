package com.tap.util;

import java.sql.Connection;

public class TestConnection {

    public static void main(String[] args) {

        Connection con = DBConnection.getConnection();

        if (con != null) {
            System.out.println("Connection is working!");
        } else {
            System.out.println("Connection is not working!");
        }
    }
}