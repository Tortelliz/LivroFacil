<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="br.com.livrofacil.model.Cliente"%>
<%@page import="br.com.livrofacil.dao.ClienteDAO"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cadastro de Cliente</title>
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
        <%
            String idStr = request.getParameter("id");
            Cliente cliente = null;
            
            if (idStr != null && !idStr.isEmpty()) {
                ClienteDAO dao = new ClienteDAO();
                cliente = dao.buscarPorId(Long.parseLong(idStr));
            }
        %>
    
        <h1><%= (cliente == null) ? "Novo Cliente" : "Editar Cliente" %></h1>

        <form action="salvar.jsp" method="post" class="mt-4">
            <% if (cliente != null) { %>
                <input type="hidden" name="id" value="<%= cliente.getId() %>">
            <% } %>

            <div class="mb-3">
                <label for="nome" class="form-label">Nome</label>
                <input type="text" class="form-control" id="nome" name="nome" 
                       value="<%= (cliente != null) ? cliente.getNome() : "" %>" required>
            </div>

            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" class="form-control" id="email" name="email" 
                       value="<%= (cliente != null) ? cliente.getEmail() : "" %>" required>
            </div>

            <div class="mb-3">
                <label for="cpf" class="form-label">CPF</label>
                <input type="text" class="form-control" id="cpf" name="cpf" 
                       value="<%= (cliente != null) ? cliente.getCpf() : "" %>" required>
            </div>

            <div class="mb-3">
                <label for="telefone" class="form-label">Telefone</label>
                <input type="text" class="form-control" id="telefone" name="telefone" 
                       value="<%= (cliente != null) ? cliente.getTelefone() : "" %>" required>
            </div>

            <div class="mb-3">
                <label for="endereco" class="form-label">Endereço</label>
                <input type="text" class="form-control" id="endereco" name="endereco" 
                       value="<%= (cliente != null) ? cliente.getEndereco() : "" %>" required>
            </div>

            <div class="mb-3">
                <a href="lista.jsp" class="btn btn-secondary">Cancelar</a>
                <button type="submit" class="btn btn-primary">Salvar</button>
            </div>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
