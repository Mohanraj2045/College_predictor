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
import java.sql.*;




public class verSign extends HttpFilter implements Filter {
       
    
  
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
			throws IOException, ServletException {
		
		try {
		Class.forName("com.mysql.jdbc.Driver");
		HttpServletRequest httpreq = (HttpServletRequest) request;
		HttpServletResponse httpres = (HttpServletResponse) response;
		
		// Making connection
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/college_predictor",
				"root",
				"Mohan@9360");
		
				
		String email = httpreq.getParameter("gmail");
		String phone = httpreq.getParameter("phone");
		String pass = httpreq.getParameter("pass");
		String name = httpreq.getParameter("name");
		
		// Check any of the values are null and if null backto the singin page
		if(email == null || phone == null || pass == null || name == null) 
			httpres.sendRedirect("/Collegepredictor/college_project/logins/signin.html");
		
		
		// If any of the valus are smaller than desired size back to siignin page
		else if(email.length() < 10 || phone.length() < 10 || pass.length() < 8 || name.length() < 3)
			httpres.sendRedirect("/Collegepredictor/college_project/logins/signin.html");
		
		// If gmail alread in registered go back to the signin page
		else {
			PreparedStatement smt = conn.prepareStatement("SELECT * from Users WHERE gmail = ?");
			smt.setString(1 , email);
			ResultSet rs = smt.executeQuery();
			
			if(rs.next()) httpres.sendRedirect("/Collegepredictor/college_project/logins/signin.html");

			
		}

		chain.doFilter(request, response);
		}
		catch (Exception e) {
			System.out.println(e);
		}
	}



}