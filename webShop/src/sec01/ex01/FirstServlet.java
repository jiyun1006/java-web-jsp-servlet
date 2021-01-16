package sec01.ex01;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class FirstServlet extends HttpServlet{
//	HttpServlet 클래스의 메서드를 이 파일에 특화시키기 위해 어노테이션을 사용한다.
	@Override
		public void init() throws ServletException{
			System.out.println("init 메서드 호출");
		}
	
	@Override
		protected void doGet(HttpServletRequest req, HttpServletResponse resp)
		throws ServletException, IOException{
		System.out.println("doGet 메서드 호출");
	}
		
	
	@Override
		public void destroy() {
		System.out.println("destroy 메서드 호출");
	}
	

}
