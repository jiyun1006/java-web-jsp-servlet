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

>## 추가 설정 및 공부 내용   

<br>

## <a href = "https://github.com/jiyun1006/java_web-jsp-servlet/blob/main/tomcat.md" />**tomcat**         

<br>

## <a href = "https://github.com/jiyun1006/java_web-jsp-servlet/blob/main/servlet.md" />**servlet**       

<br>

## <a href = "https://github.com/jiyun1006/java_web-jsp-servlet/blob/main/jsp.md" />**jsp**   

<br>

## <a href = "https://github.com/jiyun1006/java_web-jsp-servlet/blob/main/MVC2.md" />**모델 2(MVC)**   

<br>

## <a href=""/>**Spring**   


<br><br>

>## 실습 예제   

<br>

## <a href = "https://github.com/jiyun1006/java_web-jsp-servlet/blob/main/post.md"/>**게시판 기능**   

