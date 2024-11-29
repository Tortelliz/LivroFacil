<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="br.com.livrofacil.model.Cliente"%>
<%@page import="br.com.livrofacil.dao.ClienteDAO"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lista de Clientes</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
        <div class="container">
            <a class="navbar-brand" href="../">LivroFácil</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="../livros/lista.jsp">Livros</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="../clientes/lista.jsp">Clientes</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="../vendas/lista.jsp">Vendas</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Lista de Clientes</h1>
            <a href="form.jsp" class="btn btn-primary">Novo Cliente</a>
        </div>

        <%
            String erro = request.getParameter("erro");
            if (erro != null) {
                out.println("<div class='alert alert-danger mb-4'>" + erro + "</div>");
            }
            
            String sucesso = request.getParameter("sucesso");
            if (sucesso != null) {
                out.println("<div class='alert alert-success mb-4'>" + sucesso + "</div>");
            }
        %>

        <table class="table table-striped table-hover">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Email</th>
                    <th>CPF</th>
                    <th>Telefone</th>
                    <th>Endereço</th>
                    <th>Ações</th>
                </tr>
            </thead>
            <tbody>
                <%
                    ClienteDAO dao = new ClienteDAO();
                    List<Cliente> clientes = dao.listar();
                    for(Cliente cliente : clientes) {
                %>
                <tr>
                    <td><%= cliente.getId() %></td>
                    <td><%= cliente.getNome() %></td>
                    <td><%= cliente.getEmail() %></td>
                    <td><%= cliente.getCpf() %></td>
                    <td><%= cliente.getTelefone() %></td>
                    <td><%= cliente.getEndereco() %></td>
                    <td>
                        <a href="form.jsp?id=<%= cliente.getId() %>" class="btn btn-sm btn-warning">Editar</a>
                        <a href="excluir.jsp?id=<%= cliente.getId() %>" 
                           class="btn btn-sm btn-danger"
                           onclick="return confirm('Tem certeza que deseja excluir este cliente?')">Excluir</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
