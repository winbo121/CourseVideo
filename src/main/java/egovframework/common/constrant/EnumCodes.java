package egovframework.common.constrant;

import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.BiFunction;
import java.util.function.Function;
import java.util.stream.Collectors;
import org.apache.commons.collections4.MapUtils;
import org.apache.commons.lang3.StringUtils;
import com.google.common.base.Preconditions;
import com.google.common.collect.Maps;
import com.google.common.math.IntMath;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor( access = AccessLevel.PRIVATE )
public class EnumCodes {

	/** 공통 enum 의 인터페이스 **/
	private interface EnumInterface  {
		/** String code 와 일치하는지 확인한다. **/
		default boolean eq( String code ) {
			return StringUtils.equals( this.code(), code );
		}
		/** String code 와 일치하지 않는지 확인한다 **/
		default boolean not( String code ) {
			return !StringUtils.equals( this.code(), code );
		}
		/** String code 를 조회한다. **/
		default String code() {
			Preconditions.checkArgument( ( this instanceof Enum ) , "Not Enum Instance" );
			String name = ( (Enum<?>) this ).name();
			return name;
		}
	}

	/** 활동 코드 **/
	public enum ACTIVITY_CD implements EnumInterface{
		/** 로그인  **/
		LOGIN( "1" , 1 )
		,LOGIN_COMPENSATION("2", 1)
		/** 복습하기 **/
		,REVIEW("3", 3 );


		String code;

		@Getter
		int count;
		ACTIVITY_CD( String code, int count   ){
			this.code = code;
			this.count = count;
		}

		@Override
		public String code() {
			return this.code;
		}
	}

	/** 대표코드 **/
	public enum LEADER_CD  implements EnumInterface{
		/** 도서 카테고리 **/
		G01
		/** 어휘등급 관리 **/
		,G02
		/** 도서등급 관리  **/
		,G03
		/** FAQ 카테고리  **/
		,G04
		/** 도서 활동구분  **/
		,G05
		/** 팝업 그만보기 문구 **/
		,G06
		/** 어휘학년군 **/
		,G07
		/** 시도코드 **/
		,G08
		/** 도서 상태 **/
		,G09
		/** 보상활동코드 **/
		,G10
		;
	}
	
	/** 사용자 권한 유형 **/
	public enum ROLE_TYPE implements EnumInterface{
		/** 사용자 권한 **/
		ROLE_USER
		/** 담당자 권한 **/
		,ROLE_ADMIN
		/** 학생 권한 **/
		,ROLE_STUDENT
		/** 교사 권한 **/
		,ROLE_TEACHER
		/** 비교사 권한 **/
		,ROLE_INSTRUCTOR
		/** 평가원 담당자 권한 **/
		,ROLE_PERSON_IN_CHARGE
		;
	}


	/** Y or N **/
	public enum YN_CD implements EnumInterface{
		Y
		,N;
	}

	/** 파일 유형 타입 **/
	public enum FILE_REG_GB implements EnumInterface {
		 FILE_TYPE_TEST(null, true, null )

		/** 공지사항 **/
		,TS_NOTICE( "noti_seq", true, null )
		/** 공지사항 **/
		,TS_NOTICE_THUMB( "noti_seq", true, null )
		/** QNA ( 문의하기 ) **/
		,TS_QNA( "qna_seq", false, null )
		/** FAQ ( 자주 묻는 질문  ) **/
		,TS_FAQ( "faq_seq", false, null )
		/** 사용자 관리 **/
		,TS_USER_INFO( "user_id", true, "file_cnt" )
		/** 학급 활동 ( 현재 화면상에는 이미지 업로드이다.)**/
		,TS_CLASS_ACTIVITY("class_act_seq", true, null )
		/** 학급공지사항 **/
		,TS_CLASS_NOTICE("class_noti_seq", false, null)
		/** 교사학습자료 **/
		,TS_BOOK_DATA("book_data_seq", false, null)
		/** 교사추천자료 **/
		,TS_KICE_DATA("kice_data_seq", false, null)
		/** 팝업 **/
		,TS_POPUP("pop_seq", true, null)
		/** 홍보동영상 **/
		,TS_PROMOTE_VIDEO("video_seq", false, null)
		/** 콘텐츠 동영상 **/
		,TB_CONTENS_VIDEO("contents_seq", false, null)
		/** 콘텐츠 자막 **/
		,TB_CONTENS_SUBTITLE("contents_seq", false, null)
		/** 강좌 섬네일 **/
		,TB_COURSE_THUMBNAIL("course_seq",true,null)
		/** 콘텐츠 썸네일 **/
		,TB_CONTENS_THUMBNAIL("contents_seq", true, null)
		;


		/** 대상 테이블의 키 컬럼명 **/
		@Getter private String table_key;
		/** 이미지 서버 사용여부 **/
		@Getter private boolean use_image_server;
		/** 파일 서버 사용여부 **/
		@Getter private boolean use_file_server;
		/** 파일수량 컬럼명 **/
		@Getter private String count_table_column;
		/** 테이블 명 **/
		@Getter private String table;

		/** 테이블에 파일수량 카운트가 존재하는지 여부 **/
		public boolean hasCount() {
			return StringUtils.isNotEmpty( this.count_table_column );
		}

		private FILE_REG_GB(  String table_key
									,boolean use_image_server
									,String count_table_column) {
			this.table_key = table_key;
			this.use_image_server = use_image_server;
			this.count_table_column = count_table_column;
			this.table = this.code();
		}
	}
	
	/** 내부 자원 파일 다운로드 **/
	public enum RESOURCE_DOWNLOAD implements EnumInterface{

		HWP_001( "교사계정을 통한 학생 일괄 가입 시 학부모 개인정보이용동의서 및 위임장(책열매).hwp"
					 ,"classpath:supply/supply_hwp" )
		,PDF_001( "사용자 길잡이(교사용).pdf"
					,"classpath:supply/guide_teacher_pdf" )
		,PDF_002( "사용자 길잡이(학생용).pdf"
				,"classpath:supply/guide_student_pdf" )
		,PDF_003( "책열매_브로슈어.pdf"
				,"classpath:supply/kice_brochure_pdf" )
		,PDF_004( "사용자 길잡이(낱말게임).pdf"
				,"classpath:supply/guide_game_pdf" )
		;

		@Getter
		private String file_name;
		@Getter
		private String location;

		RESOURCE_DOWNLOAD( String file_name, String location ) {
			this.file_name = file_name;
			this.location = location;
		}


	}
	
	/** 파일 다운로드 구분 **/
	public enum FILE_DOWN_TYPE implements EnumInterface{
		/** 도서 검색 이력 **/
		READING_SEARCH( 1 )
		/** 독서 이력 **/
		,READING( 2 )
		/** 독서 활동 이력  **/
		,READING_ACTIVITY( 3 )
		/** 낱말 학습 이력  **/
		,WORD_ACTIVITY( 4 )
		/** 교수 학습 자료  **/
		,BOOK_DATA( 5 )
		/** 교수 추천 자료 (활동지)  **/
		,KICE_DATA( 6 )
		;
		
		@Getter
		int code;
		FILE_DOWN_TYPE( int code ){
			this.code = code;
		}

		@Override
		public String code() {
			return String.valueOf( this.code );
		}
	}
	
	
	/** 한글 형태소 품사( Part Of Speech : pos ) 허용 목록 **/
	public enum KOMORAN_POS_EXP implements EnumInterface {
		/** 도서 검색 [ 명사, 대명사, 외국어, 한자, 숫자 ] **/
		BOOK_SEARCH( "NNG", "NNP", "NNB", "NP", "NR", "SL", "SH", "SN" )
		;
		
		/** 허용되는 형태소 태그 리스트 **/
		List<String> pos_list;
		
		KOMORAN_POS_EXP( String... code ){
			this.pos_list = Arrays.asList( code );
		}
		
		/** POS 리스트 **/
		public List<String> getCode() {
			return this.pos_list;
		}
		
		/** 품사 태그가 EXP 내에 존재하는지 여부  **/
		public boolean contains( String pos_str ) {
			
			return this.pos_list.contains( pos_str );
			
		}

	}
	
	/** POPUP_CD **/
	public enum POPUP_CD implements EnumInterface{
		H( "HTML" )
		,I( "이미지" );
		
		@Getter private String name;
		private POPUP_CD( String name ) {
			this.name = name;
		}
	}

	
	
	
}
