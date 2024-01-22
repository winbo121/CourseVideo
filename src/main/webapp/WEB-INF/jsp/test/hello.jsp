<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
<head>
	<title>HELLO.html</title>

<script type="text/javascript" >
$(document).ready (function(){




	var hangulcheck = RegExp(  /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/ );
	var empty = RegExp( /\s/ );


	var reg = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,30}$/ ;

// 	var reg = RegExp(  /^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[$@$!%*#?&])[A-Za-z[0-9]$@$!%*#?&]{8,30}$/  );

	var pw = "0258asdf!@#";


	console.log( "한글:", hangulcheck.test(pw) );
	console.log( "공백:", empty.test(pw) );


	console.log("ㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷㄷ");
	console.log( pw );
	console.log( reg.test(pw) );


});




</script>
</head>



<body>
	<h1>${name}</h1>
	<table border="1">
		<thead>
		<tr>
			<th>TEST_KEY</th>
			<th>VAR1</th>
			<th>VAR2</th>
			<th>VAR3</th>
		</tr>
		</thead>
		<tbody>
		<c:forEach var="entry" items="${list}" >
			<tr>
				<td>${ entry.test_key }</td>
				<td>${ entry.var1 }</td>
				<td>${ entry.var2 }</td>
				<td>${ entry.var3 }</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>

</body>

</html>



