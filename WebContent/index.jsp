<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<!DOCTYPE html>
<html>
<head>
        <title>MAF Grocery</title>
</head>
<body>
<h1 align="center">Welcome to MAF Grocery</h1>
<%@ include file="header.jsp" %>


<h2 align="center"><a href="listprod.jsp">Begin Shopping</a></h2>

<%
String user = (String)session.getAttribute("authenticatedUser");
if(user != null){
        out.print("<h2 align=\"center\"><a href=\"customer.jsp\">Your Info</a></h2>");      
}
if(user != null){
        out.print("<h2 align=\"center\"><a href=\"logout.jsp\">Log out</a></h2>");  
        if(user.equals("Admin")){
                out.print("<h2 align=\"center\"><a href=\"admin.jsp\">Admin Portal</a></h2>");  
        }    
}else{
        out.print("<h2 align=\"center\"><a href=\"login.jsp\">Login</a></h2>");
        out.print("<h2 align=\"center\"><a href=\"signUp.jsp\">Sign Up</a></h2>");
}
%>

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
<%
String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";
Connection con = DriverManager.getConnection(url, uid, pw);

out.print("<form align=\"center\" method=\"get\" action=\"listprod.jsp\"><td>");
out.print("<input type=\"text\" name=\"productName\" size=\"50\"><input type=\"hidden\" name=\"sort\" value=\"p.productId\">");
out.print("<input type=\"submit\" value=\"Submit\"></td></form></tr>");


PreparedStatement stmt;
ResultSet rst;
if(user != null) {
        String sqlUser = "SELECT customerId FROM customer WHERE userid=\'"+user+"\';";
        stmt = con.prepareStatement(sqlUser);
        rst = stmt.executeQuery();
        rst.next();
        int id = rst.getInt(1);
        out.print("<h3 align=\"center\">For You</h3>");
        String sql = "SELECT p.productId, productName, productPrice, categoryName, AVG(reviewRating), productImageURL "
                +"FROM product AS p LEFT JOIN category AS c ON p.categoryId=c.categoryId "
                +"LEFT JOIN orderproduct AS o ON p.productId=o.productId "
                +"RIGHT JOIN ordersummary AS s ON o.orderId=s.orderId LEFT JOIN review AS r ON p.productId=r.productId "
                +"WHERE s.customerId=" + id + " "
                +"GROUP BY p.productId, productName, productPrice, categoryName, productImageURL ORDER BY AVG(reviewRating) DESC;";
     
        stmt = con.prepareStatement(sql);
        rst = stmt.executeQuery();

        out.println("<table class=\"table\" border=\"1\">");
        out.println("<tbody>");
        out.println("<tr>");
        out.println("<th class=\"col-md-1\"></th>");
        out.println("<th>Product Name</th><th></th>");
        out.println("<th>Category</th>");
        out.println("<th>Rating</th>");
        out.println("<th>Price</th>");
        out.println("</tr>");

        while(rst.next())
        {
                out.println("<tr>");
                String linkAdd = "addcart.jsp?id=" + rst.getInt(1) + "&name=" + rst.getString(2) + "&price=" + NumberFormat.getCurrencyInstance(Locale.CANADA).format(rst.getDouble(3));
                String linkProd = "product.jsp?id=" + rst.getInt(1);
                String linkCategory = "listprod.jsp?category=" + rst.getString(4);
                out.println("<td class=\"col-md-1\"><a href=\"" + linkAdd + "\"><h2>Add to Cart</h2></a></td>");
                out.println("<td><a href=\"" + linkProd + "\"><h2>" +rst.getString(2) + "</h2></td><td><img src=" +  "\"" + rst.getString(6) + "\" width=\"200\" height=\"400\"></td>");
                out.println("<td><a href=\"" + linkCategory + "\"><h2>"+rst.getString(4)+"</h2></td>");
                out.println("<td><h2>"+rst.getDouble(5)+"</h2></td>");
                out.println("<td><h2>" + NumberFormat.getCurrencyInstance(Locale.CANADA).format(rst.getDouble(3)) + "</h2></td>");
                out.println("</tr>");  
        }
}

out.println("</tbody></table>");
out.print("<h3 align=\"center\">Top Rated</h3>");
String str = "SELECT p.productId, productName, productPrice, categoryName, AVG(reviewRating), productImageURL "
             +"FROM product AS p LEFT JOIN category AS c ON p.categoryId=c.categoryId "
             +"LEFT JOIN review AS r ON p.productId=r.productId "
             +"GROUP BY p.productId, productName, productPrice, categoryName, productImageURL ORDER BY AVG(reviewRating) DESC;";
stmt = con.prepareStatement(str);
rst = stmt.executeQuery();
out.println("<table class=\"table\" border=\"1\">");
out.println("<tbody>");
out.println("<tr>");
out.println("<th class=\"col-md-1\"></th>");
out.println("<th>Product Name</th><th></th>");
out.println("<th>Category</th>");
out.println("<th>Rating</th>");
out.println("<th>Price</th>");
out.println("</tr>");

while(rst.next()){

        if(1<rst.getDouble(5)) {

                out.println("<tr>");
                String linkAdd = "addcart.jsp?id=" + rst.getInt(1) + "&name=" + rst.getString(2) + "&price=" + NumberFormat.getCurrencyInstance(Locale.CANADA).format(rst.getDouble(3));
                String linkProd = "product.jsp?id=" + rst.getInt(1);
                String linkCategory = "listprod.jsp?category=" + rst.getString(4);
                out.println("<td class=\"col-md-1\"><a href=\"" + linkAdd + "\"><h2>Add to Cart</h2></a></td>");
                out.println("<td><a href=\"" + linkProd + "\"><h2>" +rst.getString(2) + "</h2></td><td><img src=" +  "\"" + rst.getString(6) + "\" width=\"200\" height=\"400\"></td>");
                out.println("<td><a href=\"" + linkCategory + "\"><h2>"+rst.getString(4)+"</h2></td>");
                out.println("<td><h2>"+rst.getDouble(5)+"</h2></td>");
                out.println("<td><h2>" + NumberFormat.getCurrencyInstance(Locale.CANADA).format(rst.getDouble(3)) + "</h2></td>");
                out.println("</tr>");  
        }

}

%>

</body>
</head>
