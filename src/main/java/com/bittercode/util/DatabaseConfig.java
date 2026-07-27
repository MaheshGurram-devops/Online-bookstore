package com.bittercode.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

class DatabaseConfig {

    private static final Properties PROP = new Properties();

    static {
        try (InputStream input = Thread.currentThread().getContextClassLoader().getResourceAsStream("application.properties")) {
            if (input != null) {
                PROP.load(input);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static String getProperty(String key, String defaultValue) {
        String envKey = key.replace('.', '_').replace('-', '_').toUpperCase();
        String envValue = System.getenv(envKey);
        if (envValue != null && !envValue.trim().isEmpty()) {
            return envValue.trim();
        }

        String systemValue = System.getProperty(key);
        if (systemValue != null && !systemValue.trim().isEmpty()) {
            return systemValue.trim();
        }

        String value = PROP.getProperty(key);
        return value == null || value.trim().isEmpty() ? defaultValue : value.trim();
    }

    public static final String DRIVER_NAME = getProperty("db.driver", "com.mysql.cj.jdbc.Driver");
    public static final String DB_HOST = getProperty("db.host", "jdbc:mysql://localhost");
    public static final String DB_PORT = getProperty("db.port", "3306");
    public static final String DB_NAME = getProperty("db.name", "onlinebookstore");
    public static final String DB_USER_NAME = getProperty("db.username", "root");
    public static final String DB_PASSWORD = getProperty("db.password", "mysql");
    public static final String CONNECTION_STRING = normalizeJdbcUrl(DB_HOST, DB_PORT, DB_NAME);

    private static String normalizeJdbcUrl(String host, String port, String name) {
        String normalizedHost = host;
        if (normalizedHost.startsWith("jdbc:")) {
            normalizedHost = normalizedHost.substring("jdbc:".length());
        }
        if (!normalizedHost.startsWith("mysql://")) {
            normalizedHost = "mysql://" + normalizedHost;
        }
        return "jdbc:" + normalizedHost + ":" + port + "/" + name;
    }
}
