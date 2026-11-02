package com.quizmaster.util;
import java.nio.charset.StandardCharsets;import java.security.*;import java.util.HexFormat;
public final class PasswordUtil {
 private static final SecureRandom R=new SecureRandom();private static final HexFormat H=HexFormat.of();
 public static String hash(String value){byte[] s=new byte[16];R.nextBytes(s);String salt=H.formatHex(s);return salt+":"+digest(salt,value);}
 private static String digest(String salt,String password){try {return H.formatHex(MessageDigest.getInstance("SHA-256").digest((salt+":"+password).getBytes(StandardCharsets.UTF_8)));}catch(NoSuchAlgorithmException e){throw new IllegalStateException(e);}}
 public static boolean verify(String password,String stored){if(password==null||stored==null)return false;String[] a=stored.split(":",-1);if(a.length!=2)return false;try{byte[] s=H.parseHex(a[0]), expected=H.parseHex(a[1]);if(s.length!=16||expected.length!=32)return false;return MessageDigest.isEqual(expected,H.parseHex(digest(a[0],password)));}catch(IllegalArgumentException e){return false;}}
}
