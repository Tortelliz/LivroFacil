<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>LivroFácil - Sistema de Gerenciamento</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
        <div class="container">
            <a class="navbar-brand" href="./">LivroFácil</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="livros/lista.jsp">Livros</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="clientes/lista.jsp">Clientes</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="vendas/lista.jsp">Vendas</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="jumbotron">
            <h1 class="display-4">Bem-vindo ao LivroFácil</h1>
            <p class="lead">Sistema de Gerenciamento de Livraria</p>
            <hr class="my-4" />
        </div>

        <div class="row mt-4">
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Gerenciar Livros</h5>
                        <p class="card-text">Cadastre, edite e controle o estoque de livros.</p>
                        <a href="livros/lista.jsp" class="btn btn-primary">Acessar Livros</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Gerenciar Clientes</h5>
                        <p class="card-text">Cadastre e gerencie os clientes da livraria.</p>
                        <a href="clientes/lista.jsp" class="btn btn-primary">Acessar Clientes</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Gerenciar Vendas</h5>
                        <p class="card-text">Registre e consulte as vendas realizadas.</p>
                        <a href="vendas/lista.jsp" class="btn btn-primary">Acessar Vendas</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
