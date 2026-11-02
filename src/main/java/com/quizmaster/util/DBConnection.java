package com.quizmaster.util;
import java.sql.*;import java.util.*;import java.io.*;
public final class DBConnection {
 private static final Properties config=new Properties();
 static {try(InputStream in=DBConnection.class.getClassLoader().getResourceAsStream("db.properties")){if(in==null)throw new IOException("Create src/main/resources/db.properties from example");config.load(in);Class.forName("oracle.jdbc.OracleDriver");}catch(Exception e){throw new ExceptionInInitializerError(e);}}
 public static Connection open() throws SQLException {return DriverManager.getConnection(config.getProperty("db.url"),config.getProperty("db.username"),config.getProperty("db.password"));}
}
