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
    
    String productName = request.getParameter("productName");
    Double productPrice = Double.parseDouble(request.getParameter("productPrice"));
    String productImageURL = request.getParameter("productImageURL");
    String productDesc = request.getParameter("productDesc");
    int categoryId = Integer.parseInt(request.getParameter("categoryId"));
    int productId = Integer.parseInt(request.getParameter("productId"));

    try{
        getConnection();
        String sql = "UPDATE product SET productName=?, productPrice=?, productImageURL=?, productDesc=?, categoryId=? WHERE productId=?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, productName);
        stmt.setDouble(2, productPrice);
        stmt.setString(3, productImageURL);
        stmt.setString(4, productDesc);
        stmt.setInt(5, categoryId);
        stmt.setInt(6, productId);
        stmt.executeUpdate();
    }catch(Exception e){
        out.println(e);
    }
    closeConnection();
}
%>