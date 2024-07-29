package college;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import org.json.simple.JSONObject;
import org.json.simple.JSONArray;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class Reciveclg extends HttpServlet {

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        BufferedReader reader = req.getReader();
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        String jsonString = sb.toString();

        JSONParser parser = new JSONParser();
        JSONArray jclgs = null;

        try {
            if (jsonString != null) {
                jclgs = (JSONArray) parser.parse(jsonString);
            }

            System.out.println(jclgs.size());
            // Process the colleges data here
            // Example: JSONObject colleges = (JSONObject) jclgs.get("Colleges");

        } catch (ParseException e) {
            System.out.println(e);
        }

        // Set response content type
        System.out.println("hello");
        
        HttpSession sc = req.getSession();
        sc.setAttribute("name", "Success");
        res.sendRedirect("college_project/main-page/main.jsp");
    }

    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        // Handle GET requests if needed
    }
}
	