<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="br.com.livrofacil.dao.ClienteDAO"%>

<%
try {
    Long id = Long.parseLong(request.getParameter("id"));
    ClienteDAO dao = new ClienteDAO();
    dao.excluir(id);
    response.sendRedirect("lista.jsp?sucesso=" + java.net.URLEncoder.encode("Cliente excluído com sucesso!", "UTF-8"));
} catch (RuntimeException e) {
    response.sendRedirect("lista.jsp?erro=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
}
%>