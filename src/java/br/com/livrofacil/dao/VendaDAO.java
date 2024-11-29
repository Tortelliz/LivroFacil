package br.com.livrofacil.dao;

import java.sql.*;
import java.util.*;
import br.com.livrofacil.model.*;
import br.com.livrofacil.util.ConectaDB;

public class VendaDAO {
    
    public void salvar(Venda venda) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = ConectaDB.getConnection();
            conn.setAutoCommit(false);
            
            // 1. Insere a venda
            stmt = conn.prepareStatement(
                "INSERT INTO vendas (cliente_id, data_venda, valor_total) VALUES (?, ?, ?)",
                Statement.RETURN_GENERATED_KEYS
            );
            
            stmt.setLong(1, venda.getCliente().getId());
            stmt.setTimestamp(2, new Timestamp(venda.getDataVenda().getTime()));
            stmt.setDouble(3, venda.getValorTotal());
            stmt.executeUpdate();
            
            rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                venda.setId(rs.getLong(1));
            }
            
            // 2. Insere os itens da venda
            for (ItemVenda item : venda.getItens()) {
                stmt = conn.prepareStatement(
                    "INSERT INTO itens_venda (venda_id, livro_id, quantidade, preco_unitario, subtotal) VALUES (?, ?, ?, ?, ?)"
                );
                
                stmt.setLong(1, venda.getId());
                stmt.setLong(2, item.getLivro().getId());
                stmt.setInt(3, item.getQuantidade());
                stmt.setDouble(4, item.getPrecoUnitario());
                stmt.setDouble(5, item.getSubtotal());
                stmt.executeUpdate();
                
                // 3. Atualiza o estoque do livro
                stmt = conn.prepareStatement(
                    "UPDATE livros SET quantidade = quantidade - ? WHERE id = ?"
                );
                stmt.setInt(1, item.getQuantidade());
                stmt.setLong(2, item.getLivro().getId());
                stmt.executeUpdate();
            }
            
            conn.commit();
            
        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                throw new RuntimeException("Erro ao desfazer transação", ex);
            }
            throw new RuntimeException("Erro ao salvar venda", e);
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
    
    public List<Venda> listar() {
        List<Venda> vendas = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = ConectaDB.getConnection();
            stmt = conn.prepareStatement(
                "SELECT v.*, c.nome as cliente_nome FROM vendas v " +
                "INNER JOIN clientes c ON v.cliente_id = c.id " +
                "ORDER BY v.id ASC"
            );
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Venda venda = new Venda();
                venda.setId(rs.getLong("id"));
                venda.setDataVenda(rs.getTimestamp("data_venda"));
                venda.setValorTotal(rs.getDouble("valor_total"));
                
                Cliente cliente = new Cliente();
                cliente.setId(rs.getLong("cliente_id"));
                cliente.setNome(rs.getString("cliente_nome"));
                venda.setCliente(cliente);
                
                venda.setItens(buscarItensPorVenda(venda.getId()));
                vendas.add(venda);
            }
            
            return vendas;
        } catch (Exception e) {
            throw new RuntimeException("Erro ao listar vendas", e);
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
    
    public Venda buscarPorId(Long id) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = ConectaDB.getConnection();
            stmt = conn.prepareStatement(
                "SELECT v.*, c.nome as cliente_nome FROM vendas v " +
                "INNER JOIN clientes c ON v.cliente_id = c.id " +
                "WHERE v.id = ?"
            );
            
            stmt.setLong(1, id);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                Venda venda = new Venda();
                venda.setId(rs.getLong("id"));
                venda.setDataVenda(rs.getTimestamp("data_venda"));
                venda.setValorTotal(rs.getDouble("valor_total"));
                
                Cliente cliente = new Cliente();
                cliente.setId(rs.getLong("cliente_id"));
                cliente.setNome(rs.getString("cliente_nome"));
                venda.setCliente(cliente);
                
                venda.setItens(buscarItensPorVenda(venda.getId()));
                return venda;
            }
            
            return null;
        } catch (Exception e) {
            throw new RuntimeException("Erro ao buscar venda", e);
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
    
    private List<ItemVenda> buscarItensPorVenda(Long vendaId) {
        List<ItemVenda> itens = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = ConectaDB.getConnection();
            stmt = conn.prepareStatement(
                "SELECT i.*, l.titulo as livro_titulo FROM itens_venda i " +
                "INNER JOIN livros l ON i.livro_id = l.id " +
                "WHERE i.venda_id = ? " +
                "ORDER BY i.id ASC"
            );
            
            stmt.setLong(1, vendaId);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                ItemVenda item = new ItemVenda();
                item.setQuantidade(rs.getInt("quantidade"));
                item.setPrecoUnitario(rs.getDouble("preco_unitario"));
                item.setSubtotal(rs.getDouble("subtotal"));
                
                Livro livro = new Livro();
                livro.setId(rs.getLong("livro_id"));
                livro.setTitulo(rs.getString("livro_titulo"));
                item.setLivro(livro);
                
                itens.add(item);
            }
            
            return itens;
        } catch (Exception e) {
            throw new RuntimeException("Erro ao buscar itens da venda", e);
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
