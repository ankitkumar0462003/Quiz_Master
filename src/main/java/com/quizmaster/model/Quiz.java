package com.quizmaster.model;
public record Quiz(long id,String title,int duration,int totalMarks) {public long getId(){return id;}public String getTitle(){return title;}public int getDuration(){return duration;}public int getTotalMarks(){return totalMarks;}}
