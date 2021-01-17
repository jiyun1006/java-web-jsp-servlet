# Java_web (JSP, Servlet)   

>## 개발환경 설정   

<br>

```
기본환경 - Ubuntu20.04, Docker20.10.1

build path 설정 - servlet-api.jar, ojdbc8.jar
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
	 String id = rs.getString("id");           ---> 조회한 레코드의 칼럼값을 받고, MemberVO 객체에 속성 설정.
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

 



