<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>


<%
session = request.getSession(true);

signUp(out,request,session);

response.sendRedirect("customer.jsp");

%>

<%!
void signUp(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
{
    String address = request.getParameter("address");
    String city = request.getParameter("city");
    String state = request.getParameter("state");
    String postalCode = request.getParameter("postalCode");
    String country = request.getParameter("country");

    String user = (String) session.getAttribute("authenticatedUser");

    try{
        getConnection();

        String sql = "UPDATE customer SET address=?, city=?, state=?, postalCode=?, country=? WHERE userid=?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, address);
        stmt.setString(2, city);
        stmt.setString(3, state);
        stmt.setString(4, postalCode);
        stmt.setString(5, country);
        stmt.setString(6, user);
        stmt.executeQuery();
    }catch(Exception e){
        out.println(e);
    }
    closeConnection();


}

%>