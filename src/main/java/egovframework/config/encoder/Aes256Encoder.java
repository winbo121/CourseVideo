package egovframework.config.encoder;

import java.nio.charset.StandardCharsets;
import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import org.apache.commons.codec.binary.Base64;
import org.springframework.beans.factory.InitializingBean;
import lombok.Setter;

public class Aes256Encoder implements InitializingBean {

	/** AES 256 암호화 키 **/
	@Setter
	private String aes_256_key;

	/** 암호화 CHIPER **/
	private Cipher encrypt_cipher;

	/** 복호화 CHIPER **/
	private Cipher decrpyt_cipher;

	@Override
	public void afterPropertiesSet() throws Exception {
        String iv = aes_256_key.substring( 0, 16 );

        byte[] keyBytes = new byte[16];
        byte[] b = aes_256_key.getBytes( StandardCharsets.UTF_8 );

        int len = b.length;
        if (len > keyBytes.length) {
            len = keyBytes.length;
        }
        System.arraycopy( b, 0, keyBytes, 0, len );
        SecretKeySpec keySpec = new SecretKeySpec( keyBytes, "AES" );

        /** AES256 ENCRYPTER **/
        encrypt_cipher = Cipher.getInstance( "AES/CBC/PKCS5Padding" );
        encrypt_cipher.init( Cipher.ENCRYPT_MODE, keySpec, new IvParameterSpec(iv.getBytes()) );

        /** AES256 DECRYPTER **/
        decrpyt_cipher = Cipher.getInstance( "AES/CBC/PKCS5Padding" );
        decrpyt_cipher.init( Cipher.DECRYPT_MODE, keySpec, new IvParameterSpec( iv.getBytes( StandardCharsets.UTF_8 )  ));


	}


	/** AES 암호화  **/
	public String encode( String plain ) throws IllegalBlockSizeException, BadPaddingException {
        byte[] encrypted = encrypt_cipher.doFinal( plain.getBytes( StandardCharsets.UTF_8 ) );
        return  new String( Base64.encodeBase64( encrypted ) );
	}

	/** AES 복호화 **/
	public String decode( String encode ) throws IllegalBlockSizeException, BadPaddingException {
        byte[] byteStr = Base64.decodeBase64( encode.getBytes() );
        byte[] encrypted = decrpyt_cipher.doFinal( byteStr );
        return new String( encrypted , StandardCharsets.UTF_8 );
	}

}
