package egovframework.config.security.provider;

import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.security.authentication.AuthenticationCredentialsNotFoundException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UserDetails;

import egovframework.config.encoder.Aes256Encoder;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class CustomDaoAuthenticationProvider extends DaoAuthenticationProvider {


	@Setter
	private Aes256Encoder aes256Encoder;


	/** 추가 인증 체크
	 * org.springframework.security.authentication.dao.AbstractUserDetailsAuthenticationProvider
	  *  객체를 재구현함. 비밀번호 유효성 체크  * */
	@Override
	protected void additionalAuthenticationChecks(	UserDetails userDetails
													,UsernamePasswordAuthenticationToken authentication) throws AuthenticationException {

		if (authentication.getCredentials() == null) {
			log.debug("Authentication failed: no credentials provided");

			throw new BadCredentialsException(messages.getMessage(
					"AbstractUserDetailsAuthenticationProvider.badCredentials",
					"Bad credentials"));
		}

		/** 현재 인증한 비밀번호 **/
		String presentedPassword = authentication.getCredentials().toString();


		Boolean is_password_valid = null;
		try {

			String encoded_password = aes256Encoder.encode( presentedPassword );

			/** 비밀번호 유효한지 여부 **/
			is_password_valid = StringUtils.equals( encoded_password , userDetails.getPassword() );
		}catch( Exception e) {
			throw new BadCredentialsException("Security PasswordEncoder matches Exception...");
		}

		if( BooleanUtils.isNotTrue(is_password_valid) ) {
			log.debug("Authentication failed: password does not match stored value");

			/** 비밀번호 오류 **/
			throw new AuthenticationCredentialsNotFoundException( messages.getMessage(
					"AbstractUserDetailsAuthenticationProvider.badCredentials",
					"Bad credentials"));
		}

	}


	/**  인증 처리 **/
	@Override
	public Authentication authenticate(Authentication authentication )throws AuthenticationException {
		log.debug("CustomDaoAuthenticationProvider.authenticate ::::");

		return super.authenticate(authentication);
	}



}
