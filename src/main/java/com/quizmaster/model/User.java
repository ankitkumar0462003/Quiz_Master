package com.quizmaster.model;
import java.io.Serializable;
public class User implements Serializable {private final long id;private final String fullName,email,role;public User(long id,String n,String e,String r){this.id=id;fullName=n;email=e;role=r;}public long getId(){return id;}public String getFullName(){return fullName;}public String getEmail(){return email;}public String getRole(){return role;}}
