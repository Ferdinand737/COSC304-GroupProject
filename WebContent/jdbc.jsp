
<%@ page import="java.sql.*"%>

<%!
	// User id, password, and server information
	private String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
	private String uid = "SA";
	private String pw = "YourStrong@Passw0rd";

	// Connection
	private Connection con = null;
%>

<%!
	public void getConnection() throws SQLException 
	{
		try
		{	// Load driver class
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		}
		catch (java.lang.ClassNotFoundException e)
		{
			throw new SQLException("ClassNotFoundException: " +e);
		}
	
		con = DriverManager.getConnection(url, uid, pw);
	}
   
	public void closeConnection() 
	{
		try {
			if (con != null){
				con.close();
			}
			con = null;
		}catch (SQLException ignore){
			 /* Ignore connection close error */ 
			}
	}
%>
