<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="br.com.livrofacil.model.Livro"%>
<%@page import="br.com.livrofacil.dao.LivroDAO"%>

<%
    try {
        // Configurando a codificação dos parâmetros
        request.setCharacterEncoding("UTF-8");
        
        // Criando objeto Livro com os dados do formulário
        Livro livro = new Livro();
        
        // Verifica se é uma edição (se tem ID)
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            livro.setId(Long.parseLong(idStr));
        }
        
        // Setando os dados do formulário
        livro.setTitulo(request.getParameter("titulo"));
        livro.setAutor(request.getParameter("autor"));
        livro.setIsbn(request.getParameter("isbn"));
        livro.setPreco(Double.parseDouble(request.getParameter("preco")));
        livro.setQuantidade(Integer.parseInt(request.getParameter("quantidade")));
        
        // Salvando no banco
        LivroDAO dao = new LivroDAO();
        dao.salvar(livro);
        
        // Redirecionando para a lista com mensagem de sucesso
        response.sendRedirect("lista.jsp?success=true&message=Livro salvo com sucesso!");
        
    } catch (Exception e) {
        // Em caso de erro, redireciona com mensagem de erro
        e.printStackTrace();
        response.sendRedirect("form.jsp?error=true&message=Erro ao salvar livro: " + e.getMessage());
    }
%>
