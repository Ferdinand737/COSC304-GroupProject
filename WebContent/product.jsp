<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Ray's Grocery - Product Information</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp" %>

<%
String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";
Connection con = DriverManager.getConnection(url, uid, pw);
// Print out the ResultSet
//Statement stmt = con.createStatement();
// Get product name to search for
String id = request.getParameter("id");
// TODO: Retrieve and display info for the product
// String productId = request.getParameter("id");

String sql = "SELECT productId, productName, productPrice, productImageURL FROM product WHERE productId=?";
PreparedStatement stmt = con.prepareStatement(sql);
stmt.setInt(1, Integer.parseInt(id));
ResultSet rst = stmt.executeQuery();
rst.next();
out.println("<h2>"+rst.getString(2)+"</h2>");
// TODO: If there is a productImageURL, display using IMG tag
out.println("<img src=\""+rst.getString(4)+"\">");
out.println("<img src=\"displayImage.jsp?id="+rst.getInt(1)+"\">");

// TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
out.println("<table><tbody>");
out.println("<tr><th>Id</th><th>"+rst.getInt(1)+"</th></tr>");
out.println("<tr><th>Price</th><th>"+NumberFormat.getCurrencyInstance(Locale.CANADA).format(rst.getDouble(3))+"</th></tr>");
out.println("</table></tbody>");

// TODO: Add links to Add to Cart and Continue Shopping

String linkAdd = "addcart.jsp?id=" + rst.getInt(1) + "&name=" + rst.getString(2) + "&price=" + NumberFormat.getCurrencyInstance(Locale.CANADA).format(rst.getDouble(3));
out.println("<h3><a href=\"listprod.jsp\">Continue Shopping</a></h3>");
out.println("<h3><a href=\"" + linkAdd + "\">Add to Cart</a></h3>");
%>

</body>
</html>

