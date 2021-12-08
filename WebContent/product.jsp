<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Your Grocery - Product Information</title>
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
int pId = rst.getInt(1);
out.println("<h2>"+rst.getString(2)+"</h2>");
// TODO: If there is a productImageURL, display using IMG tag
out.println("<img src=\""+rst.getString(4)+"\">");
//out.println("<img src=\"displayImage.jsp?id="+rst.getInt(1)+"\">");

// TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
out.println("<table><tbody>");
out.println("<tr><th>Id</th><th>"+rst.getInt(1)+"</th></tr>");
out.println("<tr><th>Price</th><th>"+NumberFormat.getCurrencyInstance(Locale.CANADA).format(rst.getDouble(3))+"</th></tr>");
out.println("</table></tbody>");

// TODO: Add links to Add to Cart and Continue Shopping

String linkAdd = "addcart.jsp?id=" + rst.getInt(1) + "&name=" + rst.getString(2) + "&price=" + NumberFormat.getCurrencyInstance(Locale.CANADA).format(rst.getDouble(3));
out.println("<h3><a href=\"listprod.jsp\">Continue Shopping</a></h3>");
out.println("<h3><a href=\"" + linkAdd + "\">Add to Cart</a></h3>");

out.println("<h4>Reviews</h4>");
%>
<form method="get" action="product.jsp">
<h8>How Many Stars?(/10)</h8>
<input type="number" name="Rating" size="10">
<h8>Leave a Written Review</h8>
<input type="text" name="Review" size="100">
<input type="submit" value="Submit">
<%
out.print("<input type=\"hidden\" name=\"id\" size=\"0\" value=\""+pId+"\">");
String rating = request.getParameter("Rating");
String review = request.getParameter("Review");
if(review != null)
{
    String sqlInsert = "INSERT INTO review (reviewRating, reviewDate, customerId, productId, reviewComment) VALUES( ?, ?, ?, ?, ?);";
    stmt = con.prepareStatement(sqlInsert);
    stmt.setInt(1, Integer.parseInt(rating));
    stmt.setDate(2, java.sql.Date(utilDate.getTime()));
    stmt.setInt(3, 1);
    stmt.setInt(4, pId);
    stmt.setString(5, review);
    
    stmt.executeUpdate();

}
sql = "SELECT reviewRating, reviewComment, reviewDate FROM review WHERE productId=? ORDER BY reviewDate DESC";
stmt = con.prepareStatement(sql);
stmt.setInt(1, pId);
rst = stmt.executeQuery();
out.println("<table><tbody>");
out.println("<tr><th>Rating</th><th>Comment</th><th>Date Posted</th></tr>");
while (rst.next()) {
    out.println("<tr><th>"+rst.getInt(1)+"</th><th>"+rst.getString(2)+"</th>th>"+rst.getDate(3)+"</th></tr>");
}
out.println("</table></tbody>");
%>
</form>
</body>
</html>

