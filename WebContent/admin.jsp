<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<h1 align="center"><a href="index.jsp">MAF Grocery</a></h1>
<h1 align="center">Administrator Portal</h1>

<br>

<div style="margin:0 auto;text-align:center;display:inline;">

<h2 align="center">Add new product</h2>


<form name="Form1" method=post action="addProduct.jsp">
<table style="display:inline">
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Product Name:</font></div></td>
	<td><input type="text" name="productName"  size=30 maxlength="40"></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Product Price:</font></div></td>
	<td><input type="text" name="productPrice" size=30 maxlength="12"></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Image URL:</font></div></td>
	<td><input type="text" name="productImageURL"  size=30 maxlength="100"></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Description:</font></div></td>
	<td><input type="text" name="productDesc"  size=30 maxlength="1000"></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Category ID:</font></div></td>
	<td><input type="text" name="categoryId"  size=30 maxlength="100"></td>
</tr>
</table>
<br/>
<input class="submit" type="submit" name="Submit2" value="Add Product">
</form>
<br>
<h2 align="center">Update Product</h2>

<form name="Form2" method=post action="updateProduct.jsp">
<table style="display:inline">
    <tr>
        <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Product ID:</font></div></td>
        <td><input type="text" name="productId"  size=30 maxlength="100"></td>
    </tr>
    <tr>
        <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Product Name:</font></div></td>
        <td><input type="text" name="productName"  size=30 maxlength="40"></td>
    </tr>
    <tr>
        <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Product Price:</font></div></td>
        <td><input type="text" name="productPrice" size=30 maxlength="12"></td>
    </tr>
    <tr>
        <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Image URL:</font></div></td>
        <td><input type="text" name="productImageURL"  size=30 maxlength="100"></td>
    </tr>
    <tr>
        <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Description:</font></div></td>
        <td><input type="text" name="productDesc"  size=30 maxlength="1000"></td>
    </tr>
    <tr>
        <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Category ID:</font></div></td>
        <td><input type="text" name="categoryId"  size=30 maxlength="100"></td>
    </tr>
</table>
<br/>
<input class="submit" type="submit" name="Submit2" value="Update this Product">
</form>
<br>
<h2 align="center">Delete Product</h2>

<form name="Form2" method=post action="deleteProduct.jsp">
<table style="display:inline">
    <tr>
        <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Product ID:</font></div></td>
        <td><input type="text" name="productId"  size=30 maxlength="100"></td>
    </tr>
</table>
<br/>
<input class="submit" type="submit" name="Submit2" value="Delete this Product">
</form>
<br>

</div>
<br>
<br>

<h2 align="center">List of Customers</h2>

<%
// print all customers

getConnection();

String sql = "SELECT * FROM customer";
PreparedStatement stmt = con.prepareStatement(sql);
ResultSet rst = stmt.executeQuery();

out.println("<table class=\"table\" border=\"1\" align=\"center\">");
out.println("<tbody>");
out.println("<tr>");
out.println("<th>Customer ID</th>");
out.println("<th>Customer Name</th>");
out.println("<th>Customer Email</th>");
out.println("<th>Customer Phone Number</th>");
out.println("<th>Address</th>");
out.println("<th>Username</th>");
out.println("<th>Password</th>");
out.println("</tr>");

while(rst.next())
{
        String customerName = rst.getString(2) + rst.getString(3);
        String address = rst.getString(6) + " " + rst.getString(7)+ " " + rst.getString(8)+ " " + rst.getString(8)+ " " + rst.getString(10);
        out.println("<tr>");
        out.println("<td>"+rst.getInt(1)+"</td>");
        out.println("<td>"+customerName+"</td>");
        out.println("<td>"+rst.getString(4)+"</td>");
        out.println("<td>"+rst.getString(5)+"</td>");
        out.println("<td>"+address+"</td>");
        out.println("<td>"+rst.getString(11)+"</td>");
        out.println("<td>"+rst.getString(12)+"</td>");
        out.println("</tr>");  
}
out.println("</tbody></table>");
%>
<h2 align="center">List of Orders</h2>
<%
// print all orders
Double sum = 0.0;
sql = "SELECT * FROM ordersummary";
stmt = con.prepareStatement(sql);
rst = stmt.executeQuery();

out.println("<table class=\"table\" border=\"1\" align=\"center\">");
out.println("<tbody>");
out.println("<tr>");
out.println("<th>Order ID</th>");
out.println("<th>Order Date</th>");
out.println("<th>Total amount</th>");
out.println("<th>Ship to Address</th>");
out.println("<th>Customer ID</th>");
out.println("</tr>");

while(rst.next())
{       
        String sql2 = "SELECT * FROM customer WHERE customerId=?";
        PreparedStatement stmt2 = con.prepareStatement(sql2);
        stmt2.setInt(1,rst.getInt(9));
        ResultSet rst2 = stmt2.executeQuery();
        rst2.next();
        String address = rst2.getString(6) + " " + rst2.getString(7)+ " " + rst2.getString(8)+ " " + rst2.getString(8)+ " " + rst2.getString(10);
        out.println("<tr>");
        out.println("<td>"+rst.getInt(1)+"</td>");
        out.println("<td>"+rst.getString(2)+"</td>");
        out.println("<td>"+rst.getDouble(3)+"</td>");
        out.println("<td>"+address+"</td>");
        out.println("<td>"+rst.getInt(9)+"</td>");
        out.println("</tr>");  
        sum += rst.getDouble(3);
}
out.println("</tbody></table>");

out.println("<h2 align=\"center\">Total sales = " + NumberFormat.getCurrencyInstance(Locale.CANADA).format(sum) + "! </h2>");

closeConnection();

%>
<h2 align="center"><a href="loaddata.jsp">Reset Database</a></h2>


</body>
</html>

