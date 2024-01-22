package egovframework.common.component.member;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Consumer;
import java.util.stream.Stream;
import org.apache.commons.lang3.StringUtils;
import org.slieb.throwables.FunctionWithThrowable;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;


import egovframework.common.component.file.FileComponent;
import egovframework.common.component.file.model.FileData;
import egovframework.common.component.member.mapper.MemberMapper;
import egovframework.common.component.member.model.BadgeGrade;
import egovframework.common.component.member.model.MemberDetail;
import egovframework.common.component.member.model.TsUserInfo;
import egovframework.common.component.member.model.TsUserYear;
import egovframework.common.constrant.EnumCodes.FILE_REG_GB;
import egovframework.common.error.exception.ErrorMessageException;
import egovframework.common.util.LocalThread;
import egovframework.common.util.StreamUtils;
import egovframework.config.encoder.Aes256Encoder;

@Component
public class MemberComponent {

	/** 비밀번호 인코더 **/
	@Autowired
	private Aes256Encoder aes256Encoder;

	@Autowired
	private MemberMapper memberMapper;

	@Autowired
	private FileComponent fileComponent;

	/**
	@Autowired
	private CodeComponent codeComponent;
	**/


	


	/** 비밀번호 암호화 **/
	public String encodePassword( String password ) {
		try {
			return aes256Encoder.encode( password );
		}catch( Exception e) {
			/** 비밀번호 암호화에 실패했습니다. **/
			throw new ErrorMessageException("password.encode.fail");
		}
	}



	/** 사용자 상세 정보가 존재할경우 **/
	private final Consumer<MemberDetail> IF_PRESENT_MEMBER = detail -> {
		/** 프로필 이미지 조회 **/
		FileData profile_image = fileComponent.getFirstFile( FILE_REG_GB.TS_USER_INFO, detail.getUser_id() );
		detail.setProfile_image(profile_image);
	};


	/** 사용자 상세 정보 조회 **/
	public Optional<MemberDetail> getMember( String user_id ) {

		List<MemberDetail> list = memberMapper.getMembers( user_id );
		Optional<MemberDetail> result = StreamUtils.toStream( list )
																.findFirst();
		result.ifPresent( IF_PRESENT_MEMBER );
		return result;
	}

	/** 보상등급 조회 **/
	public BadgeGrade getBadgeGrade( String user_id ) {
		int badge_grade =
				Optional.ofNullable( user_id )
							.map(	FunctionWithThrowable.asFunctionWithThrowable( this.memberMapper::getMembers )
																 .thatReturnsOnCatch( Collections.emptyList() )
									)
							.map( StreamUtils::toStream )
							.flatMap( Stream::findFirst )
							.map( MemberDetail::getBadge_grade )
							.filter( StringUtils::isNumeric )
							.map( Integer::parseInt )
							.orElseGet( () -> 1 );

		return BadgeGrade.builder( badge_grade ).build();
	}

	/** 회원 정보 등록 **/
	public void addTsUserInfo( TsUserInfo input ) {
		memberMapper.addTsUserInfo( input );
	}
	
	/** 이메일 인증 코드 저장 **/
	public void addTempEmailCode( HashMap<String, Object> map ) {
		memberMapper.addTempEmailCode( map );
	}

	/** 연도별 회원 정보 등록 **/
	public void addTsUserYear( TsUserYear input ){
		memberMapper.addTsUserYear( input );
	}

	/** 이미 회원 등록한 회원 정보인지 확인한다. **/
	public boolean isAlreadyUserId( String user_id, String chk_id ) {
		return memberMapper.isAlreadyUserId( user_id, chk_id );
	}
	
	/**  이메일 인증코드 확인 **/
	public boolean isCodeYn( String email, String at_code ) {
		return memberMapper.isCodeYn( email, at_code );
	}
	
	
	
	
	
	/**
	 *  이미 회원 등록한 회원 정보인지 확인한다. **/
	public boolean isAlreadyUserIdStu( String user_id ) {
		return memberMapper.isAlreadyUserIdStu( user_id);
	}

	/** 이미 회원 등록한 이메일 정보인지 확인한다. **/
	public boolean isAlreadyUserEmail( String user_email ) {
		return memberMapper.isAlreadyUserEmail( user_email );
	}
	
	/** 특정 회원을 제외한 사용자 중에서 이미 사용중인 이메일 정보인지 확인한다. **/
	public boolean isAlreadyUserEmailExceptForUserId( String user_id, String user_email ) {
		return memberMapper.isAlreadyUserEmailExceptForUserId( user_id, user_email );
	}
	
	
	
	
	/** 회원 정보 삭제 
	 * @return **/
	public int removeTsUserInfo( String user_id ) {
		return memberMapper.removeTsUserInfo( user_id );
	}

	/** 연도별 회원 정보 삭제 **/
	public void removeTsUserYear( String user_id ) {
		memberMapper.removeTsUserYear( user_id );
	}
	
	/** 회원 탈퇴 이력 추가 **/
	public void addWithdrawalHistoryLog( String user_id, String role_type ) {
		memberMapper.addWithdrawalHistoryLog( user_id, role_type );
	}

	/** 회원 정보 변경 **/
	public int modifyTsUserInfo( TsUserInfo input ) {
		return memberMapper.modifyTsUserInfo( input );
	}

	/** 연도별 회원 정보 수정 **/
	public void modifyTsUserYear( TsUserYear input ) {
		memberMapper.modifyTsUserYear( input );
	}


	/** 회원 아이디 찾기 **/
	public String findUserId( String user_email ) {
		return memberMapper.findUserId( user_email );
	}
	
	
	/** 회원 재로그인 **/
	public boolean reLogin( String user_pw ) {
		return memberMapper.reLogin( user_pw );
	}
	
	/**낱말 게임 사이트이동 체크**/
	public int goWordGameSiteCheck() {
		return memberMapper.goWordGameSiteCheck();
	}
	
	/** 낱말게임 외부 API **/
	public MemberDetail wordGameApi(MemberDetail member) {
		return memberMapper.wordGameApi(member);
	}
	
	/** 학급관리 -> 학생정보 등록삭제 **/
	public void removeTsUserYears(List<String> list) {
		memberMapper.removeTsUserYears(list);
	}

	/** 학급관리 -> 학생정보 등록삭제 **/
	public void removeTsUserInfos(List<String> list) {
		memberMapper.removeTsUserInfos(list);
		
	}
	
	/** 시도 코드 **/
	public List<Map<String, Object>> getSidoCode() {
		return memberMapper.getSidoCode();
	}
	
	/** 직업 분류 코드 **/
	public List<Map<String, Object>> getJobCode(){
		return memberMapper.getJobCode();
	} 

	

}
