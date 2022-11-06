<%@ page trimDirectiveWhitespaces="true" import="java.sql.*,java.io.*" %><%@ include file="jdbc.jsp" %><%

response.setContentType("image/jpeg");  

String id = request.getParameter("id");

if (id == null)
	return;

int idVal = -1;
try{
	idVal = Integer.parseInt(id);
}
catch(Exception e)
{	out.println("Invalid image id: "+id+" Error: "+e);
	return; 
}

String sql = "SELECT productImage FROM product WHERE productId="+id;

try 
{
	getConnection();
	PreparedStatement stmt = con.prepareStatement(sql);
	stmt.setInt(1,idVal);
	ResultSet rst = stmt.executeQuery();		

	int BUFFER_SIZE = 10000;
	byte[] data = new byte[BUFFER_SIZE];

	if (rst.next())
	{
		InputStream istream = rst.getBinaryStream(1);
		OutputStream ostream = response.getOutputStream();

		int count;
		while ( (count = istream.read(data, 0, BUFFER_SIZE)) != -1)
			ostream.write(data, 0, count);

		ostream.flush();
		istream.close();					
	}
} 
catch (SQLException ex) {
	out.println(ex);
}
finally
{
	closeConnection();
}
%>