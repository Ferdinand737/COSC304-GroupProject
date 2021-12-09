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
	<label for="sort">Sort By:</label>
  	<select id="sort" name="sort">
    	<option value="productPrice">price</option>
    	<option value="AVG(reviewRating)">rating</option>
    	<!--<option value="quantity sold ASC">quantity sold</option> -->
		<option value="productPrice DESC">price Descending</option>
    	<option value="AVG(reviewRating) DESC">rating Descending</option>
    	<!--<option value="quantity sold DESC">quanitiy sold Descending</option> -->
  	</select>
	<input type="text" name="productName" size="50">
	<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>
<style>
table {
  border-collapse: collapse;
  width: 100%;
  border: 1px solid #ddd;
}

th, td {
  text-align: left;
  padding: 16px;
}
</style>
<% // Get product name to search for
String name = request.getParameter("productName");
String category = request.getParameter("category");
String sort = request.getParameter("sort");

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
out.println("<th>Rating</th>");
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
	if(sort == null)
	{
    	String str = "SELECT p.productId, productName, productPrice, categoryName, AVG(reviewRating) "
					+"FROM product AS p LEFT JOIN category AS c ON p.categoryId=c.categoryId "
					+"LEFT JOIN review AS r ON p.productId=r.productId GROUP BY p.productId, productName, productPrice, categoryName ORDER BY p.productId;";
    	stmt = con.prepareStatement(str);
	} else {
    	String str = "SELECT p.productId, productName, productPrice, categoryName, AVG(reviewRating) "
					+"FROM product AS p LEFT JOIN category AS c ON p.categoryId=c.categoryId "
					+"LEFT JOIN review AS r ON p.productId=r.productId GROUP BY p.productId, productName, productPrice, categoryName ORDER BY productPrice;";
    	stmt = con.prepareStatement(str);
		//stmt.setString(1, sort);		
	}

} else {
    String str = "SELECT p.productId, productName, productPrice, categoryName, AVG(reviewRating) "
				+"FROM product AS p LEFT JOIN category AS c ON p.categoryId=c.categoryId "
				+"LEFT JOIN review AS r ON p.productId=r.productId WHERE productName LIKE ? GROUP BY p.productId, productName, productPrice, categoryName ORDER BY "+sort+";";
    stmt = con.prepareStatement(str);
    stmt.setString(1, "%"+name+"%");
}
    
ResultSet rst = stmt.executeQuery();

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
		out.println("<td>"+rst.getDouble(5)+"</td>");
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