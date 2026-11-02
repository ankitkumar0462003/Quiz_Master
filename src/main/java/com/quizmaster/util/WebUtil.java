package com.quizmaster.util;
import jakarta.servlet.http.*;import java.security.*;import java.nio.charset.StandardCharsets;import java.util.HexFormat;
public final class WebUtil {
 private static final SecureRandom RNG=new SecureRandom();
 public static String csrf(HttpSession session){String t=(String)session.getAttribute("csrf");if(t==null){byte[] b=new byte[32];RNG.nextBytes(b);t=HexFormat.of().formatHex(b);session.setAttribute("csrf",t);}return t;}
 public static boolean valid(HttpServletRequest r){HttpSession s=r.getSession(false);if(s==null)return false;String a=(String)s.getAttribute("csrf"),b=r.getParameter("csrf");return a!=null&&b!=null&&MessageDigest.isEqual(a.getBytes(StandardCharsets.UTF_8),b.getBytes(StandardCharsets.UTF_8));}
 public static long positive(String text){try{long n=Long.parseLong(text);return n>0?n:-1;}catch(Exception e){return -1;}}
 public static int number(String text,int min,int max){try{int n=Integer.parseInt(text);return n>=min&&n<=max?n:-1;}catch(Exception e){return -1;}}
 public static String clean(String s){return s==null?"":s.trim();}
}
