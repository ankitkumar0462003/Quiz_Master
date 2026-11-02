package com.quizmaster.dao;
import com.quizmaster.model.User;import com.quizmaster.util.*;import java.sql.*;import java.util.Locale;
public class UserDAO {
 public void register(String name,String email,String pass)throws SQLException{String sql="INSERT INTO users(full_name,email,password_hash,user_role) VALUES(?,?,?,'STUDENT')";try(Connection c=DBConnection.open();PreparedStatement p=c.prepareStatement(sql)){p.setString(1,name);p.setString(2,email.toLowerCase(Locale.ROOT));p.setString(3,PasswordUtil.hash(pass));p.executeUpdate();}}
 public User login(String email,String pass)throws SQLException{try(Connection c=DBConnection.open();PreparedStatement p=c.prepareStatement("SELECT user_id,full_name,email,password_hash,user_role FROM users WHERE email=?")){p.setString(1,email.toLowerCase(Locale.ROOT));try(ResultSet r=p.executeQuery()){if(r.next()&&PasswordUtil.verify(pass,r.getString("password_hash")))return new User(r.getLong("user_id"),r.getString("full_name"),r.getString("email"),r.getString("user_role"));}}return null;}
}
