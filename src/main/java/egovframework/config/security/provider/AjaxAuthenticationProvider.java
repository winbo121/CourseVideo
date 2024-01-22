package egovframework.config.security.provider;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;

import org.apache.commons.lang3.StringUtils;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;

import egovframework.config.encoder.Aes256Encoder;
import egovframework.config.security.filter.AjaxAuthenticationToken;
import lombok.Setter;

public class AjaxAuthenticationProvider implements AuthenticationProvider {
	
	@Setter
	private UserDetailsService userDetailsService;
	
	@Setter
	private Aes256Encoder aes256Encoder;
	
	@Override
	public Authentication authenticate(Authentication authentication) throws AuthenticationException {
		
		String username = authentication.getName();
		String password = (String)authentication.getCredentials();
		
		UserDetails accountContext
        = userDetailsService.loadUserByUsername(username);
		Boolean is_password_valid = null;

			String encoded_password = null;
			try {
				encoded_password = aes256Encoder.encode( password );
				/** 비밀번호 유효한지 여부 **/
				is_password_valid = StringUtils.equals( encoded_password , accountContext.getPassword() );
			} catch (IllegalBlockSizeException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (BadPaddingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		if (!is_password_valid) {
			throw new BadCredentialsException("BadCredentialsException'");
		}
		
		return new AjaxAuthenticationToken(
			accountContext,
			null,
			accountContext.getAuthorities()
		);
	}
	
	@Override
	public boolean supports(Class<?> authentication) {
		return AjaxAuthenticationToken.class.isAssignableFrom(authentication);
	}
}