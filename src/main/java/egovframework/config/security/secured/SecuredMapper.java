package egovframework.config.security.secured;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import egovframework.config.security.secured.model.SecurityHierarch;
import egovframework.config.security.secured.model.SecurityRole;
import egovframework.config.security.secured.model.SecurityUser;


@Mapper
public interface SecuredMapper {

	/** SPRING SECURITY ROLE 리스트 조회  **/
	public List<SecurityRole> listSecurityRole( @Param("role_type") String role_type );

	/** SPRING SECURITY ROLE 계층구조 조회 **/
	public List<SecurityHierarch> hierarchicalRoles();


	/** 사용자 데이터 조회 **/
	public List<SecurityUser> userByUsername( @Param("user_id") String user_id );

	/** 사용자의 ROLE 조회  **/
	public List<String> authoritiesByUsername( @Param("user_id") String user_id );

	/** 최초 로그인 시간 변경 **/
	public int modifyFirstLoginDt( @Param("user_id") String user_id );
	/** 마지막 로그인 시간 변경 **/
	public int modifyLastLoginDt( @Param("user_id") String user_id );

	/** 사용자 로그인 로그 추가 **/
	public int addLoginLog( @Param("user_id") String user_id, @Param("remote_addr") String remote_addr );

}
