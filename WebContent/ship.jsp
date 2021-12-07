<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>YOUR NAME Grocery Shipment Processing</title>
</head>
<body>
        
<%@ include file="header.jsp" %>

<%
	
	// TODO: Get order id
	String orderId = request.getParameter("orderId");
	// TODO: Check if valid order id
	String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
	String uid = "SA";
	String pw = "YourStrong@Passw0rd";
	Connection con = DriverManager.getConnection(url, uid, pw);

	

	int testId = Integer.parseInt(orderId);
	String orderIdCheck = "SELECT orderId FROM orderproduct WHERE orderId=?";
	PreparedStatement testOrder = con.prepareStatement(orderIdCheck);
	testOrder.setInt(1, testId);
	ResultSet ResultOrderId = testOrder.executeQuery();

	if(!ResultOrderId.next()){
		out.println("<h1>Invalid order id. Go back to the previous page and try again.</h1>");
	}else{
	// TODO: Start a transaction (turn-off auto-commit)
	con.setAutoCommit(false);
	// TODO: Retrieve all items in order with given id
	
	String sql = "SELECT * FROM orderproduct WHERE orderId=?";
	PreparedStatement items = con.prepareStatement(sql);
	items.setInt(1, ResultOrderId.getInt(1));
	ResultSet set = items.executeQuery();

	// TODO: Create a new shipment record.
	
	sql = "INSERT INTO shipment (shipmentDate, warehouseId) VALUES (?,?)";

	Date cDate = new Date();
	java.sql.Date sqlDate = new java.sql.Date(cDate.getTime());

	PreparedStatement pstmt = con.prepareStatement(sql);
	pstmt.setDate(1, sqlDate);
	pstmt.setInt(2, 1);
	pstmt.executeUpdate();		

	// TODO: For each item verify sufficient quantity available in warehouse 1.
	

	while(set.next()){
		int prodId = set.getInt(2);
		sql = "SELECT quantity FROM productinventory WHERE productId = ?";
		pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, prodId);
		ResultSet s = pstmt.executeQuery();
		s.next();
		if(s.getInt(1) < set.getInt(3)){
			out.println("<h1>Shipment not done. Insufficient inventory for product id: " + prodId + "</h1>");
			con.rollback();
			break;
		}
		int newinv = s.getInt(1) - set.getInt(3);
		out.println("<h2>Ordered product:" + prodId + " Qty: " + set.getInt(3) + " Previous inventory: " + s.getInt(1) +  " New inventory: " + newinv + "</h2>");

		sql = "UPDATE productinventory SET quantity=? WHERE productId=?";
		pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, newinv);
		pstmt.setInt(2, prodId);
		pstmt.executeUpdate();	
	}
	// TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.


	// TODO: Auto-commit should be turned back on

	con.setAutoCommit(true);

	}
%>                       				

<h2><a href="index.jsp">Back to Main Page</a></h2>

</body>
</html>
