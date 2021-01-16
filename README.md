# Java_web (JSP, Servlet)   

>## 개발환경 설정   

<br>

```
기본환경 - Ubuntu20.04, Docker20.10.1
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

>### [2] 톰캣 설치   

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

>## 톰캣   

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







 



