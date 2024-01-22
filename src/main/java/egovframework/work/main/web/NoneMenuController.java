package egovframework.work.main.web;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.access.hierarchicalroles.RoleHierarchyImpl;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.google.common.collect.Maps;

import egovframework.common.util.CommonUtils;
import egovframework.common.base.BaseController;
import egovframework.common.component.member.MemberComponent;
import egovframework.common.component.member.model.MemberDetail;
import egovframework.common.constrant.Constrants;
import egovframework.common.constrant.EnumCodes.ROLE_TYPE;
import egovframework.common.error.exception.ErrorMessageException;
import egovframework.common.util.LocalThread;
import egovframework.common.util.StreamUtils;
import egovframework.config.encoder.Aes256Encoder;
import egovframework.config.security.secured.SecuredService;
import egovframework.work.account.service.AccountService;
import egovframework.work.main.model.Login;
import egovframework.work.main.model.main.SendMail;
import egovframework.work.main.model.signup.FindIdPassword;
import egovframework.work.main.model.signup.SignUp;
import egovframework.work.main.service.NoneMenuService;
import egovframework.work.oauth.service.OAuthService;
import lombok.extern.slf4j.Slf4j;
import twitter4j.JSONObject;

/** 메뉴가 존재하지 않는 페이지 컨트롤러 **/
@Slf4j
@Controller
public class NoneMenuController extends BaseController {

	@Autowired
	private NoneMenuService noneMenuService;
	
	
	@Autowired 
	private Aes256Encoder aes256Encoder;
	

	@Autowired
	protected AccountService accountService;
	
	@Autowired
	private OAuthService oAuthService;
	
	// 인증 코드 자릿 수 지정
	private static final int CODE_SIZE = 10;
	
	/** 로그인 페이지  **/
	@RequestMapping( value="/login_page.do" , method=RequestMethod.GET)
	public String login_page(ModelMap  model, @ModelAttribute Login login, HttpSession session ) {
		
		/* SPRING_SECURITY_CONTEXT */
		
		
		if(session.getAttribute("SPRING_SECURITY_CONTEXT") != null) { return "redirect:/index.do"; }
		 
		
		model.addAttribute( "cookie_remember_id_key", Constrants.REMEMBER_USER_ID_KEY );
		model.addAttribute("social",oAuthService.getSocialInfoList());
		
		return "login_page";
	}

	/** 권한없음 페이지 **/
	@RequestMapping( value="/access_denied.do" , method=RequestMethod.GET)
	public String access_denied() {
		return "access_denied";
	}
	
	



	public interface RULES extends ALL {}
	public interface SIGN_UP extends RULES {}
	public interface EMAIL_AUTHENTIFICATION extends RULES {}
	public interface USER_SIGN_UP extends SIGN_UP {}
	public interface FIND_USER_ID extends RULES {}
	public interface RESET_PASSWORD extends RULES {}
	/** 회원가입 선택 페이지  **/
	@RequestMapping( value="/choice_page.do" , method=RequestMethod.POST )
	public String choice_page() {
		return "choice_page";
	}
	/** 회원가입 약관 페이지  **/
	@RequestMapping( value="/rules_page.do" , method=RequestMethod.POST )
	public String rules_page( @ModelAttribute(name="signup") SignUp signup ) {
		/** 유효성 체크 **/
		super.doValidted( signup, RULES.class );
		return "rules_page";
	}
	/** 아이디 찾기 페이지  **/
	@RequestMapping( value="/find_id_page.do" , method=RequestMethod.POST )
	public String find_id_page() {
		return "find_id_page";
	}
	/** 비밀번호 재설정 페이지  **/
	@RequestMapping( value="/reset_password_page.do" , method=RequestMethod.POST )
	public String reset_password_page() {
		return "reset_password_page";
	}
	
	/** 회원가입 이메일 인증 페이지  **/
	@RequestMapping( value="/authentification_page.do" , method=RequestMethod.POST)
	public String authentification_page( @ModelAttribute(name="signup") SignUp signup ) {
		/** 유효성 체크 **/
		super.doValidted( signup, SIGN_UP.class );
		return "authentification_page";
	}

	/** 회원가입 페이지  **/
	@RequestMapping( value="/signup_page.do" , method=RequestMethod.GET)
	public String signup_page( @ModelAttribute(name="signup") SignUp signup
								,HttpSession session, Model model ) {
		
		
		/** 유효성 체크 **/
		super.doValidted( signup, RULES.class );
		
		/** 사용자 권한일 경우 **/
		if( StringUtils.equals( signup.getRole_type(), ROLE_TYPE.ROLE_USER.code() ) ) {
			super.doValidted( signup ,  EMAIL_AUTHENTIFICATION.class );
			
			/** 체크여부 **/
			Boolean isAlreadyUserEmail = noneMenuService.emailDuplicateCheck( signup.getEmail() );
			if( isAlreadyUserEmail ) {
				super.throwMessageException("already.user.email");
			}
			
			session.setAttribute( Constrants.AUTHENTIFICATION_USEREMAIL_KEY, signup.getEmail() );
		}
		
		model.addAttribute("social",oAuthService.getSocialInfoList());
		model.addAttribute("sido_code", noneMenuService.getSidoCode());
		model.addAttribute("job_code", noneMenuService.getJobCode());
		
		
		return "memberKotechRegister";
	}


	/** 회원 가입 **/
	@RequestMapping( value="/signup.do" , method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> signup( @ModelAttribute SignUp signup
										,HttpSession session ){


		log.info("###################################");
		log.info("# XSS 처리 ");
		log.info("{}",signup.toString());
		log.info("###################################");


		
		if( signup.getIsUser() ) {
			super.doValidted( signup, USER_SIGN_UP.class );
			
			/** 이메일 파라미터 위변조 방지 **/
			String user_email = (String) session.getAttribute( Constrants.AUTHENTIFICATION_USEREMAIL_KEY );
			signup.setEmail( user_email );
		}

		/** 응답값 **/
		Map<String, Object> result = Maps.newHashMap();

		noneMenuService.signup( signup );

		session.removeAttribute( Constrants.AUTHENTIFICATION_USEREMAIL_KEY );
		
		return result;
	}







	/** 회원가입 완료 페이지  **/
	@RequestMapping( value="/complete_page.do" , method=RequestMethod.GET)
	public String complete_page() {
		return "complete_page";
	}
	
	@Autowired
	private SendMail sendMail;
	
	/** HOME URL **/
	@Value(value="${sign.up.url.path}")
	private String sign_up_url_path;
	
	/** 이메일 인증 **/
	@RequestMapping( value="/authentication_email.do", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> authentication_email( HttpServletRequest request, @ModelAttribute(name="signup") SignUp signup ) {
		
		super.doValidted( signup ,  EMAIL_AUTHENTIFICATION.class );
		
		/** 응답값 **/
		Map<String, Object> result = Maps.newHashMap();
		
		/** 이메일 중복 체크여부 **/
		Boolean isAlreadyUserEmail = noneMenuService.emailDuplicateCheck( signup.getEmail() );
		result.put( "isAlreadyUserEmail" , isAlreadyUserEmail );
		
		if( isAlreadyUserEmail ) {
			return result;
		}
		//이메일 인증임시비밀번호 생성
		String ran_code = sendMail.generateVerificationCode(CODE_SIZE);
		//이메일 인증임시비밀번호 저장
		HashMap<String,Object> resmap = new HashMap<String,Object>();
		resmap.put("email", signup.getEmail());
		resmap.put("ran_code", ran_code);
		
		
		String saveTempCode = noneMenuService.updateEmailTempCode( resmap);
		
		
		 
		/** 인증 URL **/
		String authentification_url = sign_up_url_path
										+ "?is_certification_email=Y"
										+ "&role_type=" + signup.getRole_type() 
										+ "&terms_yn=" + signup.getTerms_yn()
										+ "&consent_yn=" + signup.getConsent_yn()
										+ "&email=" + signup.getEmail();
		
		String title = "KOTECH LMS 회원 가입 이메일 인증";
		String text = "<h1>메일 인증</h1> <br/><br/>"
						+ "인증 코드는 " + ran_code + " 입니다. <br/></br>" 
						+ "회원 가입을 진행하시려면 아래 링크를 클릭해서 인증 코드를 입력 후 진행해 주세요.<br/><br/>"
						+ "<a href='" + authentification_url + "'>회원 가입하러 가기</a>";
		try {
			
			sendMail.sendMail( signup.getEmail() , title, text);
			System.out.println("############################################# ################################");
			System.out.println("############################################# ################################");
			System.out.println("############################################# ################################");
			System.out.println("발송 되었습니다 !");
			System.out.println(ran_code);
			
			
		} catch( Exception e ) {
			/** 메일 발송에 실패했을 경우 **/
			super.throwMessageException("com.mail.send.fail");
		}
		
		return result;
		
	}
	
	
	/** 이메일 중복 검사 **/
	@RequestMapping( value="/email_duplicate_check.do", method=RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> email_duplicate_check( @RequestParam( "email" ) String email ) {
		
		/** 응답값 **/
		Map<String, Object> result = Maps.newHashMap();
		
		/** 체크여부 **/
		Boolean isAlreadyUserEmail = noneMenuService.emailDuplicateCheck( email );
		result.put( "isAlreadyUserEmail" , isAlreadyUserEmail );
		
		return result;
	}
	
	
	/** 아이디(회원가입) 중복 검사 **/
	@RequestMapping( value="/id_duplicate_check.do", method=RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> id_duplicate_check( @RequestParam( "user_id" ) String user_id, 
			@RequestParam("chk_id") String chk_id ) {
		
		/** 응답값 **/
		Map<String, Object> result = Maps.newHashMap();
		

		
		/** 체크여부 **/
		Boolean isAlreadyUserId = noneMenuService.idDuplicateCheck( user_id, chk_id );
		result.put( "isAlreadyUserId" , isAlreadyUserId );
		
		return result;
	}
	
	/** 이메일 인증코드 확인 **/
	@RequestMapping( value="/code_duplicate_check.do", method=RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> code_duplicate_check( @RequestParam( "email" ) String email, 
													@RequestParam("at_code") String at_code ) {
		
		/** 응답값 **/
		Map<String, Object> result = Maps.newHashMap();
		
		
		/** 체크여부 **/
		Boolean isCodeYn = noneMenuService.codeDuplicateCheck( email, at_code );
		result.put( "isCodeYn" , isCodeYn );
		
		
		
		return result;
	}
	
	/** 아이디(학급관리) 중복 검사 **/
	@RequestMapping( value="/id_duplicate_check_stu.do", method=RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> id_duplicate_check( @RequestParam( "user_id" ) String user_id) {
		
		/** 응답값 **/
		Map<String, Object> result = Maps.newHashMap();
		
		
		
		/** 체크여부 **/
		Boolean isAlreadyUserId = noneMenuService.idDuplicateCheckStu( user_id);
		result.put( "isAlreadyUserId" , isAlreadyUserId );
		
		return result;
	}
	
	
	
	/** 아이디 찾기 **/
	@RequestMapping( value="/find_id.do", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> find_id( HttpServletRequest request, @ModelAttribute FindIdPassword findIdPassword ) {
		
		super.doValidted(findIdPassword, FIND_USER_ID.class);
		
		/** 응답값 **/
		Map<String, Object> result = Maps.newHashMap();
		
		/** 아이디 DB 조회 **/
		String user_id = noneMenuService.findUserId( findIdPassword.getEmail() );
		
		/** 해당 아이디를 메일로 전송 **/
		String title = "한 학기 한 권 읽기 아이디 찾기";
		String text = "<h1>회원 아이디를 보내드립니다.</h1> <br/><br/>"
						+ "회원 아이디 : " + user_id;
		try {
			sendMail.sendMail( findIdPassword.getEmail() , title, text);
		} catch( Exception e ) {
			/** 메일 발송에 실패했을 경우 **/
			super.throwMessageException("com.mail.send.fail");
		}
		
		return result;
	}
	
	/** 비밀번호 재설정 **/
	@RequestMapping( value="/reset_password.do", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> reset_password( HttpServletRequest request, @ModelAttribute FindIdPassword findIdPassword ) {
		
		super.doValidted(findIdPassword, RESET_PASSWORD.class);
		
		/** 응답값 **/
		Map<String, Object> result = Maps.newHashMap();
		
		/** 비밀번호 재설정 **/
		String new_user_password = noneMenuService.resetPassWord( findIdPassword );
		
		/** 메일 발송 **/
		String title = "KOTECH LMS 사이트 비밀번호 재설정";
		String text = "<h1>비밀번호가 재설정 되었습니다.</h1> <br/><br/>"
						+ "임시 비밀번호 : " + new_user_password;
		try {
			sendMail.sendMail( findIdPassword.getEmail() , title, text);
		} catch( Exception e ) {
			/** 메일 발송에 실패했을 경우 **/
			super.throwMessageException("com.mail.send.fail");
		}
		
		return result;
	}

	/** EPKI 인증 페이지  **/
	@RequestMapping( value="/epki_certificate.do" , method=RequestMethod.GET)
	public String epki_certificate_page( @ModelAttribute(name="signup") SignUp signup ) {
		log.debug("signup data{}", signup);
		/** 유효성 체크 **/
		super.doValidted( signup, RULES.class );
		
		/** 교사 권한일 경우 **/
		if( StringUtils.equals( signup.getRole_type(), ROLE_TYPE.ROLE_TEACHER.code() ) ) {
			super.doValidted( signup, SIGN_UP.class );
		}
		
		/** local 환경에서 epki test 불가하기떄문에 signup 페이지로 넘어감. **/
		if( StringUtils.equals( signup.getProfile(), "local") || StringUtils.equals( signup.getProfile(), "dev")) {
			return "signup_page";
		}
		 
		return "epki_certificate_page";
	}
	
	/** 서비스 점검 페이지  **/
	@RequestMapping( value="/maintenance.do" , method=RequestMethod.GET )
	public String maintenance(Model model) {
		model.addAttribute("isMaintenance", true);
		return "maintenance";
	}
	
	@Autowired
	private SecuredService securedService;
	
	/** 접속허용 가능한 IP 대역 **/
    private static final String[] PERMITION_ALLOWED_IP_ADDRESS = { "45.64.174.89" , "127.0.0.1" , "0:0:0:0:0:0:0:1" };
    
	/** 강제 로그인 페이지  **/
	@RequestMapping( value="/force_login.do" , method=RequestMethod.GET)
	public String forcelogin_page(ModelMap  model 
				,@RequestParam("user_id") String user_id
				,@ModelAttribute Login login
				,HttpSession session
				,HttpServletRequest request ) throws Exception {
		
	    boolean result = false;
	    
	     
	    log.info( " ################ LocalThread.getRemoteAddr() = {} ################## ", LocalThread.getRemoteAddr() );
	    
	    Boolean is_chk_ip = StreamUtils.toStream( PERMITION_ALLOWED_IP_ADDRESS )
	    								.anyMatch( element -> StringUtils.equals( element , LocalThread.getRemoteAddr()) );
	    
	    if( is_chk_ip == true ) {
	    	
	    	log.info( " ####################### CHECK SUCCESS IP ######################### " );
	    	
	    	List<UserDetails> list = securedService.loadUsersByUsername( user_id );

			List<GrantedAuthority> loadUserAuthorities = securedService.loadUserAuthorities( user_id );

			UserDetails ckUserDetails = list.stream()
											.findFirst().orElseThrow( () -> new ErrorMessageException("com.none.data", "아이디") );

			String hierarchicalRoles = securedService.getHierarchicalRoles();
			RoleHierarchyImpl roleHierarchy = new RoleHierarchyImpl();
								roleHierarchy.setHierarchy(hierarchicalRoles);
								
			/** 권한 계층 구조에 의한 최종 권한 세팅 **/
			Collection<? extends GrantedAuthority> authorities = roleHierarchy.getReachableGrantedAuthorities(loadUserAuthorities);

			Authentication authentication = new UsernamePasswordAuthenticationToken(ckUserDetails,
					"USER_PASSWORD", authorities);
			SecurityContext securityContext = SecurityContextHolder.getContext();
			securityContext.setAuthentication(authentication);
			session = request.getSession(true);
			session.setAttribute("SPRING_SECURITY_CONTEXT", securityContext);

			String username = authentication.getName();
			String remoteAddr = CommonUtils.getClientIp( request );

			securedService.addLoginLog( username, remoteAddr );
			
			result = true;
	    }
	    
	    model.addAttribute( "result", result );
		
		return "force_login_page";
	}
	
	
	/** 낱말게임 외부 API 
	 * @throws BadPaddingException 
	 * @throws IllegalBlockSizeException 
	 * @throws ParseException **/
	@ResponseBody
	@RequestMapping( value= "/wordGameApi.do" , method=RequestMethod.GET, produces = "application/json;charset=UTF-8;" )
	public String wordGameApi( 
			HttpServletRequest request ,Model model ) throws IllegalBlockSizeException, BadPaddingException, ParseException{
		
			
		Map<String, Object> result = Maps.newHashMap();
		String checkIn = request.getParameter("checkIn");
		String decodeCheckIn = aes256Encoder.decode(checkIn.replaceAll(" ", "+"));
		JSONObject jsonObjectMake = new JSONObject(decodeCheckIn);
		
		try {
			MemberDetail memberDetail =new MemberDetail();

			memberDetail.setUser_id(jsonObjectMake.get("user_id").toString());
			memberDetail.setUser_pw(aes256Encoder.encode(jsonObjectMake.get("user_pw").toString()));
			/** 응답값 **/
			MemberDetail memberDetailReturn = accountService.wordGameApi(memberDetail);


			
			if( memberDetailReturn == null)
			{
				result.put("result", 300);
			}
			else {
				String schCd = memberDetailReturn.getSch_cd();
					if("1".equals(memberDetailReturn.getQuiz_cnt()) || "9999999999".equals(schCd) ) {
	
						/** 아이디 **/
						result.put( "user_id", memberDetailReturn.getUser_id() );
						/** 이름 **/
						result.put( "user_name", memberDetailReturn.getUser_name() );
						/** 학교명 **/
						result.put( "sch_name", memberDetailReturn.getSch_name() );
						/** 학년 **/
						result.put( "sch_grade", memberDetailReturn.getSch_grade() );
						/** 반 **/
						result.put( "sch_class", memberDetailReturn.getSch_class() );
						/** 성별 **/
						result.put( "gender", memberDetailReturn.getGender() );
						/** 보상레벨 **/
						result.put( "badge_grade", memberDetailReturn.getBadge_grade() );
						/** 보상포인트 **/
						result.put( "point", memberDetailReturn.getReward_point() );
						
						result.put("result", 200);
						}
						else {
							result.put("result", 400);
						}
			}
		}catch(Exception e) {
			System.out.println(e.toString());
			result.put("result", 500);
		}

		
		return CommonUtils.TO_JSON.apply( result );
	}
}
