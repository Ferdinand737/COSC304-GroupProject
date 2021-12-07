<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery</title>
</head>
<body>
<%@ include file="header.jsp" %>
<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>

<% // Get product name to search for
String name = request.getParameter("productName");
String category = request.getParameter("category");		
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!
out.println("<h2>All Products</h2>");
out.println("<table class=\"table\" border=\"1\">");
out.println("<tbody>");
out.println("<tr>");
out.println("<th class=\"col-md-1\"></th>");
out.println("<th>Product Name</th>");
out.println("<th>Category</th>");
out.println("<th>Price</th>");
out.println("</tr>");

// Make the connection
String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";
Connection con = DriverManager.getConnection(url, uid, pw);
// Print out the ResultSet
PreparedStatement stmt;
if(name == null){
    String str = "SELECT productId, productName, productPrice, categoryName FROM product AS p LEFT JOIN category AS c ON p.categoryId=c.categoryId";
    stmt = con.prepareStatement(str);
} else {
    String str = "SELECT productId, productName, productPrice, categoryName FROM product AS p LEFT JOIN category AS c ON p.categoryId=c.categoryId WHERE productName LIKE ?";
    stmt = con.prepareStatement(str);
    stmt.setString(1, "%"+name+"%");
}
    
ResultSet rst = stmt.executeQuery();

//Statement stmt = con.createStatement();
//ResultSet rst = stmt.executeQuery("SELECT productId, productName, productPrice, categoryName FROM product AS p LEFT JOIN category AS c ON p.categoryId=c.categoryId");
// For each product create a link of the form
while(rst.next()){
	if((category == null) || category.equals(rst.getString(4))) {
		out.println("<tr>");
		String linkAdd = "addcart.jsp?id=" + rst.getInt(1) + "&name=" + rst.getString(2) + "&price=" + NumberFormat.getCurrencyInstance(Locale.CANADA).format(rst.getDouble(3));
		String linkProd = "product.jsp?id=" + rst.getInt(1);
		String linkCategory = "listprod.jsp?category=" + rst.getString(4);
		out.println("<td class=\"col-md-1\"><a href=\"" + linkAdd + "\">Add to Cart</a></td>");
		out.println("<td><a href=\"" + linkProd + "\">" +rst.getString(2) + "</td>");
		out.println("<td><a href=\"" + linkCategory + "\">"+rst.getString(4)+"</td>");
		out.println("<td>" + NumberFormat.getCurrencyInstance(Locale.CANADA).format(rst.getDouble(3)) + "</td>");
		out.println("</tr>");
	}
}
// addcart.jsp?id=productId&name=productName&price=productPrice
// Close connection

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);	// Prints $5.00
out.println("</tbody>");
out.println("</table");
%>

</body>
</html>