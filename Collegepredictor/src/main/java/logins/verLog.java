package logins;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpFilter;
import javax.servlet.http.*;
import javax.servlet.*;
import java.sql.*;

public class verLog extends HttpFilter implements Filter {
  
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		
		
		HttpServletRequest httpreq = (HttpServletRequest) request;
		HttpServletResponse httpres = (HttpServletResponse) response;
		try {
			
		Class.forName("com.mysql.jdbc.Driver");  

		
		String gmail = httpreq.getParameter("gmail");
		String pass = httpreq.getParameter("pass");
		String name , phone ;
		int ID;
		
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/college_predictor" ,
			"root" ,
			"Mohan@9360");
		
		if(gmail==null || pass==null) httpres.sendRedirect("/Collegepredictor/college_project/logins/login.html");
		
		PreparedStatement smt = conn.prepareStatement("SELECT * FROM Users WHERE gmail=? and pass=?");
		
		smt.setString(1,gmail);
		smt.setString(2,pass);
		
		ResultSet rs = smt.executeQuery();
		boolean r = rs.next();
		if(r) { 
			
			name = rs.getString("fullname");
			phone = rs.getString("mobile");
			ID = rs.getInt("ID");
			
			request.setAttribute("name" , name);
			request.setAttribute("phone" , phone);
			request.setAttribute("gmail" , gmail);
			request.setAttribute("pass" , pass);
			
			smt = conn.prepareStatement("INSERT INTO Logins( ID , gmail , pass , currDate) VALUES(?,  ? , ? , NOW())");
			
			smt.setInt(1 , ID);
			smt.setString(2 ,gmail);
			smt.setString(3 , pass);
			
			smt.execute();
			
			chain.doFilter(request, response);
			
			
		}
		else httpres.sendRedirect("/Collegepredictor/college_project/logins/login.html");
		
		}
		
		catch (Exception e) {
			System.out.println(e);
		}
		
		
	}


}
