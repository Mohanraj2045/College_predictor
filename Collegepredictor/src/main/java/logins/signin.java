package logins;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;


public class signin extends HttpServlet{

	
	public void doPost(HttpServletRequest req , HttpServletResponse res) throws IOException , ServletException{
		
		String gmail = req.getParameter("gmail");
		String pass = req.getParameter("pass");
		String name =  req.getParameter("name");
		String phone =  req.getParameter("phone");
		PrintWriter out = res.getWriter();	
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			
			Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/college_predictor",
					"root",
					"Mohan@9360");
			
			conn.setAutoCommit(false);
			PreparedStatement smt = conn.prepareStatement("INSERT INTO Users(fullname , gmail , pass , mobile) VALUES(?,?,?,?)");
			
			smt.setString(1,name);
			smt.setString(2,gmail);
			smt.setString(3,pass);
			smt.setString(4,phone);
			
			smt.executeUpdate();
			
			conn.commit();
			
			HttpSession sc = req.getSession();
			sc.setAttribute("name" , name);
			sc.setAttribute("gmail" , gmail);
			sc.setAttribute("pass" , pass);
			sc.setAttribute("number" , phone);
			
			out.println("Welocome " +  name + pass + phone + gmail);
			res.sendRedirect("college_project/main-page/main.jsp");

			
		}
		catch(Exception e) {
			System.out.println(e);
		}
	}
}
