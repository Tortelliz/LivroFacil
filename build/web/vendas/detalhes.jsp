<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="br.com.livrofacil.model.*"%>
<%@page import="br.com.livrofacil.dao.*"%>
<%@page import="br.com.livrofacil.util.ConectaDB"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Detalhes da Venda</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
    <%@include file="../includes/nav.jsp" %>

    <div class="container mt-4">
        <%
            try {
                Long id = Long.parseLong(request.getParameter("id"));
                VendaDAO dao = new VendaDAO();
                Venda venda = dao.buscarPorId(id);
                
                if (venda == null) {
                    out.println("<div class='alert alert-danger'>Venda não encontrada</div>");
                    return;
                }
                
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
        %>
        
        <div class="card mb-4">
            <div class="card-body">
                <h3 class="card-title">Detalhes da Venda #<%= venda.getId() %></h3>
                <div class="row">
                    <div class="col-md-6">
                        <p>
                            <strong>Cliente:</strong>
                            <%= venda.getCliente().getNome() %>
                        </p>
                        <p>
                            <strong>Data:</strong>
                            <%= sdf.format(venda.getDataVenda()) %>
                        </p>
                    </div>
                    <div class="col-md-6 text-end">
                        <h4>
                            Total: R$ <%= String.format("%.2f", venda.getValorTotal()) %>
                        </h4>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-body">
                <h4 class="card-title">Itens da Venda</h4>
                <table class="table">
                    <thead>
                        <tr>
                            <th>Livro</th>
                            <th>Quantidade</th>
                            <th>Preço Unitário</th>
                            <th>Subtotal</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(ItemVenda item : venda.getItens()) { %>
                        <tr>
                            <td><%= item.getLivro().getTitulo() %></td>
                            <td><%= item.getQuantidade() %></td>
                            <td>R$ <%= String.format("%.2f", item.getPrecoUnitario()) %></td>
                            <td>R$ <%= String.format("%.2f", item.getSubtotal()) %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="mt-4">
            <a href="lista.jsp" class="btn btn-secondary">Voltar para Lista</a>
        </div>
        
        <%
            } catch(Exception e) {
                out.println("<div class='alert alert-danger'>Erro ao carregar detalhes da venda: " + e.getMessage() + "</div>");
            }
        %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
