# 모델 2(MVC)      

>## 모델 2(MVC2 패턴)   

<br>

**Model, View, Controller로 구분되어 있는 디자인 패턴(화면 부분, 요청 처리 부분, 로직 처리 부분)**   

*모델 2방식의 특징*   

- 각 기능이 분리되어 유지보수가 편리.   
- 각 기능의 재사용성이 높음.   

<br>

>### 실제 회원정보 기능 예시   

<br>

*controller에 해당하는 servlet 코드*   

```java
String action = request.getPathInfo();

<# action값으로 요청한 작업을 분기해서 처리한다.>

System.out.println("action:" + action);   ---> url에서 요청명을 받는다.


if (action==null || action.equals("/listMembers.do")) {   ---> 멤버 리스트 요청.
  List<MemberVO> membersList = memberDAO.listMembers();
  request.setAttribute("membersList", membersList);
  nextPage = "/test02/listMembers.jsp";

}else if (action.equals("/addMember.do")) {
  String id = request.getParameter("id");
  String pwd = request.getParameter("pwd");
  String name = request.getParameter("name");
  String email = request.getParameter("email");
  MemberVO memberVO = new MemberVO(id,pwd,name,email);
  memberDAO.addMember(memberVO);
  nextPage = "/member/listMembers.do";
  
.....<생략>......

else {
  List<MemberVO> membersList = memberDAO.listMembers();
  request.setAttribute("membersList", membersList);
  nextPage ="/test02/listMembers.jsp";
}
RequestDispatcher dispatch = request.getRequestDispatcher(nextPage);

dispatch.forward(request, response);    ---> nextPage에 있는 url로 포워딩
```

*DAO클래스 코드(findMember 메서드)*      
```java
conn = dataFactory.getConnection();
String query = "select * from t_member where id = ?";  ---> query문을 이용해 요청한 id가 있는지 찾는다.
pstmt = conn.prepareStatement(query);
pstmt.setString(1, _id);
System.out.println(query);
ResultSet rs = pstmt.executeQuery();
rs.next();
String id = rs.getString("id");
String pwd = rs.getString("pwd");
String name = rs.getString("name");
String email = rs.getString("email");
Date joinDate = rs.getDate("joinDate");
memInfo = new MemberVO(id, pwd, name, email, joinDate);   ---> 있다면 memInfo객체에 저장.
pstmt.close();
conn.close();

...<생략>...
```

*DAO클래스 코드(modMember 메서드)*      
```java
String id = memberVO.getId();
String pwd = memberVO.getPwd();
String name = memberVO.getName();
String email = memberVO.getEmail();    ---> 수정할 데이터들을 받는다.
try {
  conn = dataFactory.getConnection();
  String query = "update t_member set pwd=?,name=?,email=?  where id=?";  ---> query문을 이용해서 해당 데이터 update
  System.out.println(query);
  pstmt = conn.prepareStatement(query);
  pstmt.setString(1, pwd);
  pstmt.setString(2, name);
  pstmt.setString(3, email);
  pstmt.setString(4, id);
  pstmt.executeUpdate();
  pstmt.close();
  conn.close();
  
 ...<생략>...
```

*DAO클래스 코드(delMember 메서드)*      
```java
conn = dataFactory.getConnection();
String query = "delete from t_member where id=?";   ---> query문을 이용해서 데이터 delete
System.out.println(query);
pstmt = conn.prepareStatement(query);
pstmt.setString(1, id);
pstmt.executeUpdate();
```
