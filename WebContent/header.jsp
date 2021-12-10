<H1 align="center"><font face="cursive" color="#3399FF"><a href="index.jsp">MAF Grocery</a></font></H1>      
<hr>

<%
try {
String currentUser = (String) session.getAttribute("authenticatedUser");
if(currentUser != null){
out.println("Logged in as: " + currentUser );
}
else{
    out.println("No user logged in");
}
} catch (Exception e) {
}

%>