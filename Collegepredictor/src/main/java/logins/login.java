package logins;
import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.io.OutputStream;
import java.io.*;

public class login extends HttpServlet {

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        PrintWriter out = res.getWriter();
        String gmail = req.getParameter("gmail");
        String pass = req.getParameter("pass");
        String name = (String) req.getAttribute("name");
        String phone = (String) req.getAttribute("phone");

        HttpSession sc = req.getSession();
        sc.setAttribute("name", name);
        sc.setAttribute("gmail", gmail);
        sc.setAttribute("phone", phone);
        sc.setAttribute("pass", pass);

        out.println("Hello " + name + "  phone " + phone);


        // Redirect to the main page
        res.sendRedirect("college_project/main-page/main.jsp");
    }

}