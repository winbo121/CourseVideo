package egovframework.config.security.secured.model;

import lombok.Setter;

/** SPRING 권한 계층 구조 **/
@Setter
public class SecurityHierarch {

	private String child;
	private String parent;

	/** 계층구조 조회 **/
	public String getHierarch() {
		return new StringBuilder()
						.append( this.child )
						.append(" > ")
						.append( this.parent )
						.toString();
	}


}
