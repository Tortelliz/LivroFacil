<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="br.com.livrofacil.model.*"%>
<%@page import="br.com.livrofacil.dao.VendaDAO"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lista de Vendas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <%@include file="../includes/nav.jsp"%>
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Lista de Vendas</h1>
            <a href="form.jsp" class="btn btn-primary">Nova Venda</a>
        </div>

        <%
            String erro = request.getParameter("erro");
            if (erro != null) {
                out.println("<div class='alert alert-danger'>" + erro + "</div>");
            }
            
            String sucesso = request.getParameter("sucesso");
            if (sucesso != null) {
                out.println("<div class='alert alert-success'>" + sucesso + "</div>");
            }
        %>
        
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Cliente</th>
                        <th>Data</th>
                        <th>Valor Total</th>
                        <th>Ações</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                        VendaDAO dao = new VendaDAO();
                        List<Venda> vendas = dao.listar();
                        for(Venda venda : vendas) {
                    %>
                    <tr>
                        <td><%= venda.getId() %></td>
                        <td><%= venda.getCliente().getNome() %></td>
                        <td><%= sdf.format(venda.getDataVenda()) %></td>
                        <td>R$ <%= String.format("%.2f", venda.getValorTotal()) %></td>
                        <td>
                            <div class="btn-group">
                                <a href="detalhes.jsp?id=<%= venda.getId() %>" 
                                   class="btn btn-sm btn-info text-white">
                                    Detalhes
                                </a>
                            </div>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
