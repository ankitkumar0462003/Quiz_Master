package com.quizmaster.dao;
import com.quizmaster.model.*;import com.quizmaster.util.*;import java.sql.*;import java.util.*;
public class QuizDAO {
 private Quiz map(ResultSet r)throws SQLException{return new Quiz(r.getLong("quiz_id"),r.getString("title"),r.getInt("duration_minutes"),r.getInt("total_marks"));}
 public List<Quiz> all()throws SQLException{List<Quiz> out=new ArrayList<>();try(Connection c=DBConnection.open();PreparedStatement p=c.prepareStatement("SELECT * FROM quizzes ORDER BY quiz_id DESC");ResultSet r=p.executeQuery()){while(r.next())out.add(map(r));}return out;}
 public Quiz get(long id)throws SQLException{try(Connection c=DBConnection.open();PreparedStatement p=c.prepareStatement("SELECT * FROM quizzes WHERE quiz_id=?")){p.setLong(1,id);try(ResultSet r=p.executeQuery()){return r.next()?map(r):null;}}}
 public void save(long id,String title,int mins,int marks,long admin)throws SQLException{boolean edit=id>0;String sql=edit?"UPDATE quizzes SET title=?,duration_minutes=?,total_marks=? WHERE quiz_id=?":"INSERT INTO quizzes(title,duration_minutes,total_marks,created_by) VALUES(?,?,?,?)";try(Connection c=DBConnection.open();PreparedStatement p=c.prepareStatement(sql)){p.setString(1,title);p.setInt(2,mins);p.setInt(3,marks);p.setLong(4,edit?id:admin);p.executeUpdate();}}
 public boolean delete(long id)throws SQLException{try(Connection c=DBConnection.open();PreparedStatement p=c.prepareStatement("DELETE FROM quizzes WHERE quiz_id=?")){p.setLong(1,id);return p.executeUpdate()>0;}}
}
