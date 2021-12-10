<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>


<%
session = request.getSession(true);

signUp(request,session);

response.sendRedirect("login.jsp");

%>

<%!
void signUp(HttpServletRequest request, HttpSession session) throws IOException
{
    
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String email = request.getParameter("email");
    String phonenum = request.getParameter("phonenum");
    String address = request.getParameter("address");
    String city = request.getParameter("city");
    String state = request.getParameter("state");
    String postalCode = request.getParameter("postalCode");
    String country = request.getParameter("country");
    String userid = request.getParameter("userid");
    String password = request.getParameter("password");

    getConnection();

    String sql = "INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
    PreparedStatement stmt = con.prepareStatement(sql);
    stmt.setString(1, firstName);
    stmt.setString(2, lastName);
    stmt.setString(3, email);
    stmt.setString(4, phonenum);
    stmt.setString(5, address);
    stmt.setString(6, city);
    stmt.setString(7, state);
    stmt.setString(8, postalCode);
    stmt.setString(9, country);
    stmt.setString(10, userid);
    stmt.setString(11, password);
    stmt.executeQuery();
    closeConnection();
}
%>