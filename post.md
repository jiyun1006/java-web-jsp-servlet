# 게시판 구현 해보기.   

*****   

>## 게시판 글 목록 구현   
>이전과는 다르게 sql 세부 기능은 DAO에 구현하도록 하고, service 단위의 기능들은 다른 클래스를 작성한다.   

```
controller --> service클래스 --> DAO
```   

<br>


**request 요청명을 가지고, 기능 구분**   

*전체 글 조회 코드*   

```java
else if (action.equals("/listArticles.do")) {   ---> 요청명을 분기로 기능을 나눈다.

    articlesList = boardService.listArticles();   ---> service클래스에서 list가져오는 메서드 실행.
    
    request.setAttribute("articlesList", articlesList);  ---> request에 바인딩.
    nextPage = "/board01/listArticles.jsp";
```   

*service클래스의 listArticles 메서드*   
```java
public List<ArticleVO> listArticles()
{
  List<ArticleVO> articlesList = boardDAO.selectAllArticles();    ---> DAO의 메서드로 sql query문을 실행한다.   
  return articlesList;
}
  
  
<*DAO클래스의 selectAllArticles 메서드의 sql 문*>

conn = dataFactory.getConnection();		
    String query = "select level, articleNO, parentNO, title, content, id, writeDate"
        + " from t_board" + " start with parentNO=0"+ " connect by prior articleNO=parentNO"
        + " order siblings by articleNO desc";   ---> 계층형 질의문으로, 값을 가져온다.
          
...[생략]...
```

<br><br>


>## 글쓰기 및 파일 업로드   
>tomcat 컨테이너 내부에 파일 업로드 장소를 만들고, 파일 이름마다 구분되게 끔 폴더 생성.    


<br>


*게시글 작성 코드*   
```java
else if (action.equals("/articleForm.do")) {   ---> 글 작성 요청
    nextPage = "/board01/articleForm.jsp";

  } else if (action.equals("/addArticle.do")) {   ---> 글 작성 왼료한 요청.
    int articleNO = 0;   
    Map<String, String> articleMap = upload(request, response);   ---> 파일 업로드 기능을 위한 upload 메서드
    
    
    <# upload메서드로 가져온 파일 정보#>
    
    String title = articleMap.get("title");
    String content = articleMap.get("content");
    String imageFileName = articleMap.get("imageFileName");
    articleVO.setParentNO(0);
    articleVO.setId("hong");
    articleVO.setTitle(title);
    articleVO.setContent(content);
    articleVO.setImageFileName(imageFileName);
    articleNO = boardService.addArticle(articleVO);  ---> 파일 이름마다 저장 폴더를 구분하기 위해 번호 저장.

    if (imageFileName != null && imageFileName.length() != 0) {
      File srcFile = new File(ARTICLE_IMAGE_REPO + "/" + "temp" + "/" + imageFileName); 
      File destDir = new File(ARTICLE_IMAGE_REPO + "/" + articleNO);
      destDir.mkdirs();
      FileUtils.moveFileToDirectory(srcFile, destDir, true);   ---> temp 폴더에 임시로 만든 업로드 파일을 이름에 맞는 폴더로 이동.
    }
```

*upload 메서드*   
```java

Map<String, String> articleMap = new HashMap<String, String>(); 
String encoding = "utf-8";

File currentDirPath = new File(ARTICLE_IMAGE_REPO);  ---> 파일 저장 폴더에 대해 파일 객체 생성.


...[생략]...


try {
  List items = upload.parseRequest(request);
  for (int i = 0; i < items.size(); i++) {
    FileItem fileItem = (FileItem) items.get(i);
    if (fileItem.isFormField()) { // form 일 때,
      System.out.println(fileItem.getFieldName() + "=" + fileItem.getString(encoding));
      articleMap.put(fileItem.getFieldName(), fileItem.getString(encoding));
    } else { // 파일일 때,
      System.out.println("파라미터 이름: " + fileItem.getFieldName());
      System.out.println("파일이름: " + fileItem.getName());
      System.out.println("파일크기: " + fileItem.getSize() + "bytes");

      if (fileItem.getSize() > 0) {
        int idx = fileItem.getName().lastIndexOf("/");  ---> 파일 이름에서 해당 인자 찾기.
        System.out.println(idx);
        if (idx == -1) {
          idx = fileItem.getName().lastIndexOf("/");
        }

        String fileName = fileItem.getName().substring(idx + 1);
        System.out.println("파일명:" + fileName);
        articleMap.put(fileItem.getFieldName(), fileName);  //익스플로러에서 업로드 파일의 경로 제거 후 map에 파일명 저장
        File uploadFile = new File(currentDirPath + "\\temp\\" + fileName);
        fileItem.write(uploadFile);
      }
      
...[생략]...
```

<br><br>

>## 글 상세페이지   
>작성한 게시물을 보는 상세페이지 기능을 만든다.    
>업로드할 때, 저장되었던 파일을 해당 폴더에서 꺼내와서 상세페이지에 불러낸다.      

<br>

- 업로드 된 파일을 불러오는 기능을 하는 servlet   

```java
# 이미지 파일 이름과 번호를 가져온다.
String imageFileName = (String) request.getParameter("imageFileName");
String articleNO = request.getParameter("articleNO");

OutputStream out = response.getOutputStream();

# path 설정을 통해 upload 당시 저장된 폴더 위치를 저장한다.
String path = ARTICLE_IMAGE_REPO + "/" + articleNO + "/" + imageFileName;
File imageFile = new File(path);


# 이미지 정보를 내려받는 데 필요한 response에 헤더 정보를 설정.
response.setHeader("Cache-Control", "no-cache");
response.addHeader("Content-disposition", "attachment;fileName="+ imageFileName);

# 버퍼를 이용해서 8kb씩 전송한다.
FileInputStream in = new FileInputStream(imageFile);
    byte[] buffer = new byte[1024*8];
    while(true) {
        int count = in.read(buffer);
        if (count == -1)
            break;
        out.write(buffer, 0, count);
    }
```   

- 상세페이지 jsp    

```java
<c:if test="${not empty article.imageFileName && article.imageFileName!='null' }">
    <tr>
        <td width="20%" align="center" bgcolor="#FF9933" rowspan="2">이미지</td>
        <td>
        # input 을 hidden 타입으로 주고, 실제 이미지파일 이름을 저장한다.
            <input type="hidden" name="originalFileName" value="${article.imageFileName }" />
            
        # img 태그에서 download.do 에 변수를 주어 servlet으로 전송한다.
            <img src="${contextPath}/download.do?imageFileName=${article.imageFileName}&articleNO=${article.articleNO }" id="preview" width="10%"/>
            
...[생략]...  
```

<br><br>

>## 글 수정, 삭제   
>게시글 상세 페이지에서 수정 기능과 삭제 기능을 설정한다. (feat. jquery)   
>수정 버튼을 누르면, 기존의 버튼은 사라지게 하고, display : none 이었던 버튼들을 나타나게 한다.   


<br>

- 글 수정 기능   

```java
# articleVO를 설정해서 modArticle 메서드 변수로 넣어준다.

articleVO.setParentNO(0);
articleVO.setId("hong");
articleVO.setTitle(title);
articleVO.setContent(content);
articleVO.setImageFileName(imageFileName);
boardService.modArticle(articleVO);   

# 수정을 하게 되면, 업로드 파일이 저장되있던 옛 폴더는 삭제하고 새로운 폴더를 만든다.

if (imageFileName != null && imageFileName.length() != 0) {
    String originalFileName = articleMap.get("originalFileName");
    File srcFile = new File(ARTICLE_IMAGE_REPO + "/" + "temp" + "/" + imageFileName);
    File destDir = new File(ARTICLE_IMAGE_REPO + "/" + articleNO);
    destDir.mkdir();
    FileUtils.moveFileToDirectory(srcFile, destDir, true);
    File oldFile = new File(ARTICLE_IMAGE_REPO + "/" + articleNO + "/" + originalFileName);
    oldFile.delete();
}
```    

*버튼 jquery*   
```javascript
function fn_enable(obj){
    document.getElementById("tr_btn_modify").style.display = "block";  --> 나타나야 할 태그
    document.getElementById("tr_btn").style.display = "none";  --> 사라져야 할 태그
    }

# tr_btn_modify를 id 값으로 가지는 태그를 나타나게 한다.

<tr id="tr_btn_modify">  ---> css에 display : none 을 준다.
    <td colspan="2" align="center">
        <input type=button value="수정반영하기" onClick="fn_modify_article(frmArticle)"> 
        <input type=button value="취소" onClick="backToArticle(frmArticle)">
    </td>
</tr>
```

<br>

- 글 삭제 기능   

```java
# articleNO를 받아와서 삭제할 글 번호를 설정한다.

int articleNO = Integer.parseInt(request.getParameter("articleNO"));
List<Integer> articleNOList = boardService.removeArticle(articleNO);


# 부모글과 자식글에 해당하는 업로드 파일 폴더를 다 지운다.

for (int _articleNO : articleNOList) {
    File imgDir = new File(ARTICLE_IMAGE_REPO + "/" + _articleNO);
    if (imgDir.exists()) {
        FileUtils.deleteDirectory(imgDir);
    }
}
```   





