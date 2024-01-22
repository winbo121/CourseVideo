package egovframework.common.component.member.model;

import java.util.List;
import java.util.Optional;

import org.apache.commons.lang3.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import egovframework.common.component.file.model.FileData;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@ToString
public class MemberDetail {

	/** 사용자 ID **/
	@Getter @Setter
	private String user_id;

	/** 성명 **/
	@Getter @Setter
	private String user_name;

	/** 사용자 권한 유형 **/
	@Getter @Setter
	private String role_type;

	/** 사용자 비밀번호 [실재로 데이터는 조회되지 않음] **/
	@Getter @Setter
	private String user_pw;
	/** 사용자 비밀번호 확인 [실재로 데이터는 조회되지 않음] **/
	@Getter @Setter
	private String user_pw_confirm;

	/** 사용자 이메일 **/
	@Getter @Setter
	private String user_email;

	/** 사용자 성별 **/
	@Getter @Setter
	private String gender;

	/** 뱃지 등급 **/
	@Getter @Setter
	private String badge_grade;
	
	/** 등록일 **/
	@Getter @Setter
	private String user_regist_dt;
	
	/** 최초접속일 **/
	@Getter @Setter
	private String first_login_dt;
	
	/** 최근접속일 **/
	@Getter @Setter
	private String last_login_dt;
	
	/** 우편번호 **/
	@Getter @Setter
	private String zip_code;
	
	
	/** 시군구 코드 **/
	@Getter @Setter
	private String sigungu_code;
	
	/** 시도 코드 **/
	@Getter @Setter
	private String sido_code;
	
	/** 기본주소 **/
	@Getter @Setter
	private String user_addr;
	
	/** 상세주소 **/
	@Getter @Setter
	private String user_dtl_addr;
	
	/** 나이 **/
	@Getter @Setter
	private String age;
	
	/** 직업분류 **/
	@Getter @Setter
	private String job_code;
	
	/** 휴대폰번호 **/
	@Getter @Setter
	private String phone;
	
	/** 보상포인트 **/
	@Getter @Setter
	private String reward_point;

	/** 연도 **/
	@Getter @Setter
	private String year_cd;

	/** 학교코드 **/
	@Getter @Setter
	private String sch_cd;

	/** 학교명 **/
	@Getter @Setter
	private String sch_name;

	/** 학년 **/
	@Getter @Setter
	private String sch_grade;

	/** 반 **/
	@Getter @Setter
	private String sch_class;
	
	/** 퀴즈횟수 **/
	@Getter @Setter
	private String quiz_cnt;

	/** 프로필 이미지 정보 **/
	@Setter
	private FileData profile_image;
	
	/** 이미지가 존재하는지 여부 **/
	public boolean getHasImg() {
		return  Optional.ofNullable( this.profile_image )
						  .map( FileData::getImg_url )
						  .filter( StringUtils::isNotEmpty )
						  .isPresent();
	}

	/** 이미지 URL  **/
	public String getImg_url() {
		return  Optional.ofNullable( this.profile_image )
				  .map( FileData::getImg_url )
				  .filter( StringUtils::isNotEmpty )
				  .orElseGet( () -> "" );
	}
	
	
	@Getter @Setter
	private MultipartFile[] upload_files;
	
	@Getter @Setter
	private List<Integer> del_files_seqs;
	
	
	
	





}
