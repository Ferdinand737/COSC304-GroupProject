<%@ page import="java.sql.*" %>
<%@ page import="java.util.Scanner" %>
<%@ page import="java.io.File" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Load Data</title>
</head>
<body>
<h1><a href="index.jsp">MAF Grocery</a></h1>
<%
 
String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";

out.print("<h1>Connecting to database.</h1><br><br>");

getConnection();
        
String fileName = "/usr/local/tomcat/webapps/shop/Product_sql.ddl";

try
{
    Statement stmt = con.createStatement();
    
    Scanner scanner = new Scanner(new File(fileName));
    scanner.useDelimiter(";");
    while (scanner.hasNext())
    {
        String command = scanner.next();
        if (command.trim().equals(""))
            continue;
        try
        {
            stmt.execute(command);
        }
        catch (Exception e)
        {	
            out.print(e);
        }
    }	 
    scanner.close();
    
    out.print("<br><br><h1>Database loaded.</h1>");
}
catch (Exception e)
{
    out.print(e);
}  
%>
</body>
</html> 
