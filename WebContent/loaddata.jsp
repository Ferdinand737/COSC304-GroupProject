<%@ page import="java.sql.*" %>
<%@ page import="java.util.Scanner" %>
<%@ page import="java.io.File" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Your Shopping Cart</title>
</head>
<body>

<%
String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";

out.print("<h1>Connecting to database.</h1><br><br>");

Connection con = DriverManager.getConnection(url, uid, pw);
        
String fileName = "/usr/local/tomcat/webapps/shop/orderdb_sql.ddl";
/*
Write a Java or Python program that prints out in decreasing order the 5 
largest loans at each bank. You must show a bank even if it has no loans. 
Use the schema below:*/

try
{
    // Create statement
    Statement stmt = con.createStatement();
    
    Scanner scanner = new Scanner(new File(fileName));
    // Read commands separated by ;
    scanner.useDelimiter(";");
    while (scanner.hasNext())
    {
        String command = scanner.next();
        if (command.trim().equals(""))
            continue;
        // out.print(command);        // Uncomment if want to see commands executed
        try
        {
            stmt.execute(command);
        }
        catch (Exception e)
        {	// Keep running on exception.  This is mostly for DROP TABLE if table does not exist.
            out.print(e);
        }
    }	 
    scanner.close();
    
    out.print("<br><br><h1>Database loaded.</h1>");
    String sql =  "SELECT O.bankName, L.amount FROM Bank AS O LEFT JOIN Loan AS L ON O.bankName=L.bankName";
    PreparedStatement pstmt = con.prepareStatement(sql);
    ResultSet bankRst = pstmt.executeQuery();
    while(bankRst.next()) {
        String bName = bankRst.getString("bankName");
        out.println("<th>Bank: " + bName + " Loans: " +"" + "Total: " + "</th>");
        
        out.println("<th>Top 5 Loans:</th>");
        int count = 0;
        while(bankRst.next() && bName == bankRst.getString("bankName")) {
            out.print(bankRst.getDouble("<th>amount") + " </th>");
        }
    }

    out.print("hello");
}
catch (Exception e)
{
    out.print(e);
}  
%>
</body>
</html> 
