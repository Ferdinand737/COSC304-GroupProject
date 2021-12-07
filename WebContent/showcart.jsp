<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Your Shopping Cart</title>
</head>
<body>
<%@ include file="header.jsp" %>
<script>
function update(newid, newqty)
{
	window.location="showcart.jsp? update="+newid+"&newqty="+newqty;
}
</script>
<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

String deleteId = request.getParameter("delete");
String updateId = request.getParameter("update");
String newqty = request.getParameter("newqty");
productList.remove(deleteId);
if(updateId != null)
{
	if (productList.containsKey(updateId))
	{
		productList.get(updateId).set(3, newqty);
	}
}

if (productList == null)
{	out.println("<H1>Your shopping cart is empty!</H1>");
	productList = new HashMap<String, ArrayList<Object>>();
}
else
{
	NumberFormat currFormat = NumberFormat.getCurrencyInstance(new Locale("en", "US"));
	String linkDelete = "showcart.jsp?delete=";
	out.println("<h1>Your Shopping Cart</h1>");
	out.print("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
	out.println("<th>Price</th><th>Subtotal</th><th>Hrlo</th><th>JR</th></tr>");
	
	double total =0;
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext()) 
	{	Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		if (product.size() < 4)
		{
			out.println("Expected product with four entries. Got: "+product);
			continue;
		}
		
		out.print("<tr><td>"+product.get(0)+"</td>");
		out.print("<td>"+product.get(1)+"</td>");

		out.print("<form method=\"get\" action=\"showcart.jsp\"><td align=\"center\">");
		out.print("<input type=\"text\" name=\"newqty\" size=\"3\" value=\""+product.get(3)+"\">");
		out.print("<input type=\"hidden\" name=\"update\" size=\"0\" value=\""+product.get(0)+"\"></td>");
		Object price = product.get(2);
		Object itemqty = product.get(3);
		double pr = 0;
		int qty = 0;
		
		try
		{
			pr = Double.parseDouble((price.toString()).substring(1));
		}
		catch (Exception e)
		{
			out.println("Invalid price for product: "+product.get(0)+" price: "+price);
		}
		try
		{
			qty = Integer.parseInt(itemqty.toString());
		}
		catch (Exception e)
		{
			out.println("Invalid quantity for product: "+product.get(0)+" quantity: "+qty);
		}		

		out.print("<td align=\"right\">"+currFormat.format(pr)+"</td>");
		out.print("<td align=\"right\">"+currFormat.format(pr*qty)+"</td>");
		out.print("<td><a href=\""+linkDelete + product.get(0)+"\">Remove Item From Cart</a></td>");
		out.print("<td><input type=\"submit\" value=\"Update Quantity\"></td></form></tr>");
		out.println("</tr>");
		total = total +pr*qty;
	}//onclick=\"update("+product.get(0)+", document.form1.newqty.value)\"
	out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
			+"<td align=\"right\">"+currFormat.format(total)+"</td></tr>");
	out.println("</table>");

	out.println("<h2><a href=\"checkout.jsp\">Check Out</a></h2>");
}
%>
<h2><a href="listprod.jsp">Continue Shopping</a></h2>
</body>
</html> 

