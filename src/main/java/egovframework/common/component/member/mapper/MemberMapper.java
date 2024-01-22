package egovframework.common.component.member.mapper;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.web.bind.annotation.RequestParam;

import egovframework.common.component.member.model.MemberDetail;
import egovframework.common.component.member.model.TsUserInfo;
import egovframework.common.component.member.model.TsUserYear;



@Mapper
public interface MemberMapper {

	/** 이미 존재하는 사용자 아이디 인지 확인한다. **/
	public boolean isAlreadyUserId( @Param("user_id") String user_id,
										@Param("chk_id") String chk_id);
	
	/** 이메일 인증코드 확인 **/
	public boolean isCodeYn( @Param("email") String email,
										@Param("at_code") String at_code);
	
	
	/** 이미 존재하는 사용자 아이디 인지 확인한다. **/
	public boolean isAlreadyUserIdStu( @Param("user_id") String user_id );

	/** 이미 존재하는 사용자 이메일 인지 확인한다. **/
	public boolean isAlreadyUserEmail( @Param("user_email") String user_email );
	
	/** 특정 회원을 제외한 사용자 중에서 이미 존재하는 사용자 이메일 인지 확인한다. **/
	public boolean isAlreadyUserEmailExceptForUserId( @Param("user_id") String user_id
													, @Param("user_email") String user_email );
	
	/** 이미 존재하는 담임교사가 있는지 확인한다. [교사] **/
	public boolean isAlreadyTeacher( @Param("sch_cd") String sch_cd
									,@Param("sch_grade") String sch_grade
									,@Param("sch_class") String sch_class
									,@Param("year_cd") String year_cd );
	
	/** 회원 정보 등록 **/
	public int addTsUserInfo( TsUserInfo input  );
	
	
	public void addTempEmailCode( HashMap<String, Object> map  );
	
	

	/** 연도별 회원 정보 등록 **/
	public int addTsUserYear( TsUserYear input );

	/** 회원 정보 삭제 **/
	public int removeTsUserInfo( @Param("user_id") String user_id);

	/** 연도별 회원 정보 삭제 **/
	public void removeTsUserYear( @Param("user_id") String user_id);
	
	/** 회원 탈퇴 이력 추가 **/
	public void addWithdrawalHistoryLog( @Param("user_id") String user_id
										,@Param("role_type") String role_type );

	/** 회원 정보 변경 **/
	public int modifyTsUserInfo( TsUserInfo input );

	/** 연도별 회원 정보 수정 **/
	public void modifyTsUserYear( TsUserYear input );

	/** 회원 정보 조회 **/
	public List<MemberDetail> getMembers( @Param("user_id") String user_id );

	/** 회원 아이디 찾기 **/
	public String findUserId( @Param("user_email") String user_email );
	
	
	/** 회원 재로그인 **/
	public boolean reLogin( @Param("user_pw") String user_pw );
	
	/**낱말 게임 사이트이동 체크**/
	public int goWordGameSiteCheck();
	
	/** 낱말게임 외부 API **/
	public MemberDetail wordGameApi(MemberDetail member);

	/** 학생 정보 등록삭제 **/
	public void removeTsUserYears(List<String> list);

	/** 연도별 학생 정보 등록삭제 **/
	public void removeTsUserInfos(List<String> list);
	
	/** 학생계정 아이디 중복확인 **/
	public boolean isAlreadyIdstu(@Param("user_id") String user_id);
	
	/** 시도 코드 **/
	public List<Map<String, Object>> getSidoCode();
	
	/** 직업 분류 코드 **/
	public List<Map<String, Object>> getJobCode(); 

}
