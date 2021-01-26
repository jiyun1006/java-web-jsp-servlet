<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%
request.setCharacterEncoding("utf-8");
%>
<jsp:useBean id="m" class="sec02.ex01.MemberBean" />
<jsp:setProperty name="m" property="*" />
<jsp:useBean id="addr" class="sec02.ex01.Address" />
<jsp:setProperty name="addr" property="city" value="서울" />
<jsp:setProperty name="addr" property="zipcode" value="07654" />
<%
m.setaddr(addr);
%>
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
				<b>이메일</b>
			</td>
		</tr>
	
		<tr align="center">
			<td>${m.id }</td>
			<td>${m.pwd }</td>
			<td>${m.name }</td>
			<td>${m.email }</td>
			<td>${m.addr.city }</td>
			<td>${m.addr.zipcode }</td>
		</tr>
	</table>
</body>
</html>