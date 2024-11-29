<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="br.com.livrofacil.model.*"%>
<%@page import="br.com.livrofacil.dao.*"%>
<%@page import="br.com.livrofacil.util.ConectaDB"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Nova Venda</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
    <%@include file="../includes/nav.jsp" %>

    <div class="container mt-4">
        <%
            String erro = (String) session.getAttribute("erro");
            if (erro != null) {
                out.println("<div class='alert alert-danger'>" + erro + "</div>");
                session.removeAttribute("erro");
            }
        %>

        <h1>Nova Venda</h1>

        <form action="salvar.jsp" method="post">
            <div class="card mb-4">
                <div class="card-body">
                    <h5 class="card-title">Dados da Venda</h5>
                    <div class="mb-3">
                        <label for="cliente" class="form-label">Cliente</label>
                        <select class="form-select" id="cliente" name="cliente.id" required>
                            <option value="">Selecione um cliente</option>
                            <%
                                try {
                                    ClienteDAO clienteDAO = new ClienteDAO();
                                    List<Cliente> clientes = clienteDAO.listar();
                                    for(Cliente cliente : clientes) {
                                        out.println("<option value='" + cliente.getId() + "'>" + cliente.getNome() + "</option>");
                                    }
                                } catch(Exception e) {
                                    out.println("<option value=''>Erro ao carregar clientes</option>");
                                }
                            %>
                        </select>
                    </div>
                </div>
            </div>

            <div class="card mb-4">
                <div class="card-body">
                    <h5 class="card-title">Itens da Venda</h5>
                    <div id="itensContainer">
                        <div class="row mb-3 item-venda">
                            <div class="col-md-5">
                                <label class="form-label">Livro</label>
                                <select class="form-select livro-select" name="itens[0].livro.id" required>
                                    <option value="">Selecione um livro</option>
                                    <%
                                        try {
                                            LivroDAO livroDAO = new LivroDAO();
                                            List<Livro> livros = livroDAO.listar();
                                            for(Livro livro : livros) {
                                                out.println("<option value='" + livro.getId() + "' data-preco='" + livro.getPreco() + "'>" 
                                                    + livro.getTitulo() + " - R$ " + String.format("%.2f", livro.getPreco()) + "</option>");
                                            }
                                        } catch(Exception e) {
                                            out.println("<option value=''>Erro ao carregar livros</option>");
                                        }
                                    %>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Quantidade</label>
                                <input type="number" class="form-control quantidade-input" name="itens[0].quantidade" min="1" required/>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Preço Unitário</label>
                                <input type="number" class="form-control preco-input" name="itens[0].precoUnitario" step="0.01" readonly/>
                            </div>
                            <div class="col-md-1">
                                <label class="form-label">&nbsp;</label>
                                <button type="button" class="btn btn-danger form-control remover-item">X</button>
                            </div>
                        </div>
                    </div>

                    <button type="button" class="btn btn-secondary" id="adicionarItem">Adicionar Item</button>
                </div>
            </div>

            <div class="card mb-4">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h5>Total da Venda: R$ <span id="totalVenda">0.00</span></h5>
                            <input type="hidden" name="valorTotal" id="valorTotalInput" value="0.00">
                        </div>
                        <div class="col-md-6 text-end">
                            <a href="lista.jsp" class="btn btn-secondary">Cancelar</a>
                            <button type="submit" class="btn btn-primary">Finalizar Venda</button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // JavaScript para controle dos itens e cálculos
        document.addEventListener("DOMContentLoaded", function() {
            let itemCount = 1;

            // Adicionar novo item
            document.getElementById("adicionarItem").addEventListener("click", function() {
                const container = document.getElementById("itensContainer");
                const newItem = container.children[0].cloneNode(true);

                newItem.querySelectorAll("[name]").forEach(input => {
                    input.name = input.name.replace("[0]", `[${itemCount}]`);
                    input.value = "";
                });

                addItemEventListeners(newItem);
                container.appendChild(newItem);
                itemCount++;
            });

            function addItemEventListeners(item) {
                const livroSelect = item.querySelector(".livro-select");
                const quantidadeInput = item.querySelector(".quantidade-input");
                const precoInput = item.querySelector(".preco-input");
                const removerBtn = item.querySelector(".remover-item");

                livroSelect.addEventListener("change", function() {
                    const option = this.options[this.selectedIndex];
                    precoInput.value = option.getAttribute("data-preco");
                    atualizarTotal();
                });

                quantidadeInput.addEventListener("input", atualizarTotal);

                removerBtn.addEventListener("click", function() {
                    if (document.querySelectorAll(".item-venda").length > 1) {
                        item.remove();
                        atualizarTotal();
                    }
                });
            }

            function atualizarTotal() {
                let total = 0;
                document.querySelectorAll(".item-venda").forEach(item => {
                    const quantidade = parseFloat(item.querySelector(".quantidade-input").value) || 0;
                    const preco = parseFloat(item.querySelector(".preco-input").value) || 0;
                    total += quantidade * preco;
                });
                document.getElementById("totalVenda").textContent = total.toFixed(2);
                document.getElementById("valorTotalInput").value = total.toFixed(2);
            }

            // Adiciona eventos para o primeiro item
            addItemEventListeners(document.querySelector(".item-venda"));
        });
    </script>
</body>
</html>
