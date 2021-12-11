<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery Order Processing</title>
</head>
<body>
<%@ include file="header.jsp" %>

<% 
// Get customer id
String userid = (String) session.getAttribute("authenticatedUser");
getConnection();
String sql = "SELECT customerId FROM customer WHERE userid=?";
PreparedStatement stmt = con.prepareStatement(sql);
stmt.setString(1, userid);
ResultSet rst = stmt.executeQuery();
rst.next();
int custId = rst.getInt(1);

@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
// Make connection
String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";
Connection con = DriverManager.getConnection(url, uid, pw);
// Determine if valid customer id was entered
int testId = custId;
String custIdCheck = "SELECT customerId FROM customer WHERE customerId=?";
PreparedStatement testCust = con.prepareStatement(custIdCheck);
testCust.setInt(1, testId);
ResultSet ResultCustId = testCust.executeQuery();

if(!ResultCustId.next() || productList.isEmpty() ){
	if(!ResultCustId.next()){
		out.println("<h1>Invalid customer id. Go back to the previous page and try again.</h1>");
	}
	if(productList.isEmpty()){
		out.println("<h1>Shopping cart is empty. Go back to the previous page and try again.</h1>");
	}
}else{
// Determine if there are products in the shopping cart

// If either are not true, display an error message

// Save order information to database
out.println("<h1>Your Order Summary</h1>");
Date cDate = new Date();
java.sql.Date sqlDate = new java.sql.Date(cDate.getTime()); 
double totalAmm = 0.0;
sql = "INSERT INTO ordersummary (customerId,orderDate,totalAmount) VALUES (?,?,?)";
// Use retrieval of auto-generated keys.
PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
pstmt.setInt(1, testId);
pstmt.setDate(2, sqlDate);
pstmt.setDouble(3, totalAmm);
pstmt.executeUpdate();		
ResultSet keys = pstmt.getGeneratedKeys();
keys.next();
int orderId = keys.getInt(1);
// Insert each item into OrderProduct table using OrderId from previous INSERT
String insertProdSQl = "INSERT INTO orderproduct (orderId,productId,quantity,price) VALUES (?,?,?,?)";
double totalCost = 0.0;
// Update total amount for order record
// Here is the code to traverse through a HashMap
// Each entry in the HashMap is an ArrayList with item 0-id, 1-name, 2-quantity, 3-price
Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
while (iterator.hasNext())
{ 
	Map.Entry<String, ArrayList<Object>> entry = iterator.next();
	ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
	String productId = (String) product.get(0);
    String price = (String) product.get(2);
	double pr = Double.parseDouble(price.substring(1));
	int qty = ( (Integer)product.get(3)).intValue();
	PreparedStatement insertProd = con.prepareStatement(insertProdSQl);
	insertProd.setInt(1, orderId);
	insertProd.setInt(2, Integer.parseInt(productId));
	insertProd.setInt(3, qty);
	insertProd.setDouble(4, pr);
	insertProd.executeUpdate();
	totalCost += (pr * qty);
}

String updateTotalAmount = "UPDATE ordersummary SET totalAmount=? WHERE orderId=?";
PreparedStatement updateAmount = con.prepareStatement(updateTotalAmount);
updateAmount.setDouble(1,totalCost);
updateAmount.setInt(2,orderId);
updateAmount.executeUpdate();
// Print out order summary
out.println("<table><tr><td>Product Id</td><td>Product Name</td><td>Quantity</td><td>Price</td><td>Subtotal</td></tr>");
String query = "SELECT O.productId, P.productName, O.quantity, O.price FROM orderproduct AS O LEFT JOIN product AS P ON O.productId=P.productId WHERE orderId=?";
pstmt = con.prepareStatement(query);
pstmt.setInt(1,orderId);
ResultSet set = pstmt.executeQuery();
NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.CANADA);
double orderTotal = 0.0;
while (set.next()) {
			
	out.println("<tr><td>"+ set.getInt("productId") + "</td><td>" + set.getString("productName") + "</td><td align=\"center\">" + set.getInt("quantity") + "</td><td align=\"right\">" + currFormat.format(set.getDouble("price")) + "</td><td align=\"right\">"+ currFormat.format((set.getInt("quantity") * set.getDouble("price"))) +"</td></tr>");
	orderTotal += (set.getInt("quantity") * set.getDouble("Price"));
}
out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td><td align=\"right\">" + currFormat.format(orderTotal) + "</td></tr></table>");
		
String custNameCheck = "SELECT C.firstName, C.lastName FROM ordersummary AS O LEFT JOIN customer AS C ON O.customerId=C.customerId WHERE orderId=?";
PreparedStatement cName = con.prepareStatement(custNameCheck);
		
cName.setInt(1, orderId);
ResultSet Name = cName.executeQuery();
Name.next();
out.println("<h1>Your Order has been Completed and Will be Shipped </h1>");
out.println("<h1>Shipping to Customer: " + custId + "</h1>");
out.println("<h1>Name: " + Name.getString("firstName") + " " + Name.getString("lastName") + "</h1>");
out.println("<h2><a href=\"listprod.jsp\">Return To Shopping</a></h2>");
out.println("<h2><a href=\"index.jsp\">Return To The Home Page</a></h2>");


//update inventory
iterator = productList.entrySet().iterator();
while(iterator.hasNext()){

	Map.Entry<String, ArrayList<Object>> entry = iterator.next();
	ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
	int productId = Integer.parseInt((String) product.get(0));
	int qty = ( (Integer)product.get(3)).intValue();
	
	//get current inventory
	sql = "SELECT quantity FROM productinventory WHERE productId=?";
	stmt = con.prepareStatement(sql);
	stmt.setInt(1, productId);
	rst = stmt.executeQuery();
	rst.next();
	int inventory = rst.getInt(1);

	//update current - qty
	sql = "UPDATE productinventory SET quantity=? WHERE productId=?";
	stmt = con.prepareStatement(sql);
	stmt.setInt(1, inventory-qty);
	stmt.setInt(2, productId);
	stmt.executeUpdate();
	
}


// Clear cart if order placed successfully
productList.clear();

}
%>
</BODY>
</HTML>

