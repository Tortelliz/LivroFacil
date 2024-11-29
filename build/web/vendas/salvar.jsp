<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="br.com.livrofacil.model.*"%>
<%@page import="br.com.livrofacil.dao.*"%>
<%@page import="br.com.livrofacil.util.ConectaDB"%>

<%
    try {
        request.setCharacterEncoding("UTF-8");
        
        // 1. Criar venda
        Venda venda = new Venda();
        
        // 2. Cliente
        Long clienteId = Long.parseLong(request.getParameter("cliente.id"));
        ClienteDAO clienteDAO = new ClienteDAO();
        Cliente cliente = clienteDAO.buscarPorId(clienteId);
        venda.setCliente(cliente);
        
        // 3. Data e valor total
        venda.setDataVenda(new Date());
        venda.setValorTotal(Double.parseDouble(request.getParameter("valorTotal").replace(",", ".")));
        
        // 4. Itens
        List<ItemVenda> itens = new ArrayList<>();
        LivroDAO livroDAO = new LivroDAO();
        
        int i = 0;
        String livroIdParam = request.getParameter("itens[" + i + "].livro.id");
        
        while(livroIdParam != null && !livroIdParam.isEmpty()) {
            ItemVenda item = new ItemVenda();
            
            // Buscar livro
            Long livroId = Long.parseLong(livroIdParam);
            Livro livro = livroDAO.buscarPorId(livroId);
            item.setLivro(livro);
            
            // Quantidade e preço
            int quantidade = Integer.parseInt(request.getParameter("itens[" + i + "].quantidade"));
            double precoUnitario = Double.parseDouble(request.getParameter("itens[" + i + "].precoUnitario").replace(",", "."));
            
            // Verificar estoque
            if (livro.getQuantidade() < quantidade) {
                session.setAttribute("erro", "Estoque insuficiente para o livro: " + livro.getTitulo());
                response.sendRedirect("form.jsp");
                return;
            }
            
            item.setQuantidade(quantidade);
            item.setPrecoUnitario(precoUnitario);
            item.setSubtotal(quantidade * precoUnitario);
            
            itens.add(item);
            i++;
            livroIdParam = request.getParameter("itens[" + i + "].livro.id");
        }
        
        if (itens.isEmpty()) {
            session.setAttribute("erro", "A venda deve ter pelo menos um item");
            response.sendRedirect("form.jsp");
            return;
        }
        
        venda.setItens(itens);
        
        // 5. Salvar venda
        VendaDAO vendaDAO = new VendaDAO();
        vendaDAO.salvar(venda);
        
        // 6. Redirecionar com sucesso
        session.setAttribute("sucesso", "Venda realizada com sucesso!");
        response.sendRedirect("lista.jsp");
        
    } catch(Exception e) {
        e.printStackTrace();
        session.setAttribute("erro", "Erro ao realizar venda: " + e.getMessage());
        response.sendRedirect("form.jsp");
    }
%>
