package com.quizmaster.model;
import java.sql.Timestamp;
public record Attempt(long id,long userId,long quizId,Timestamp started,Timestamp submitted,double score,String status) {public long getId(){return id;}public long getUserId(){return userId;}public long getQuizId(){return quizId;}public java.sql.Timestamp getStarted(){return started;}public java.sql.Timestamp getSubmitted(){return submitted;}public double getScore(){return score;}public String getStatus(){return status;}}
