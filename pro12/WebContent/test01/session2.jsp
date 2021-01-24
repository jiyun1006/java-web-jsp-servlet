<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String name = (String) session.getAttribute("name");
String address = (String) session.getAttribute("address");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	이름은
	<%=name %>
	입니다.
	<br>
	주소는
	<%=address%>
	입니다.
	<br>
</body>
</html>