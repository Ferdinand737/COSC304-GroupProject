<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>


<%
session = request.getSession(true);

signUp(out,request,session);

response.sendRedirect("admin.jsp");

%>

<%!
void signUp(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
{
    int productId = Integer.parseInt(request.getParameter("productId"));
    out.println("<h1>" + productId + "</h1>");
    try{
        getConnection();
        String sql = "DELETE FROM orderproduct WHERE productId=?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, productId);
        stmt.executeUpdate();
        sql = "DELETE FROM productinventory WHERE productId=?";
        stmt = con.prepareStatement(sql);
        stmt.setInt(1, productId);
        stmt.executeUpdate();
        sql = "DELETE FROM product WHERE productId=?";
        stmt = con.prepareStatement(sql);
        stmt.setInt(1, productId);
        stmt.executeUpdate();
    }catch(Exception e){
        out.println(e);
    }
    closeConnection();
}
%>