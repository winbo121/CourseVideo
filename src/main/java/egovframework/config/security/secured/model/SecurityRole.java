package egovframework.config.security.secured.model;



import org.springframework.security.access.SecurityConfig;

import lombok.Data;

/** SECURITY DB ROLE  **/
@Data
public class SecurityRole {

	/** ROLE 의 대상 **/
	private String target;

	/** 대상에대한 ROLE **/
	private String authority;


	public SecurityConfig newSecurityConfig() {
		return new SecurityConfig( this.authority );
	}


}
