<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
request.setCharacterEncoding("utf-8");
%>
<c:set var="id" value="hong" scope="page" />
<c:set var="pwd" value="1234" scope="page" />
<c:set var="name" value="홍길동" scope="page" />
<c:set var=" age" value="22" scope="page" />
<c:set var="height" value="177" scope="page" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<table border=1 align="center">
		<tr align="center" bgcolor="#99ccff">
			<td width="20%">
				<b>아이디</b>
			</td>
			<td width="20%">
				<b>비밀번호</b>
			</td>
			<td width="20%">
				<b>이름</b>
			</td>
			<td width="20%">
				<b>나이</b>
			</td>
			<td width="20%">
				<b>키</b>
			</td>
		</tr>
		<tr align="center">
			<td>${id}</td>
			<td>${pwd }</td>
			<td>${age }</td>
			<td>${height }</td>
		</tr>
	</table>
</body>
</html>