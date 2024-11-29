package br.com.livrofacil.dao;

import java.sql.*;
import java.util.*;
import br.com.livrofacil.model.Cliente;
import br.com.livrofacil.util.ConectaDB;

public class ClienteDAO {
    
    public void salvar(Cliente cliente) {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = ConectaDB.getConnection();
            
            if (cliente.getId() == null) {
                stmt = conn.prepareStatement(
                    "INSERT INTO clientes (nome, email, cpf, telefone, endereco) VALUES (?, ?, ?, ?, ?)",
                    Statement.RETURN_GENERATED_KEYS
                );
            } else {
                stmt = conn.prepareStatement(
                    "UPDATE clientes SET nome = ?, email = ?, cpf = ?, telefone = ?, endereco = ? WHERE id = ?"
                );
            }
            
            stmt.setString(1, cliente.getNome());
            stmt.setString(2, cliente.getEmail());
            stmt.setString(3, cliente.getCpf());
            stmt.setString(4, cliente.getTelefone());
            stmt.setString(5, cliente.getEndereco());
            
            if (cliente.getId() != null) {
                stmt.setLong(6, cliente.getId());
            }
            
            stmt.executeUpdate();
            
            if (cliente.getId() == null) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    cliente.setId(rs.getLong(1));
                }
                rs.close();
            }
            
        } catch (Exception e) {
            throw new RuntimeException("Erro ao salvar cliente", e);
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                throw new RuntimeException("Erro ao fechar conexão", e);
            }
        }
    }
    
    public void excluir(Long id) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = ConectaDB.getConnection();
            
            // Primeiro verifica se o cliente tem vendas
            stmt = conn.prepareStatement("SELECT COUNT(*) FROM vendas WHERE cliente_id = ?");
            stmt.setLong(1, id);
            rs = stmt.executeQuery();
            rs.next();
            
            if (rs.getInt(1) > 0) {
                throw new RuntimeException("Não é possível excluir este cliente pois ele possui vendas registradas");
            }
            
            // Se não tiver vendas, pode excluir
            stmt = conn.prepareStatement("DELETE FROM clientes WHERE id = ?");
            stmt.setLong(1, id);
            stmt.executeUpdate();
            
        } catch (Exception e) {
            throw new RuntimeException("Erro ao excluir cliente: " + e.getMessage(), e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                throw new RuntimeException("Erro ao fechar conexão", e);
            }
        }
    }
    
    public Cliente buscarPorId(Long id) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = ConectaDB.getConnection();
            stmt = conn.prepareStatement("SELECT * FROM clientes WHERE id = ?");
            stmt.setLong(1, id);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                Cliente cliente = new Cliente();
                cliente.setId(rs.getLong("id"));
                cliente.setNome(rs.getString("nome"));
                cliente.setEmail(rs.getString("email"));
                cliente.setCpf(rs.getString("cpf"));
                cliente.setTelefone(rs.getString("telefone"));
                cliente.setEndereco(rs.getString("endereco"));
                return cliente;
            }
            
            return null;
        } catch (Exception e) {
            throw new RuntimeException("Erro ao buscar cliente", e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                throw new RuntimeException("Erro ao fechar conexão", e);
            }
        }
    }
    
    public List<Cliente> listar() {
        List<Cliente> clientes = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = ConectaDB.getConnection();
            stmt = conn.prepareStatement("SELECT * FROM clientes ORDER BY id ASC"); // Mudado para ASC
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Cliente cliente = new Cliente();
                cliente.setId(rs.getLong("id"));
                cliente.setNome(rs.getString("nome"));
                cliente.setEmail(rs.getString("email"));
                cliente.setCpf(rs.getString("cpf"));
                cliente.setTelefone(rs.getString("telefone"));
                cliente.setEndereco(rs.getString("endereco"));
                clientes.add(cliente);
            }
            
            return clientes;
        } catch (Exception e) {
            throw new RuntimeException("Erro ao listar clientes", e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                throw new RuntimeException("Erro ao fechar conexão", e);
            }
        }
    }
}
