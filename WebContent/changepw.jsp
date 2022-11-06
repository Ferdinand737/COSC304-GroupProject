<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>


<%
session = request.getSession(true);

signUp(out,request,session);

response.sendRedirect("login.jsp");

%>

<%!
void signUp(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
{

    String password = request.getParameter("password");

    String user = (String) session.getAttribute("authenticatedUser");

    try{
        getConnection();

        String sql = "UPDATE customer SET password=? WHERE userid=?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, password);
        stmt.setString(2, user);
        
        stmt.executeQuery();
    }catch(Exception e){
        out.println(e);
    }
    closeConnection();


}
%>