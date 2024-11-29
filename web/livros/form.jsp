<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="br.com.livrofacil.model.Livro"%>
<%@page import="br.com.livrofacil.dao.LivroDAO"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cadastro de Livro</title>
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
                        <a class="nav-link active" href="../livros/lista.jsp">Livros</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="../clientes/lista.jsp">Clientes</a>
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
            Livro livro = null;
            
            if (idStr != null && !idStr.isEmpty()) {
                LivroDAO dao = new LivroDAO();
                livro = dao.buscarPorId(Long.parseLong(idStr));
            }
        %>
    
        <h1><%= (livro == null) ? "Novo Livro" : "Editar Livro" %></h1>

        <form action="salvar.jsp" method="post" class="mt-4">
            <% if (livro != null) { %>
                <input type="hidden" name="id" value="<%= livro.getId() %>">
            <% } %>

            <div class="mb-3">
                <label for="titulo" class="form-label">Título</label>
                <input type="text" class="form-control" id="titulo" name="titulo" 
                       value="<%= (livro != null) ? livro.getTitulo() : "" %>" required>
            </div>

            <div class="mb-3">
                <label for="autor" class="form-label">Autor</label>
                <input type="text" class="form-control" id="autor" name="autor" 
                       value="<%= (livro != null) ? livro.getAutor() : "" %>" required>
            </div>

            <div class="mb-3">
                <label for="isbn" class="form-label">ISBN</label>
                <input type="text" class="form-control" id="isbn" name="isbn" 
                       value="<%= (livro != null) ? livro.getIsbn() : "" %>" required>
            </div>

            <div class="mb-3">
                <label for="preco" class="form-label">Preço</label>
                <input type="number" step="0.01" class="form-control" id="preco" name="preco" 
                       value="<%= (livro != null) ? String.format("%.2f", livro.getPreco()) : "" %>" required>
            </div>

            <div class="mb-3">
                <label for="quantidade" class="form-label">Quantidade</label>
                <input type="number" class="form-control" id="quantidade" name="quantidade" 
                       value="<%= (livro != null) ? livro.getQuantidade() : "" %>" required>
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
