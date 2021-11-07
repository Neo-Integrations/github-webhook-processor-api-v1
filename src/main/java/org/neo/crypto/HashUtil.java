package org.neo.crypto;

import java.io.InputStream;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Hex;
import org.apache.commons.io.IOUtils;



public class HashUtil {
	
	public static String encode(String key, InputStream data) throws Exception {
		  
		  byte[] bytes = IOUtils.toByteArray(data);
		  Mac sha256_HMAC = Mac.getInstance("HmacSHA256");
		  SecretKeySpec secret_key = new SecretKeySpec(key.getBytes("UTF-8"), "HmacSHA256");
		  sha256_HMAC.init(secret_key);

		  return Hex.encodeHexString(sha256_HMAC.doFinal(bytes));
		}

		public static void main(String [] args) throws Exception {
		  System.out.println(encode("2342", null));
		}

}
