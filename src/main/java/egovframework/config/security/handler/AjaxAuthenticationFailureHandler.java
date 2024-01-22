package egovframework.config.security.handler;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;

import egovframework.common.util.CommonUtils;
import lombok.extern.slf4j.Slf4j;

/** 인증 실패시  **/
@Slf4j
public class AjaxAuthenticationFailureHandler extends SimpleUrlAuthenticationFailureHandler {


    @Override
    public void onAuthenticationFailure(HttpServletRequest request,
							    		HttpServletResponse response,
							    		AuthenticationException exception) throws IOException, ServletException {
        log.debug("CustomAuthenticationFailureHandler.onAuthenticationFailure ::::");

        CommonUtils.writerJsonResponse(response, "fail", "아이디 또는 비밀번호를 확인 바랍니다.");
    }



}
