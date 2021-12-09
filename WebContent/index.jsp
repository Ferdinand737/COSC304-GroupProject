<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<!DOCTYPE html>
<html>
<head>
        <title>YOUR NAME Grocery Main Page</title>
</head>
<body>
<h1 align="center">Welcome to MAF Grocery</h1>

<h2 align="center"><a href="login.jsp">Login</a></h2>

<h2 align="center"><a href="listprod.jsp">Begin Shopping</a></h2>

<h2 align="center"><a href="listorder.jsp">List All Orders</a></h2>

<h2 align="center"><a href="customer.jsp">Customer Info</a></h2>

<h2 align="center"><a href="admin.jsp">Administrators</a></h2>

<h2 align="center"><a href="logout.jsp">Log out</a></h2>
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
// TODO: Display user name that is logged in (or nothing if not logged in)



out.print("<form align=\"center\" method=\"get\" action=\"listprod.jsp\"><td>");
out.print("<input type=\"text\" name=\"productName\" size=\"50\"><input type=\"hidden\" name=\"sort\" value=\"p.productId\">");
out.print("<input type=\"submit\" value=\"Submit\"></td></form></tr>");

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Needs to be implemented with account
//For Now assumed ID will be 1
int id = 2;
out.print("<h3 align=\"center\">For You</h3>");
String sql = "SELECT p.productId, productName, productPrice, categoryName, AVG(reviewRating), productImageURL "
             +"FROM product AS p LEFT JOIN category AS c ON p.categoryId=c.categoryId "
             +"LEFT JOIN orderproduct AS o ON p.productId=o.productId "
             +"RIGHT JOIN ordersummary AS s ON o.orderId=s.orderId LEFT JOIN review AS r ON p.productId=r.productId "
             +"WHERE s.customerId=" + id + " "
             +"GROUP BY p.productId, productName, productPrice, categoryName, productImageURL ORDER BY AVG(reviewRating) DESC;";
//This querry works by taking all of the products they have already ordered, and returns it back to them.
//In the context of a Grocer thats fine, but if we change product types, then may be problematic
//That is why sortof done

PreparedStatement stmt = con.prepareStatement(sql);
ResultSet rst = stmt.executeQuery();

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
        out.println("<td class=\"col-md-1\"><a href=\"" + linkAdd + "\">Add to Cart</a></td>");
        out.println("<td><a href=\"" + linkProd + "\">" +rst.getString(2) + "</td><td><img src=\""+rst.getString(6)+"\"></td>");
        out.println("<td><a href=\"" + linkCategory + "\">"+rst.getString(4)+"</td>");
        out.println("<td>"+rst.getDouble(5)+"</td>");
        out.println("<td>" + NumberFormat.getCurrencyInstance(Locale.CANADA).format(rst.getDouble(3)) + "</td>");
        out.println("</tr>");  
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



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
                out.println("<td class=\"col-md-1\"><a href=\"" + linkAdd + "\">Add to Cart</a></td>");
                out.println("<td><a href=\"" + linkProd + "\">" +rst.getString(2) + "</td><td><img src=\""+rst.getString(6)+"\"></td>");
                out.println("<td><a href=\"" + linkCategory + "\">"+rst.getString(4)+"</td>");
                out.println("<td>"+rst.getDouble(5)+"</td>");
                out.println("<td>" + NumberFormat.getCurrencyInstance(Locale.CANADA).format(rst.getDouble(3)) + "</td>");
                out.println("</tr>");
        }

}

%>

</body>
</head>
