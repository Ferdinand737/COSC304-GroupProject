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
getConnection();
String id = request.getParameter("id");
String sql = "SELECT productId, productName, productPrice, productImageURL, productDesc FROM product WHERE productId=?";
PreparedStatement stmt = con.prepareStatement(sql);
stmt.setInt(1, Integer.parseInt(id));
ResultSet rst = stmt.executeQuery();
rst.next();
int pId = rst.getInt(1);
out.println("<h2>"+rst.getString(2)+"</h2>");
out.println("<img src=\""+rst.getString(4)+"\" width=\"200\" height=\"400\">");
out.println("\n"+"<EM>"+rst.getString(5)+"</EM>");
out.println("<table><tbody>");
out.println("<tr><th>Id</th><th>"+rst.getInt(1)+"</th></tr>");
out.println("<tr><th>Price</th><th>"+NumberFormat.getCurrencyInstance(Locale.CANADA).format(rst.getDouble(3))+"</th></tr>");
out.println("</table></tbody>");
String user = (String)session.getAttribute("authenticatedUser");
String linkAdd = "addcart.jsp?id=" + rst.getInt(1) + "&name=" + rst.getString(2) + "&price=" + NumberFormat.getCurrencyInstance(Locale.CANADA).format(rst.getDouble(3));
out.println("<h3><a href=\"listprod.jsp\">Continue Shopping</a></h3>");
out.println("<h3><a href=\"" + linkAdd + "\">Add to Cart</a></h3>");
int cId;
if (user != null) {
    String strsql = "SELECT customerId FROM customer WHERE userid=\'"+user+"\';";
    stmt = con.prepareStatement(strsql);
    rst = stmt.executeQuery();
    rst.next();
    cId = rst.getInt(1);
    stmt = con.prepareStatement("SELECT COUNT(*) FROM review WHERE productId="+pId+" AND customerId="+cId+";");
    rst = stmt.executeQuery();
    rst.next();
}
else{
    cId = 1;
}
out.println("<h4>Reviews</h4>");
if(user != null){
    if(rst.getInt(1) < 1)
    {
        out.println("<form method=\"get\" action=\"product.jsp\">");
        out.println("<h8>How Many Stars?(/5)</h8>");
        out.println("<input type=\"Range\" name=\"Rating\" min=\"0\" max=\"5\">");
        out.println("<h8>Leave a Written Review</h8>");
        out.println("<input type=\"text\" name=\"Review\" size=\"100\">");
        out.println("<input type=\"submit\" value=\"Submit\">");
        out.print("<input type=\"hidden\" name=\"id\" size=\"0\" value=\""+pId+"\"></form>");
    }
}

String rating = request.getParameter("Rating");
String review = request.getParameter("Review");
if(review != null)
{
    String sqlInsert = "INSERT INTO review (reviewRating, reviewDate, customerId, productId, reviewComment) VALUES( ?, ?, ?, ?, ?);";
    stmt = con.prepareStatement(sqlInsert);
    stmt.setInt(1, Integer.parseInt(rating));
    stmt.setTimestamp(2,  new java.sql.Timestamp(new java.util.Date().getTime()));
    stmt.setInt(3, cId);
    stmt.setInt(4, pId);
    stmt.setString(5, review);
    
    stmt.executeUpdate();

}
sql = "SELECT reviewRating, reviewComment, reviewDate FROM review WHERE productId=? ORDER BY reviewRating DESC";
stmt = con.prepareStatement(sql);
stmt.setInt(1, pId);
rst = stmt.executeQuery();
out.println("<table><tbody>");
out.println("<tr><th>Rating</th><th>Comment</th><th>Date Posted</th></tr>");
while (rst.next()) {
    out.println("<tr><th>"+rst.getInt(1)+"</th><th>"+rst.getString(2)+"</th><th>"+rst.getDate(3)+"</th></tr>");
}
try{
    String sql_warehouse = "SELECT warehouse.warehouseName, productinventory.quantity FROM productinventory JOIN warehouse ON warehouse.warehouseId = productinventory.warehouseId WHERE productId=? ";
    PreparedStatement stmt_warehouse = con.prepareStatement(sql_warehouse);
    stmt_warehouse.setInt(1, Integer.parseInt(id));
    ResultSet rst_warehouse = stmt_warehouse.executeQuery();
    rst_warehouse.next();
    out.println("<h2>"+ "Ships From: " +rst_warehouse.getString(1)+"</h2>");
    out.println("<h2>"+ "Amount left: " +rst_warehouse.getInt(2)+"</h2>");
    } catch (Exception e) {
        out.println(e);
        out.println("Warehouse information unavailible");
    }
out.println("</table></tbody>");
%>
</form>
</body>
</html>

