<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
request.setCharacterEncoding("utf-8");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<c:if test="${empty param.userID }">
아이디를 입력하세요.<br>
		<a href="login.jsp">로그인 창</a>
	</c:if>
	<c:if test="${not empty param.userID }">
		<h1>
			환영합니다.
			<c:out value="${param.userID }" />
			님!!
		</h1>
	</c:if>
	<c:choose>
		<c:when test="${empty param.userID }">
아이디를 입력하세요.<br>
			<a href="login.jsp">로그인 창</a>
		</c:when>
		<c:otherwise>
			<h1>
				환영합니다.
				<c:out value="${param.userID }" />
				님!!
			</h1>
		</c:otherwise>
	</c:choose>
</body>
</html>