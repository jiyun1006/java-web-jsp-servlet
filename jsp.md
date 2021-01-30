>## JSP

<br>

**웹 프로그램의 화면기능을 담당, 모델2 기반의 MVC에서 view 담당.**   

*톰캣 컨테이너에서 JSP 변환 과정*   

- 변환 단계 : 컨테이너가 JSP파일을 자바 파일로 변환.   

- 컴파일 단계 : 컨테이너가 변환된 자바파일을 클래스파일로 컴파일.   

- 실행 단계 : 컨테이너가 class파일을 실행하여 결과를 브라우저로 전송.   

<br>

*JSP 페이지 구성 요소*   

```
1 디렉티브 태그

2 스크립트 요소

3 표현 언어

4 내장 객체

5 액션 태그

6 커스텀 태그
```

<br><br>

>### 디렉티브 태그   

<br>

**JSP에 대한 전반적인 설정 정보를 지정할 떄 사용한느 태그**   

<br>

```
---디렉티브 태그 예시---

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

---인클루드 디렉티브 태그 예시---

<%@ include file="include_image.jsp"%>   ---> 만들어진 jsp파일을 html내로 불러온다. (재
```

<br><br>

>### 스크립트 요소, 표현언어   

<br>

**스크립틀릿으로 jsp로 전송된 값을 불러온다.**   

```
<%!String name = "이순신";

	public String getName() {   ---> jsp로 전송된 값을 스크립틀릿안의 메서드를 이용해서 받아온다.
		return name;
	}%>
<%
```   
<br>

**표현식을 통해 jsp에서 값을 출력하는 기능을 사용한다.**   

```
<h1>안녕하세요 <%=name%>님 </h1>  ---> 스크립틀릿에 선언한 name변수 사용.

<h1>나이+10은<%=Integer.parseInt(age) + 10%>살 입니다.</h1>   ---> 자바 메서드를 통해 표현식 사용.
```

<br>

### **<%! %> 와 <% %>의 차이점**   
```
둘 다 jsp에서 자바코드를 쓸 때 사용한다.

하지만 느낌표가 있으면 함수까지 선언이 가능하다.

<%! %> 는 member field영역이고,

<% %> 는 service method영역이다.

jsp 파일이 서블릿으로 변환 된, 파일을 보면, <% %>
```
<br><br>

>### 내장객체 기능   

<br>

**JSP가 서블릿으로 변환될 때 컨테이너가 자동으로 생성시키는 서블릿 멤버 변수.**   

request, response, session, application 등등 ....


<br>
<br>

- session, application 내장객체

<br>

**서블릿에서 생성한 session 객체를 jsp에서는 자동으로 session객체를 생성하므로 getSession메서드 없이 사용 가능하다.(application도 동일)**   

<br>

*servlet 코드*
```java
HttpSession session = request.getSession();  --> session객체를 생성하고,

session.setAttribute("name", "이순신");  --> session객체에 name을 바인딩한다.
```   

<br>

*jsp 코드*
```
<%
String name = (String) session.getAttribute("name");  ---> 스크립문으로 session

session.setAttribute("name", "이순신");
application.setAttribute("address", "서울시 성동구");   ---> session 과 application 둘 다 객체 생성없이 바인딩 가능하다.   
%>
```   

#### *session의 스코프는 같은 브라우저이고, application의 스코프는 애플리케이션이다.*   

<br><br>

- request 내장 객체

<br>

**내장 객체중 가장 많이 쓰이는 request도 사용법은 동일하다.**   

*jsp 코드*

```
<%
request.setAttribute("name", "이순신");
request.setAttribute("address", "서울시 성동구");   ---> request객체 생성없이 바로 바인딩한다.
%>

<%
RequestDispatcher dispatch = request.getRequestDispatcher("request2.jsp");
dispatch.forward(request, response);    ---> dispatch 객체를 이용해서 다른 jsp에 포워딩
%>
```

<br><br>

>### 예외 처리   

<br>

**jsp 페이지에 대해 발생하는 오류에 따라서 화면에 표시되는 각각의 예외 처리 jsp페이지를 적용할 수 있다. (web.xml에 설정)**   

<br>

*web.xml 내용*

```
<error-page>
   <error-code>404</error-code>
   <location>/err/error_404.jsp</location>     ---> 404에러가 발생했을 때, 보여줄 jsp 페이지
</error-page>

<error-page>
   <error-code>500</error-code>
   <location>/err/error_500.jsp</location>   ---> 500에러가 발생했을 때, 보여줄 jsp 페이지
</error-page>
```

*404에러 : 아예 없는 페이지,  500에러 : 실행 중 예외 발생*

<br><br>

>### welcome 파일   

<br>

**웹 어플리케이션 첫 화면에 해당하는 홈페이지를 web.xml에서 설정할 수 있다.**   

*web.xml 내용*   
```
<welcome-file-list>
	<welcome-file>/test2/main.jsp</welcome-file>   ---> 1순위
	<welcome-file>/test2/add.jsp</welcome-file>    ---> 2순위
	<welcome-file>/test2/add.html</welcome-file>   ---> 3순위
</welcome-file-list>
```

<br>
<br>

>### 스크립트 요소 - DB   

<br>

**DB와 연결한 정보를 스크립트 요소를 이용해 화면에 표시한다.**   

**search.jsp에서 검색한 이름이 db에 있으면 해당 이름만 표시하고, 없으면 표시를 안한다.(빈칸이면 db전체 멤버를 표시)**   

<br>

*search.jsp 코드*   

```java
<form method="post" action="member.jsp">    ---> 검색한 이름은 member.jsp로 전달한다.
이름 : <input type="text" name="name"><br>
<input type="submit" value="조회하기">
</form>
```
<br>

*member.jsp 코드*   

```java
<%
request.setCharacterEncoding("utf-8");
String _name = request.getParameter("name");   ---> search.jsp에서의 input태그의 name을 받아온다.

MemberVO memberVO = new MemberVO();
memberVO.setName(_name);  ---> memberVO 객체에 name값 저장.

MemberDAO dao = new MemberDAO();   
List membersList = dao.listMembers(memberVO);  ---> db와 연결해서 값을 꺼내올 mebersList 객체 생성.
%>
``` 

<br>

*MemberDAO의 listMembers 메서드*   

```java
public List<MemberVO> listMembers(MemberVO memberVO) {
List<MemberVO> list = new ArrayList<MemberVO>();
String _name = memberVO.getName();  ---> memberVO에 저장되어 있던 name 값을 가져온다.

try {
  con = dataFactory.getConnection();
  String query = "select * from t_member";
  if ((_name != null && _name.length() != 0)) {   ---> 입력된 name이 있으면,
	query += " where name=?";
	pstmt = con.prepareStatement(query);
	pstmt.setString(1, _name);

  } else {   ---> 입력된 name이 없으면,
	pstmt = con.prepareStatement(query);
}

.....생략
```   

<br><br>

>### JSP 액션태그   

<br>

**html안에 java코드를 줄일수 있게 하는 jsp 액션태그**   

<br>

*액션태그 종류*   
- include   
- forward   
- usebean   
- setproperty     
- getproperty   

<br>

```
---include 태그 코드---

<jsp:include page="dog_image.jsp" flush="true">  ---> 미리 image파일 작성한 jsp 파일을 명시
   <jsp:param name="name" value="듀크"/>
   <jsp:param name="imgName" value="doc.jpeg"/>   ---> dog_image.jsp에 전해줄 requset
</jsp:include>
```   


```
---forward 태그 코드---

<jsp:forward page="login.jsp" />
```

<br>

```
---setProperty태그 코드---

<%-- property와 value 둘 다 적음 --%>
<%--jsp:setProperty name="m" property="id" value =request.getParameter("id")d") %>'--%>

<%-- property와 param을 사용 (매개변수와 이름과 속성이 같아야 함.)--%>
<%-- jsp:setProperty name="m" property="id" param="id" --%>

<%-- property만 작성 (매개 변수 이름과 property와 같으면 자동으로 연결)--%>
<%--jsp:setProperty name="m" property="id"--%>

<%-- 전송된 매개변수 이름과 빈 속성을 비교한 후 동일한 빈에 값을 자동으로 연결 --%>
<jsp:setProperty name="m" property="*" />   		---> 이 방법이 가장 짧고 편하다.



---getProperty태그 코드---

<td>
   <jsp:getProperty name="m" property="id"/>   ---> userbean에 저장된 속성값을 이용해 값을 불러온다.
</td>

```

<br><br>

### *JSP 표현언어에서 동일한 속성 이름에 접근할 경우 객체의 속성 우선순위*
```
page --> request --> session --> application
```

<br>
<br>

>### 파일 업로드   

<br>

**파일 업로드 관련 api를 이용해서 파일을 업로드한다.**   

*파일업로드 servlet*
```java
File currentDirPath = new File("/var/webapps/upload/");   ---> 업로드할 파일 경로 설정.
DiskFileItemFactory factory = new DiskFileItemFactory();
factory.setRepository(currentDirPath);    ---> 설정한 파일경로 저장.
factory.setSizeThreshold(1024*1024);   ---> 최대 업로드 가능한 파일 크기 설정.

ServletFileUpload upload = new ServletFileUpload(factory);
try {
	List items = upload.parseRequest(request);   ---> request 객체에서 매개변수를 List로 가져옴.
	
	for(int i = 0; i < items.size(); i++) {
		FileItem fileItem = (FileItem) items.get(i);
		
		<# form 필드면 값 출력<
		if(fileItem.isFormField()) {
			System.out.println(fileItem.getFieldName()+ "=" + fileItem.getString(encoding));
		
		<# 파일 업로드 기능 수행.<
		}else {
			System.out.println("매개변수이름:" +fileItem.getFieldName());
			System.out.println("파일이름:"+fileItem.getName());
			System.out.println("파일크기:"+fileItem.getSize() + "bytes");
			
			<# 업로드하는 파일 이름을 가져오는 부분.>
			if(fileItem.getSize()>0) {
				int idx = fileItem.getName().lastIndexOf("\\");
				if(idx==-1) {
					idx = fileItem.getName().lastIndexOf("/");
				}
				String fileName = fileItem.getName().substring(idx+1);
				
				<# 업로드한 파일이름 저장소에 다운로드>
				File uploadFile = new File(currentDirPath+"/"+fileName);   
				fileItem.write(uploadFile);
			}
```
<br>

### *tomcat 파일업로드 경로 설정*
```
[1] File currentDirPath = new File("/var/webapps/upload/")  ---> docker tomcat 컨테이너 내부의 디렉토리를 설정.

[2] tomcat에 server.xml 파일 수정.
---> <Context docBase="톰캣내부의 디렉토리" path="jsp 프로젝트 디렉토리" />

```

<br><br>

>### 파일 다운로드   

<br>

*파일 다운로드 servlet*
```java
String file_repo = "/var/webapps/downloads/";    ---> 파일을 불러올 위치
String fileName = (String)request.getParameter("fileName");   ---> 매개변수로 전송된 파일 이름 읽어오기.

System.out.println("fileName=" + fileName);
OutputStream out = response.getOutputStream();   ---> OutputStream 객체 생성.
String downFile=file_repo+"/"+fileName;
File f = new File(downFile);

<# 파일 다운로드할 수 있게하는 코드>
response.setHeader("Cache-Control", "no-cache");
response.addHeader("Content-disposition", "attachment; fileName="+fileName);

FileInputStream in = new FileInputStream(f);
byte[] buffer = new byte[1024*8];   ---> 버퍼 기능을 이용해서 파일에서 버퍼로 데이터를 읽어와 한꺼번에 출력.
while(true) {
	int count = in.read(buffer);
	if(count==-1)
		break;
	out.write(buffer,0,count);
}
```   

<br>

### *tomcat 파일다운로드 경로 설정*
```
[1] String file_repo = "/var/webapps/downloads/";   ---> docker tomcat 컨테이너 내부의 디렉토리를 설정.
```


<br><br>

>### JSON(Ajax)   

<br>

**xml형식으로 연동할 경우 모바일 환경에서 퍼포먼스가 안좋음. 그래서 JSONdmfh eocp**   

**name/value 쌍으로 이루어진 데이터 객체를 전달하기 위한 개방형 표준 데이터 형식**   

<br>


*JSON활용 예시 코드*   

```
<script>javascript
$(function() {
	 $("#checkJson").click(function() {	      
	    var jsonStr = '{"members":[{"name":"박지성","age":"25","gender":"남자","nickname":"날센돌이"}'
	    	           +', {"name":"손흥민","age":"30","gender":"남자","nickname":"탱크"}] }';
			   
	    var jsonInfo = JSON.parse(jsonStr);  ---> JSON기능인 parse()메서드를 이용해 JSON자료형 설정.
	    
	    var output ="회원 정보<br>";
	    output += "=======<br>";
	    for(var i in jsonInfo.members){
              output += "이름: " + jsonInfo.members[i].name+"<br>";
	       output += "나이: " + jsonInfo.members[i].age+"<br>";
	       output += "성별: " + jsonInfo.members[i].gender+"<br>";
	       output += "별명: " +jsonInfo.members[i].nickname+"<br><br><br>";
	    }
	    $("#output").html(output);
	 });
    });
</script>
```
