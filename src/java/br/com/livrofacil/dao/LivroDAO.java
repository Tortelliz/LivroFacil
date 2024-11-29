package br.com.livrofacil.dao;

import java.sql.*;
import java.util.*;
import br.com.livrofacil.model.Livro;
import br.com.livrofacil.util.ConectaDB;

public class LivroDAO {
    
    public void salvar(Livro livro) {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = ConectaDB.getConnection();
            
            if (livro.getId() == null) {
                stmt = conn.prepareStatement(
                    "INSERT INTO livros (titulo, autor, isbn, preco, quantidade) VALUES (?, ?, ?, ?, ?)",
                    Statement.RETURN_GENERATED_KEYS
                );
            } else {
                stmt = conn.prepareStatement(
                    "UPDATE livros SET titulo = ?, autor = ?, isbn = ?, preco = ?, quantidade = ? WHERE id = ?"
                );
            }
            
            stmt.setString(1, livro.getTitulo());
            stmt.setString(2, livro.getAutor());
            stmt.setString(3, livro.getIsbn());
            stmt.setDouble(4, livro.getPreco());
            stmt.setInt(5, livro.getQuantidade());
            
            if (livro.getId() != null) {
                stmt.setLong(6, livro.getId());
            }
            
            stmt.executeUpdate();
            
            if (livro.getId() == null) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    livro.setId(rs.getLong(1));
                }
                rs.close();
            }
            
        } catch (Exception e) {
            throw new RuntimeException("Erro ao salvar livro", e);
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
            
            // Primeiro verifica se o livro está em alguma venda
            stmt = conn.prepareStatement("SELECT COUNT(*) FROM itens_venda WHERE livro_id = ?");
            stmt.setLong(1, id);
            rs = stmt.executeQuery();
            rs.next();
            
            if (rs.getInt(1) > 0) {
                throw new RuntimeException("Não é possível excluir este livro pois ele está em uma ou mais vendas");
            }
            
            // Se não estiver em nenhuma venda, pode excluir
            stmt = conn.prepareStatement("DELETE FROM livros WHERE id = ?");
            stmt.setLong(1, id);
            stmt.executeUpdate();
            
        } catch (Exception e) {
            throw new RuntimeException("Erro ao excluir livro: " + e.getMessage(), e);
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
    
    public Livro buscarPorId(Long id) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = ConectaDB.getConnection();
            stmt = conn.prepareStatement("SELECT * FROM livros WHERE id = ?");
            stmt.setLong(1, id);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                Livro livro = new Livro();
                livro.setId(rs.getLong("id"));
                livro.setTitulo(rs.getString("titulo"));
                livro.setAutor(rs.getString("autor"));
                livro.setIsbn(rs.getString("isbn"));
                livro.setPreco(rs.getDouble("preco"));
                livro.setQuantidade(rs.getInt("quantidade"));
                return livro;
            }
            
            return null;
        } catch (Exception e) {
            throw new RuntimeException("Erro ao buscar livro", e);
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
    
    public List<Livro> listar() {
        List<Livro> livros = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = ConectaDB.getConnection();
            stmt = conn.prepareStatement("SELECT * FROM livros ORDER BY id ASC"); // Mudado para ASC
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Livro livro = new Livro();
                livro.setId(rs.getLong("id"));
                livro.setTitulo(rs.getString("titulo"));
                livro.setAutor(rs.getString("autor"));
                livro.setIsbn(rs.getString("isbn"));
                livro.setPreco(rs.getDouble("preco"));
                livro.setQuantidade(rs.getInt("quantidade"));
                livros.add(livro);
            }
            
            return livros;
        } catch (Exception e) {
            throw new RuntimeException("Erro ao listar livros", e);
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
