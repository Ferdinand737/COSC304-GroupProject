<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
%>

<%

// TODO: Print Customer information
getConnection();
String sql = "SELECT * FROM customer WHERE userid=?";
PreparedStatement stmt = con.prepareStatement(sql);
stmt.setString(1, userName);
ResultSet rst = stmt.executeQuery();
rst.next();
out.print("<h2 align=\"center\"> Customer Name </h2>");
out.print("<p align=\"center\">" + rst.getString(2) + " " + rst.getString(3));
out.print("<p align=\"center\"><a href=\"password.jsp\">Change Password</a> </h2>");
out.print("<h2 align=\"center\">Customer Address </h2>");
out.print("<p align=\"center\">" + rst.getString(6) + " " + rst.getString(7) + " " + rst.getString(8) + " " + rst.getString(9) + " " + rst.getString(10));
out.print("<p align=\"center\"><a href=\"address.jsp\">Change Address</a> </h2>");
out.print("<h2 align=\"center\"> Customer Orders </h2>");

String sql2 = "SELECT * FROM ordersummary WHERE customerId=?";
PreparedStatement stmt2 = con.prepareStatement(sql2);
stmt2.setInt(1, rst.getInt(1));
ResultSet rst2 = stmt2.executeQuery();

out.print("<table style=\"border:1px solid black;margin-left:auto;margin-right:auto;\">");
out.print("<tr>");
out.print("<th>Order Id</th>");
out.print("<th>Order Date</th>");
out.print("<th>Total Amount</th>");
out.print("</tr>");

while(rst2.next()){
	out.print("<tr>");
	out.print("<td>" + rst2.getInt(1) + "</td>");
	out.print("<td>" + rst2.getString(2) + "</td>");
	out.print("<td align=\"right\">" + NumberFormat.getCurrencyInstance(Locale.CANADA).format(rst2.getDouble(3)) + "</td>");
	out.print("</tr>");
}



out.print("</table>");

// Make sure to close connection
closeConnection();
%>

</body>
</html>

