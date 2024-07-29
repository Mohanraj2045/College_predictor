<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%@ page import="org.json.simple.parser.ParseException" %>
<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Main-Page</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Orbitron">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Cinzel">
    <link rel="stylesheet" href="style.css">
</head>
<body>

    <div id="header">
        <h1>College Predictor&#128301;</h1>
        <a id="wel" href="../welcome.html">Welcome</a>
        <a id="about" href="../aboutus/about.html">About-Us</a>
        <a id="Topclgs" href = "https://engineering.careers360.com/articles/top-engineering-colleges-under-anna-university">Top-Colleges</a> 
        <div id="userdisplay">
            <img id="userimg" src="../images/icons8-userid-30.png" height="30px" width="30px">
            <a id="username">${name}</a>
        </div>
    </div>

    <div class="header-slider">
        <a href="#" class="control-prev"> &#129144;</a>
        <a href="#" class="control-next"> &#129146;</a>
        <ul>
            <img src="images/study2.jpg" class="header-tag" height="400px" width="1520px">
            <img src="images/study4.jpg" class="header-tag" height="400px" width="1520px%">
            <img src="images/study3.jpg" class="header-tag" height="400px" width="1520px">
        </ul>
    </div>

    <div id="forminterface">
        <form id="predictForm" action="http://localhost:3000/Predictsave" method="post">
            <h1>Enter your marks</h1><br>
            <label>Maths</label><input  type="number" name="Math" min = "35" max = "100" required id="Math"><br>
            <label>Physics</label><input type="number" name="Phy"  min = "35" max = "100" required><br>
            <label>Chemistry</label><input type="number" name="Che" min = "35" max = "100" required><br>
            <label>Community</label><input type="text" name="Com" required autocapitalize="on" list = "availCom"><br>
            <label>BranchCode</label><input type="text" name="BranchCode" required autocapitalize="on"  list = "availBra"><br>

            <!-- Hidden inputs for additional values -->
            <input type="hidden" id="Userid" name="User" value="${gmail}">
            <input type="hidden" id="Passid" name="Pass" value="${pass}">

            <input type="submit" name="submit" id="submit">
        </form>
        
        <!-- Recommending the availabe colleges and communities -->
        <datalist id = "availCom">
        <option  value="BC"> <option  value="BCM"> <option  value="MBC"> <option  value="MBCDNC"> <option  value="MBCV"> <option  value="OC"> <option  value="SC"> <option  value="SCA"> <option  value="ST"> 
        </datalist>
        
        <datalist id  = "availBra">
        <option  value="AD"> <option  value="AE"> <option  value="AG"> <option  value="AL"> <option  value="AM"> <option  value="AO"> <option  value="AP"> <option  value="AS"> <option  value="AT"> <option  value="AU"> <option  value="BM"> <option  value="BS"> <option  value="BT"> <option  value="BY"> <option  value="CB"> <option  value="CC"> <option  value="CD"> <option  value="CE"> <option  value="CF"> <option  value="CH"> <option  value="CJ"> <option  value="CL"> <option  value="CM"> <option  value="CN"> <option  value="CO"> <option  value="CR"> <option  value="CS"> <option  value="CT"> <option  value="CW"> <option  value="CY"> <option  value="EC"> <option  value="EE"> <option  value="EI"> <option  value="EM"> <option  value="ES"> <option  value="EY"> <option  value="FD"> <option  value="FS"> <option  value="FT"> <option  value="FY"> <option  value="GI"> <option  value="IB"> <option  value="IC"> <option  value="IE"> <option  value="IM"> <option  value="IS"> <option  value="IT"> <option  value="IY"> <option  value="LE"> <option  value="MA"> <option  value="MC"> <option  value="MD"> <option  value="ME"> <option  value="MF"> <option  value="MG"> <option  value="MI"> <option  value="MN"> <option  value="MR"> <option  value="MS"> <option  value="MT"> <option  value="MY"> <option  value="MZ"> <option  value="PA"> <option  value="PC"> <option  value="PH"> <option  value="PM"> <option  value="PN"> <option  value="PP"> <option  value="PR"> <option  value="PS"> <option  value="PT"> <option  value="RA"> <option  value="RM"> <option  value="RP"> <option  value="SC"> <option  value="SE"> <option  value="TS"> <option  value="TX"> <option  value="XC"> <option  value="XM"> 
        </datalist>
    </div>

    <div id="collegeList">

    <%  
		Class.forName("com.mysql.jdbc.Driver");
    
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/college_predictor","root",
				"Mohan@9360");
		
				
		out.print("<h1 id = clgshead >Recommended colleges</h1>");    	
        out.print("<div id  = headings> <p id = clgnamehead>College Name</p><p id = clgcodehead>CollegeCode</p></div>");

    	JSONParser parser = new JSONParser();
    	String col = request.getParameter("colleges");
    	System.out.println(col);
    	
    	if(col != null){

    		col = java.net.URLDecoder.decode(col, "UTF-8");
    		JSONArray colleges = (JSONArray) parser.parse(col);
    		if(colleges.size()!=0){
    			
    			StringBuffer Bstatement = new StringBuffer("SELECT * FROM Colleges WHERE clgCode in (");
    			
    			Bstatement.append(""+colleges.get(0));
    			for(int i = 1 ; i<colleges.size() ; i++){
    				Bstatement.append(","+colleges.get(i));
    			}
    			Bstatement.append(")");
    			
    			String Statement = Bstatement.toString();
    			System.out.println(Statement);
    			
    			Statement smt = conn.createStatement();
    			ResultSet rs = smt.executeQuery(Statement);
    			
    			while(rs.next()){ 
    			
    			System.out.println(rs.getString("college") + rs.getInt("clgCode"));
    			
    			String clgname = rs.getString("college");
                int clgcode =  rs.getInt("clgCode");	

        
    			out.print(" <div> <p class = clgname>"+ clgname+"</p><p class = clgcode>"+clgcode+"</p></div><br>");
    			}
    		}
    		else {
        		
        		out.print("<p id = noclgs>No colleges Found</h1>");    	
        		}
    	}
    	else {
    		
    		out.print("<p id = noclgs>No colleges Found</h1>");    	
    		}
    	
%>

    </div>
    
     <section class="footer">
     <div class="footer-row">
       <div class="footer-col">
         <h4>Info</h4>
         <ul class="links">
           <li><a href="#">About Us</a></li>
           <li><a href="#">Compressions</a></li>
           <li><a href="#">Customers</a></li>
           <li><a href="#">Service</a></li>
           <li><a href="#">Collection</a></li>
         </ul>
       </div>
       <div class="footer-col">
         <h4>Explore</h4>
         <ul class="links">
           <li><a href="#">Free Designs</a></li>
           <li><a href="#">Latest Designs</a></li>
           <li><a href="#">Themes</a></li>
           <li><a href="#">Popular Designs</a></li>
           <li><a href="#">Art Skills</a></li>
           <li><a href="#">New Uploads</a></li>
         </ul>
       </div>
       <div class="footer-col">
         <h4>Legal</h4>
         <ul class="links">
           <li><a href="#">Customer Agreement</a></li>
           <li><a href="#">Privacy Policy</a></li>
           <li><a href="#">GDPR</a></li>
           <li><a href="#">Security</a></li>
           <li><a href="#">Testimonials</a></li>
           <li><a href="#">Media Kit</a></li>
         </ul>
       </div>
       <div class="footer-col">
         <h4>Newsletter</h4>
         <p>
           Subscribe to our newsletter for a weekly dose
           of news, updates, helpful tips, and
           exclusive offers.
         </p>
         <form action="#">
           <input type="text" placeholder="Your email" required>
           <button type="submit">SUBSCRIBE</button>
         </form>
         <div class="icons">
           <i class="fa-brands fa-facebook-f"></i>
           <i class="fa-brands fa-twitter"></i>
           <i class="fa-brands fa-linkedin"></i>
           <i class="fa-brands fa-github"></i>
         </div>
       </div>
     </div>
   </section>
    

    <script type="text/javascript" src="script.js"></script>
</body>
</html>
