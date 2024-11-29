<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="br.com.livrofacil.model.Cliente"%>
<%@page import="br.com.livrofacil.dao.ClienteDAO"%>

<%
    // Configurando a codificação dos parâmetros
    request.setCharacterEncoding("UTF-8");
    
    // Criando objeto Cliente com os dados do formulário
    Cliente cliente = new Cliente();
    
    // Verifica se é uma edição (se tem ID)
    String idStr = request.getParameter("id");
    if (idStr != null && !idStr.isEmpty()) {
        cliente.setId(Long.parseLong(idStr));
    }
    
    // Setando os dados do formulário
    cliente.setNome(request.getParameter("nome"));
    cliente.setEmail(request.getParameter("email"));
    cliente.setCpf(request.getParameter("cpf"));
    cliente.setTelefone(request.getParameter("telefone"));
    cliente.setEndereco(request.getParameter("endereco"));
    
    try {
        // Salvando no banco
        ClienteDAO dao = new ClienteDAO();
        dao.salvar(cliente);
        
        // Redirecionando para a lista com mensagem de sucesso
        response.sendRedirect("lista.jsp?success=true");
        
    } catch (Exception e) {
        // Em caso de erro, redireciona com mensagem de erro
        e.printStackTrace();
        response.sendRedirect("form.jsp?error=true");
    }
%>
