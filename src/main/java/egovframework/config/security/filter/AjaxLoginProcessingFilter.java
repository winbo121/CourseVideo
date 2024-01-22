package egovframework.config.security.filter;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AbstractAuthenticationProcessingFilter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.util.StringUtils;

import egovframework.common.util.CommonUtils;
import egovframework.work.main.model.Login;

public class AjaxLoginProcessingFilter extends AbstractAuthenticationProcessingFilter {
	
     //필터 작동 조건 ("/ajax_login.do") 요청 했을때 필터가 작동되고 요청방식이 ajax  인지 확인후에 필터가 작동여부를판별할수 있도록 해준다. 
    public AjaxLoginProcessingFilter() {
    	super(new AntPathRequestMatcher("/ajax_login.do","POST"));
        
    }
   
    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response)
                                                throws AuthenticationException, IOException, ServletException {
        
        //Ajax 이면 인증을 요청하고 아니면 예외를 발생시킨다.
        if(CommonUtils.isResponseJsp(request)){        
        	CommonUtils.writerJsonResponse(response, "fail", "잘못된 접근입니다.");
        }
        //인증조건이 2개를 만어줬고 2개가 모두 통과되고 나서 하는일을 정해준다 
        //제이슨 방식으로 담아서 요청할건데 넘어온 정보를 객체로 더시 추출해서 담아야한다. 
        //읽어온 정보를 AccountDto.class 로 담아서 받도록 한다
        
        
        Login loginDto = new Login();
        String id = request.getParameter("user_id");
        String pw = request.getParameter("user_pw");
        loginDto.setUser_id(id);
        loginDto.setUser_pw(pw);
        
        //username,password 를 받아서 인증처리를 하게 되는데 만약 null이라면 인증처리를 할수 없게 해줘야한다
       if ( StringUtils.isEmpty(loginDto.getUser_id())){
    	   CommonUtils.writerJsonResponse(response, "fail", "아이디를 입력 바랍니다.");
        }
       if (StringUtils.isEmpty(loginDto.getUser_pw())){
    	   CommonUtils.writerJsonResponse(response, "fail", "비밀번호를 입력 바랍니다.");
        }
        
        // Token 클래스에 첫번째 생성자에게 정보들을 전달해주자  첫번째 생서자는
        //사용자의 username,password 를 전달받으니까 여기서 사용자의 username,password를 전달해주면된다.
        AjaxAuthenticationToken ajaxAuthenticationToken = new AjaxAuthenticationToken(
                loginDto.getUser_id(),loginDto.getUser_pw());
		
        //작성해준 토큰을 전달해주면된다. 
        return getAuthenticationManager().authenticate(ajaxAuthenticationToken);
    }
}