# Java_web (JSP, Servlet)   

>## 개발환경 설정   

<br>

```
기본환경 - Ubuntu20.04, Docker20.10.1

build path 설정 - servlet-api.jar, ojdbc8.jar

현재 docker 생성할 때, 고정된 ip를 할당하지 않았으므로, ip 주소가 계속 바뀜 ... --> 다음에는 컨테이너 설정 때 꼭 확인.
```
<br>

>### [1] JDK 설치  

<br>

**jdk11 버전을 다운로드 하고, path 설정을 한다.**   

<br>

*원래 설치된 위치 얻기.*   


```
readlink -f [링크위치]
```
<br>

**이미 설치된 jdk가 있다면 원하는 버전으로 바꾼다.**   

```
sudo update-alternatives --config java
``` 

<br><br>

>### [2] Tomcat 설치   

<br>

**docker를 사용해서 톰캣을 구축한다.**   

<br>

**docker 이미지 받기**   
```
docker pull tomcat:9
```   
<br>

**docker 실행 시키기.**   

```
docker run 옵션

-d 백그라운드 실행 
-it 컨테이너를 종료하지 않고, 터미널 입력 전송
```

<br>

```
docker run -dit --name [별칭] -p [호스트 포트]:[컨테이너 포트] [도커 이미지 이름]
```   
<br><br>

>### [3] 오라클 설치   

<br>

**docker를 사용해서 오라클db를 구축한다.**   

<br>

**docker 로그인, 이미지 다운로드, 컨테이너 실행**   

```
docker login

docker pull store/oracle/database-enterprise:12.2.0.1

docker run -dit --name [별칭] -p [호스트 포트]:[컨테이너 포트] [도커 이미지 이름]
```   

<br>

**오라클 접속 계정 생성**   

```
docker exec -it [컨테이너 이름 or 별칭] bash -c "source /home/oracle/.bashrc; sqlplus sys/Oradoc_db1@ORCLCDB as sysdba"   
```   

<br>

**sql쿼리문으로 사용자 생성 및, 권한 할당**   

```sql
alter session set "_ORACLE_SCRIPT"=true;

# 유저 생성
create user [유저id] identified by [password];   

# 생성한 유저에 권한 설정
grant connect, resource, dba to [유저 id];
```

<br><br>


------------------------
------------------------

<br>
<br>

>## Tomcat    

<br>

**docker에 tomcat을 실행시켰기 때문에, 프로젝트를 war로 변환 후, deploy한다.**   

**eclipse편집기에서 프로젝트 폴더를 war로 변환시킨 후, 해당 파일을 docker의 tomcat에 옮긴다.**  

```
docker cp [파일이름.war] [tomcat container 이름]:/usr/local/webapps/
```   

<br>


**tomcat container를 구동시킬 때, 설정한 포트로 들어가서 보면, 잘 작동하고 있다.**   

*예) localhost:8080 / [프로젝트 폴더 명] / [파일명.html]*



<br><br>

>## Servlet   

<br>

**서버 쪽에서 실행되면서 기능을 수행한다. (웹 브라우저에서 요청 시 기능을 수행)**      

**스레드 방식으로 실행되며, 자바의 특징을 가진다. (객체지향)**   

**HttpServlet 클래스를 상속받아서 사용한다.**   

<br>

*서블릿 생명주기 메서드*   

```
초기화 - init()

작업수행 - doGet(), doPost()

종료 - destroy()
```

<br>


*HttpServlet클래스의 메서드를 다시 사용하기 위해서 Override 어노테이션을 이용한다.*   



```java
---예시---

@Override
	public void init() throws ServletException{
		System.out.println("init 메서드 호출");
	}
```
<br>

**tomcat에 띄우기 위해 긴 패키지 이름을 web.xml에서 다시 설정한다.**   

```xml
<servlet>
 <servlet-name>aaa</servlet-name>  * servlet태그와 servlet-mapping태그를 연결 시키는 태그.
 <servlet-class>sec01.ex01.FirstServlet</servlet-class>  * 기존 패키지 이름
</servlet>
<servlet-mapping>
 <servlet-name>aaa</servlet-name>
 <url-pattern>/first</url-pattern>  * 웹 브라우저에서 요청하는 매핑 이름.
</servlet-mapping>
```

<br>
<br>

>### url 매핑 (어노테이션 이용)   

<br>

**class 파일이 속한 package명을 web.xml을 이용해서 매핑을 하게 되면 다중 매핑 작업 시에 복잡해진다.**   

**따라서 class 파일이 아니라 servlet을 생성해서 바로 매핑하게끔 한다.**   

<br>

*sec01.ex01의 url을 third로 매핑*
```
--- sec01.ex01 의 Servlet파일 ---

@WebServlet("/third")  *xml파일에 적는 것 보다 간편하고 효율적이다.

```

<br>
<br>

>### 클라이언트 요청 처리(request)     

<br>

**서블릿 파일에서 메서드를 이용해서 form태그의 요청을 처리**   

**다중 요청이 있는 경우 input태그의 name값을 기준으로 묶어서 처리**   

<br>

*getParameterValues메서드 이용 (반복문 이용해서 상태 확인)*      

```java

---subject라는 name값을 가진 요청 배열로 받음---

String[] subject = request.getParameterValues("subject");
		
for(String str : subject) {
	System.out.println("선택한 과목 : " + str);
}
```

<br>

**name이 다르거나 많은 요청이 있을 경우 비효율적.**   

**열거형 Enumeration을 이용해서 form태그의 모든 name값들을 받은 후, 반복문으로 처리**   

<br>

*getParameterNames 메서드 이용*   
*nextElement메서드는 현재 위치의 열거형 인자를 내뱉고, 다음 위치로 이동시킨다.*   

```java

# form 태그의 모든 input값 모음.
Enumeration enu = request.getParameterNames();

while (enu.hasMoreElements())
{	

#다음 인자를 선택하기 위해 nextElement사용.
 String name = (String) enu.nextElement();
 String[] values = request.getParameterValues(name);
 for (String value : values)
 {
  System.out.println("name=" + name + ", value=" + value);
 }
}
```
<br><br>

>### 클라이언트 요청에 대한 응답(response)   

<br>

**form태그의 request를 받아오고 웹 브라우저에 응답을 하지 않아, 브라우저상의 변화가 보이지 않는다.**   

**response를 담당하는 servlet파일을 만들어 브라우저로 쏴준다.**   

<br>
 
*form 태그의 action값과 servlet url을 매핑한다.*    

*setContentType 메서드를 이용해서 응답할 데이터의 종류를 정한다.*   

```java
# 응답할 데이터가 html임을 설정.
response.setContentType("text/html;charset=utf-8");

# PrintWriter 객체를 설정
PrintWriter out = response.getWriter();

# html 
String data = "<html>";
	data += "<body>";
	data += "아이디 : " + id;
	data += "<br>";
	data += "패스워드 : " + pw;
	data += "</html>";
	data += "</body>";
	
# PrintWriter 객체를 이용해 데이터 출력.	
	out.print(data);
```

<br><br>

>### 서블릿 데이터베이스 연동   

<br>

**클라이언트의 db에 관련된 request를 DAO와 VO 클래스를 이용해서 해결한다.**   

**MemberServlet에서 요청을 받고 MemberDAO객체를 생성하고, DB와 연동한다.**   

**이후에 조회된 정보를 MemberVO속성에 설정 후, list만들어 MemberServlet로 가져온다.**    

<br>

*MemberServlet 코드 일부*   

```java
MemberDAO dao = new MemberDAO(); --> sql문으로 조회할 MemberDAO 객체 생성.

List<MemberVO> list = dao.listMembers(); --> listMember() 메서드로 회원 정보 조회.

for (int i = 0; i < list.size(); i++) {
	MemberVO memberVO = list.get(i); --> db에서 가져온 항목들 하나씩 순회
	String id = memberVO.getId();
	String pwd = memberVO.getPwd();
	String name = memberVO.getName();
	String email = memberVO.getEmail();
	Date joinDate = memberVO.getJoinDate();
	out.print("<tr><td>" + id + "</td><td>" + pwd + "</td><td>" + name + "</td><td>" + email + "</td><td>"
			+ joinDate + "</td></tr>");

}
```    

<br>

*MemberDAO에서 listMembers 메서드*    

```java
List<MemberVO> list = new ArrayList<MemberVO>();
try
{
	connDB();  --> 연결된 db와의 정보로 데이터베이스와 연결하는 메서드
	
	String query = "select * from t_member";
	System.out.println(query);
	ResultSet rs = stmt.executeQuery(query);  --> sql문으로 db 조회.
	while(rs.next())
	{  
	 String id = rs.getString("id");    ---> 조회한 레코드의 칼럼값을 받고, MemberVO 객체에 속성 설정.
	 String pwd = rs.getString("pwd");
	 String name = rs.getString("name");
	 String email = rs.getString("email");
	 Date joinDate = rs.getDate("joinDate");
	 MemberVO vo = new MemberVO();
	 vo.setId(id);
	 vo.setPwd(pwd);
	 vo.setName(name);
	 vo.setEmail(email);
	 vo.setJoinDate(joinDate);
	 
	 list.add(vo);  --> MemberVO 객체를 다시 ArrayList에 저장 (MemberServlet
	}
	
	rs.close();  --> 늦게 연것부터 닫는다.
	stmt.close();
	con.close();
```   

<br>

>#### MemberDAO - DB연결 상수   

<br>


**DB와의 연결을 위해 driver, url, user, pwd 네 가지의 상수를 설정해야 한다.**   

**주의할 점은 현재 docker로 oracle과 tomcat을 구동중이니, 이 둘을 연결시켜야 한다.**   

**docker상의 tomcat의 lib폴더에 ojdbc7.jar 파일을 넣어준다.(oracle11이상버전)**   

<br>

### **또한 docker상의 oracle의 ip주소를 알아내어, url 상수에 넣어준다.(local ip를 넣으면 연결이 안된다.)**   

*docker inspect [컨테이너 명] 로 해당 컨테이너의 ip주소를 알 수 있다.*   

<br>

*memberDAO에서 DB와의 연결을 위해 설정할 상수*   

```
---사용할 DB---
private static final String driver = "oracle.jdbc.driver.OracleDriver";

---사용할 db의 포트(docker환경 oracle의 ipaddress)---
private static final String url = "jdbc:oracle:thin:@[host ip]:1521:[sid]";  

---oracle db의 접속 id,pw---
private static final String user = "user_name";
private static final String pwd = "password"; 
```

<br>

>#### PreparedStatement   
<br>

```
기존의 Statement 인터페이스는 sql을 컴파일하고 DBMS에 전달한다. --> 시간소모 큼

수행속도를 줄이기 위해서 PreparedStatement는 컴파일된 sql문을 DBMS에 전달한다. 
```

<br>
<br>

>### ConnectionPool   

<br>

**톰캣 컨테이너 실행 시,ConnectinoPool객체를 생성해서, DBMS와 연결한다.**   

**docker 톰캣 디렉토리안에 context.xml 파일을 현재 사용하고 있는 DBMS로 설정한다.**   

<br>

```xml
<Resource
    name = "jdbc/oracle"
    auth = "Container"
    type = "javax.sql.DataSource"
    driverClassName = "oracle.jdbc.driver.OracleDriver"
    url = "jdbc:oracle:thin:@172.17.0.2:1521:ORCLCDB"   ---> 현재 docker oracle 컨테이너 생성할 때, 고정된 ip를 주지 않았으므로, 계속 바뀐다......
    username = ""
    password = ""
    maxActive = "50"
    maxWait="-1" />
```   

<br>

*바뀐 MemberDAO*   

```java
Context ctx  = new InitialContext();

Context envContext = (Context) ctx.lookup("java:/comp/env");  --> JNDI에 접근하기 위해 기본 경로를 지정.

dataFactory = (DataSource) envContext.lookup("jdbc/oracle"); --> context.xml에 설정한 내용으로 
```
 
<br><br>

>### 서블릿 포워드   

<br>

**하나의 서블릿에서 다른 서블릿이나 jsp 등으로 연동하는 방법을 포워드라고 한다.**   


- request에 대한 추가 작업을 다른 서블릿에게 수행하게 한다.     

- request에 포함된 정보를 다른 서블릿이나 jsp와 공유할 수 있다.   

- request에 정보를 포함시켜 다른 서블릿에 전송이 가능하다.    

<br>

- 웹 브라우저를 거쳐 다른 서블릿으로 요청하는 방법   

	- Redirect 방법 - sendRedirect() 메서드 사용    
	
	```java
	---name=lee 와 같이 데이터도 전송 가능---
	
	response.sendRedirect("second?name=lee");
	```   
	<br>
	
	- Refresh 방법- addHeader() 메서드 사용   
	
	```java
	---1초 지연 시간 추가---
	
	response.sendRedirect("second?name=lee");
	```   
	<br>
	
	- location 방법    
	
	```java
	out.print("<script type='text/javascript'>");
	out.print("location.href='second';");
	out.print("</script>");
	```   

- 클라이언트를 거치지 않고 바로 서블릿으로 요청하는 방법   

	- dispatch 방법   
	
	```java
	---get 방식으로 데이터 전달---
	
	RequestDispatcher dispatch = request.getRequestDispatcher("second?name=lee");
	
	dispatch.forward(request, response);
	```
	
<br><br>

>### 바인딩   

<br>

**서블릿에서 대량의 데이터를 다른 서블릿 또는 JSP에 전송하기 위해 쓰이는 기능.**   

<br>

*클라이언트에 재요청을 보내는 것이 아니므로 dispatch 포워딩 방식을 이용한다.*   

```java
---MemberServlet 코드 일부---

MemberDAO dao = new MemberDAO();
List memberList = dao.listMembers();  ---> MemberDAO, VO 객체를 생성한다.

request.setAttribute("memberList", memberList);  --> request의 memberList 값으로 위에서 생성한 memberList 객체를 바인딩한다.

RequestDispatcher dispatch = request.getRequestDispatcher("viewMember");
dispatch.forward(request, response); ---> 바인딩한 request를 viewMember 서블릿으로 포워딩한다.

```

<br>

```java
---viewServlet 일부(viewMember서블릿)---

List membersList = (List) request.getAttribute("memberList");   ---> 바인딩해서 넘어온 request를 가져온다.

for (int i = 0; i < membersList.size(); i++) {  ---> VO 객체를 이용해 값을 지정
	MemberVO memberVO = (MemberVO) membersList.get(i);
	String id = memberVO.getId();
	String pwd = memberVO.getPwd();
	String name = memberVO.getName();
	String email = memberVO.getEmail();
	Date joinDate = memberVO.getJoinDate();
```


### **이러한 viewServlet 클래스가 웹 브라우저에서 화면 기능을 담당한다. 후에 jsp로 발전한다.**   

<br><br>

>### ServletContext   

<br>

**서블릿과 컨테이너의 연동과 서블릿끼리의 자원을 공유하는데 사용한다.**   

**컨테이너 실행 시 생성되고, 컨테이너 종료 시 소멸된다.**   

<br>

- 바인딩 기능   

```java
---바인딩해서 다른 서블릿으로 쏘는 코드---

ServletContext context = getServletContext();  --> servletcontext 객체를 가져온다.

List member = new ArrayList();
member.add("이순신");
member.add(30);

context.setAttribute("member", member);  --> context에 데이터를 바인딩한다.
```  

<br>

```java
---바인딩된 자원을 받는 서블릿---

ServletContext context = getServletContext();
List member = (ArrayList)context.getAttribute("member");  --> 바인딩된 데이터를 가져온다.

String name = (String)member.get(0);
int age = (Integer)member.get(1);
```

<br>

- 매개변수를 설정 기능 

```
---web.xml---
<context-param>
  <param-name>menu_member</param-name>
  <param-value>회원등록 회원조회 회원수정</param-value>
 </context-param>
 
 
 ---servlet---
 String menu_member = context.getInitParameter("menu_member");  ---> param-name에 등록된 변수를 사용할 수 있다.
```

<br>

- 파일 입출력 기능   

```
---입출력---
InputStream is = context.getResourceAsStream("/WEB-INF/bin/init.txt"); --> 미리 해당 경로에 작성한 파일의 값을 불러올 수 있다.
BufferedReader buffer = new BufferedReader(new InputStreamReader(is));
```
<br><br>

>### ServletConfig   

<br>

**각 Servlet객체에 대해 생성되고, 소멸한다.**   

**대표적인 기능으로 ServletContext의 객체를 가져오는 기능을 가지고 있다.**   

<br>
 
*WebServlet 어노테이션을 이용한 서블릿 설정*    

```
#servlet 파일 생성할 때, 다중 url mapping이 가능하며, 특정 매개변수를 작성할 수 있다.

@WebServlet(
  urlPatterns = { 
	"/sInit1", 
	"/sInit2"
 }, 
  initParams = { 
	@WebInitParam(name = "email", value = "admin@jweb.com"), 
	@WebInitParam(name = "tel", value = "010-1111-2222")
 })
 
String email = getInitParameter("email");
String tel = getInitParameter("tel");
```

<br><br>

>### load_on_startup   

<br>

**최초 요청에 대한 실행 시간을 줄이기 위한 기능**   

- 톰캣 컨테이너가 실행되면서 미리 서블릿을 실행한다.   

- 지정한 숫자가 0보다 크면 톰캣 컨테이너가 실행되면서 서블릿이 초기화된다. (지정한 숫자는 우선순위)   

<br>

**@WebServlet 어노테이션에 loadOnStartup 옵션을 추가해서 우선순위를 정할 수 있다.**   

```
@WebServlet(name = "loadConfig", urlPatterns = { "/loadConfig" }, loadOnStartup = 1)

---임의의 servlet 일부코드---

public class LoadAppConfig extends HttpServlet {
	
	private ServletContext context;  ---> 변수 context를 멤버 변수로 선언.
	
	public void init(ServletConfig config) throws ServletException {
		context = config.getServletContext();  --> init()메서드에서 ServletContext 객체를 얻는다.
```   

#### **톰캣 실행 시, web.xml의 변수를 읽어와서 미리 ServletContext에 바인딩된다.(최초 요청 시 기다리지 않고, 바로 출력 가능)**    


<br><br>

>### Cookie   

<br>

**클라이언트 pc에 저장해 놓고 필요할 때 여러 웹 페이지들이 굥유해서 사용할 수 있도록 매개역할을 하는 방법**   

- 정보가 클라이언트 pc에 저장   
- 저장 정보 용량에 제한이 있다.   
- 보안이 취약하다.   
- 도메인당 쿠키가 만들어진다.   

<br>

>#### persisten cookie   

<br>

**클라이언트에 파일로 정보를 저장하는 기능 (만료 시간을 조절 가능)**   

```java
---cookie 설정하는 servlet 일부---

#Cookie 객체 생성후 'cookieTest'라는 이름으로 한글정보를 인코딩해서 저장.
Cookie c = new Cookie("cookieTest", URLEncoder.encode("JSP프로그래밍입니다.","utf-8"));

c.setMaxAge(24*60*60); --> 유효기간 설정

response.addCookie(c); --> 생성된 쿠키를 브라우저로 전송.
```   

<br>

```java
---cookie를 사용하는 servlet 일부---

Cookie[] allValues=request.getCookies(); --> getCookies()메서드로 브라우저에게 쿠키 정보를 요청.

# 쿠키 배열을 쿠키 이름인 cookieTest검색해서 쿠키 값을 가져온다.
for(int i=0; i<allValues.length; i++) {
    if(allValues[i].getName().equals("cookieTest")) {
        out.println("<h2>Cookie 값 가져오기 : "+URLDecoder.decode(allValues[i].getValue(), "utf-8"));
     }
}
```   

<br><br>

>### Session   

<br>

**cookie와 비슷하게 웹 페이지들을 매개해 주는 방법이다.**   

**세션은 서버의 메모리에 생성되기 때문에, 보안이 요구되는 정보에 주로 이용한다.**    

<br>


*세션 실행 순서*
```
1. 브라우저로 사이트에 접속한다.

2. 서버는 접속한 브라우저에 대한 세션 객체를 생성한다.

3. 서버는 생성된 세션 id를 클라이언트 브라우저에 응답한다.

4. 브라우저는 서버로부터 받은 세션 id를 브라우저가 사용하는 메모리의 세션 쿠키에 저장한다.

5. 브라우저가 재접속하면 브라우저는 세션 쿠키에 저장된 세션 id를 서버에 전달한다.

6. 서버는 전손된 세션 id를 이용해 해당 세션에 접근하여 작업을 수행한다.
```   

<br>

*세션 정보 바인딩을 통한 로그인 정보 이용*   

```java
HttpSession session = request.getSession();  ---> httpsession으로 session 객체를 생성한다.(새로 받던지, 있었다면 원래 있던 세션을 받는다.)
String user_id = request.getParameter("user_id");
String user_pw = request.getParameter("user_pw");
if (session.isNew()) {
	if(user_id != null) {  --> 새로 생성된 세션인데 로그인 정보가 있을 때.
		session.setAttribute("user_id", user_id); --> session에 id를 묶어서 바인딩한다.
		out.println("<a href='login'>로그인 상태 확인 </a>");
	}else {
		out.print("<a href='login2.html'> 다시 로그인 하세요!!</a>");
		session.invalidate(); --> 로그인 정보가 없으므로 세션을 삭제한다.
	}
}else {
	user_id = (String) session.getAttribute("user_id");   ---> 재요청 시 세션에서 id를 가져와서 로그인 여부를 
	if (user_id != null && user_id.length() != 0) {
		out.print("안녕하세요 " + user_id + "님!!!");
	}else {
		out.print("<a href='login2.html'>다시 로그인 하세요 !!</a>");
		session.invalidate();
	}
}
```

<br>
<br>

>#### session을 이용한 로그인 예제    

<br>

**데이터베이스에 미리 들어있는 id, pwd를 이용해 로그인 상태를 세션으로 확인하는 예제이다.**   

<br>

```java
---LoginServlet 코드 일부---

String user_id = request.getParameter("user_id");
String user_pwd = request.getParameter("user_pwd");  --> 로그인창에서 전송된 id, pwd 

MemberVO memberVO = new MemberVO();
memberVO.setId(user_id);
memberVO.setPwd(user_pwd);  --> MemberVO 객체에 id, pwd 저장.

MemberDAO dao = new MemberDAO();
boolean result = dao.isExisted(memberVO);  --> MemberDAO의 isExisted로 존재하는지 확인.

.....

HttpSession session = request.getSession();
session.setAttribute("isLogon", true);
session.setAttribute("login.id", user_id);
session.setAttribute("login.pwd", user_pwd);   ---> 로그인을 성공하면,Logon, id,pwd를 세션에 바인딩한다.
```   
<br>

```java
---MemberDAO의 isExisted 메서드---

public boolean isExisted(MemberVO memberVO) {
	boolean result = false;  
	String id = memberVO.getId();
	String pwd = memberVO.getPwd();
	try {
		con = dataFactory.getConnection();
		String query = "select decode(count(*),1,'true','false') as result from t_member";
		query += " where id=? and pwd=?";   
		pstmt = con.prepareStatement(query);
		pstmt.setString(1, id);
		pstmt.setString(2, pwd);   
		ResultSet rs = pstmt.executeQuery();   --> MemberVO로 얻어온 id, pwd로 DB조사.
		rs.next();
		result = Boolean.parseBoolean(rs.getString("result"));  --> String형인 result를 Boolean형으로 변환 (존재하면 True)
		System.out.println("result=" + result);
	} .....
```

<br>

```java
---ShowMember 코드 일부---

isLogon = (Boolean)session.getAttribute("isLogon");
if(isLogon==true) {  --> 로그인 정보가 존재하면,

	id = (String)session.getAttribute("login.id");
	pwd = (String)session.getAttribute("login.pwd");   --> 세션에 바인딩되었던 id, pwd 정보
	out.print("<html><body>");
	out.print("아이디 : " + id +"<br>");
	out.print("비밀번호 : " + pwd + "<br>");
	out.print("</body></html>");
```



