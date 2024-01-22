<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
/**
* @Class Name : loginOauthResult.jsp
* @Description : 소셜 로그인 결과 화면
* @Modification Information
*
*   수정일         수정자                   수정내용
*  -------    --------    ---------------------------
*  2023.03.10            최초 생성
*
* author KOTECH
*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- JQUERY 추가 -->
<script src="//code.jquery.com/jquery-3.3.1.min.js"></script>
</head>
<body>
<!-- 
<div>
${message}
</div>
<div>
#### RETURN DATA #### !!!${result}!!! 
</div>
<div>
<table>
	<thead>
		<th>Info</th>
		<th>Value</th>
	</thead>
	<tbody>
		<tr>
			<td>SERVICE_NAME</td>
			<td>${oAuthUser.serviceName}</td>
		</tr>
			<tr><td>U_ID</td>
			<td>${oAuthUser.uid}</td>
		</tr>
		<tr>
			<td>USER_ID</td>
			<td>${oAuthUser.userId}</td>
		</tr>
		<tr>
			<td>USER_NAME</td>
			<td>${oAuthUser.userName}</td>
		</tr>
		<tr>
			<td>NICK_NAME</td>
			<td>${oAuthUser.nickName}</td>
		</tr>
		<tr>
			<td>EMAIL</td>
			<td>${oAuthUser.email}</td>
		</tr>
	</tbody>
</table>
</div>
 -->
</body>
</html>
<script>
$(function() {
	const result = '${result}';
	const msg = '${message}';
	const uid = '${oAuthUser.uid}';
	const connid = '${oAuthUser.email}';
	const service = '${service}';
	opener.authCallBackFn(service,result,uid,connid,msg);
	self.close();
});
</script>
