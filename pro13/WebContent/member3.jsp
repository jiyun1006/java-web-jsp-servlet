<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,sec01.ex01.*"%>

<%request.setCharacterEncoding("utf-8");%>

<jsp:useBean id="m" class="sec01.ex01.MemberBean" scope="page" />
<%-- property와 value 둘 다 적음 --%>
<%--jsp:setProperty name="m" property="id" value =request.getParameter("id")d") %>'--%>

<%-- property와 param을 사용 (매개변수와 이름과 속성이 같아야 함.)--%>
<%-- jsp:setProperty name="m" property="id" param="id" --%>

<%-- property만 작성 (매개 변수 이름과 property와 같으면 자동으로 연결)--%>
<%--jsp:setProperty name="m" property="id"--%>

<%-- 전송된 매개변수 이름과 빈 속성을 비교한 후 동일한 빈에 값을 자동으로 연결 --%>
<jsp:setProperty name="m" property="*" />
<%
MemberDAO memberDAO = new MemberDAO();
memberDAO.addMember(m);
List membersList = memberDAO.listMembers();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<table align="center" width="100%">
		<tr align="center" bgcolor="#99ccff">
			<td width="7%">아이디</td>
			<td width="7%">비밀번호</td>
			<td width="5%">이름</td>
			<td width="11%">이메일</td>
			<td width="5%">가입일</td>
		</tr>
		<%
		if (membersList.size() == 0) {
		%>
		<tr>
			<td colspan="5">
				<p align="center">
					<b><span style="font-size: 9pt;"> 등록된 회원이 없습니다.</span></b>
				</p>
			</td>
		</tr>
		<%
		} else {
		for (int i = 0; i < membersList.size(); i++) {
			MemberBean bean = (MemberBean) membersList.get(i);
		%>
		<tr align="center">
			<td>
				<jsp:getProperty name="m" property="id"/>
			</td>
			<td>
				<jsp:getProperty name="m" property="pwd"/>
			</td>
			<td>
				<jsp:getProperty name="m" property="name"/>
			</td>
			<td>
				<jsp:getProperty name="m" property="email"/>
			</td>
			<td>
				<jsp:getProperty name="m" property="joinDate"/>
			</td>
		</tr>
		<%
}
}%>
		<tr height="1" bgcolor="#99ccff">
			<td colspan="5"></td>
		</tr>
	</table>
</body>
</html>