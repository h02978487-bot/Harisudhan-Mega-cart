<%
    if(session.getAttribute("role") == null){
        response.sendRedirect("login.jsp");
        return;
    }
%>
<%
    String role = (String) session.getAttribute("role");
    if (role == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
