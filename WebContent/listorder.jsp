<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>MAF Grocery Order List</title>
</head>
<body>

<h1>Order List</h1>

<table border = "1">

<tbody>

<tr>
	<th>Order Id</th>
	<th>Order Date</th>
	<th>Customer Id</th>
	<th>Customer Name</th>
	<th>Total Amount</th>
</tr>	

<%

try
{	
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";
getConnection();
Statement stmt = con.createStatement();
ResultSet rst = stmt.executeQuery("SELECT * FROM ordersummary");
while (rst.next()){

	Statement stmt2 = con.createStatement();
	ResultSet rst2 = stmt2.executeQuery("SELECT customerId, firstName, lastName FROM customer WHERE customerId = " + rst.getInt(9));
	rst2.next();
	String customerName = rst2.getString(2) + " " + rst2.getString(3);
	out.println("<tr><td>" + rst.getInt(1) + "</td><td>" + rst.getString(2) + "</td><td>" + rst.getInt(9) + "</td><td>" + customerName + "</td><td>" + NumberFormat.getCurrencyInstance(Locale.CANADA).format(rst.getDouble(3)) + "</td></tr>");

	Statement stmt3 = con.createStatement();
	ResultSet rst3 = stmt3.executeQuery("SELECT productId, quantity, price FROM orderproduct WHERE orderId = " + rst.getInt(1));
	out.println("<tr align = \"right\">");
	out.println("<td colspan = \"5\">");
	out.println("<table border = \"1\">");
	out.println("<tbody>");
	out.println("<tr><th>Product Id</th><th>Quantity</th><th>Price</th></tr>");
	while(rst3.next()){

		out.println("<tr><td>" + rst3.getInt(1) + "</td><td>" + rst3.getInt(2) + "</td><td>" +  NumberFormat.getCurrencyInstance(Locale.CANADA).format(rst3.getDouble(3)) + "</td></tr>");

	}
	out.println("</tbody>");
	out.println("</table>");
	out.println("</td>");
	out.println("</tr>");

}
closeConnection();
%>
</tbody>
</table>
</body>
</html>

