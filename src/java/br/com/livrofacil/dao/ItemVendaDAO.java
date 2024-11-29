package br.com.livrofacil.dao;

import br.com.livrofacil.model.*;
import br.com.livrofacil.util.ConectaDB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ItemVendaDAO {
    private Connection connection;
    private LivroDAO livroDAO;

    public ItemVendaDAO() {
        this.connection = ConectaDB.getConnection();
        this.livroDAO = new LivroDAO();
    }

    public void salvar(ItemVenda item) {
        try {
            String sql = "INSERT INTO itens_venda (venda_id, livro_id, quantidade, preco_unitario) VALUES (?, ?, ?, ?)";
            PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setLong(1, item.getVenda().getId());
            stmt.setLong(2, item.getLivro().getId());
            stmt.setInt(3, item.getQuantidade());
            stmt.setDouble(4, item.getPrecoUnitario());
            stmt.executeUpdate();

            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                item.setId(rs.getLong(1));
            }
            
            // Atualiza o estoque do livro
            atualizarEstoqueLivro(item.getLivro().getId(), item.getQuantidade());
            
            stmt.close();
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao cadastrar item da venda", e);
        }
    }

    private void atualizarEstoqueLivro(Long livroId, int quantidade) {
        try {
            String sql = "UPDATE livros SET quantidade = quantidade - ? WHERE id = ?";
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, quantidade);
            stmt.setLong(2, livroId);
            stmt.executeUpdate();
            stmt.close();
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao atualizar estoque do livro", e);
        }
    }

    public List<ItemVenda> buscarPorVenda(Long vendaId) {
        try {
            List<ItemVenda> itens = new ArrayList<>();
            String sql = "SELECT * FROM itens_venda WHERE venda_id = ?";
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setLong(1, vendaId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                ItemVenda item = new ItemVenda();
                item.setId(rs.getLong("id"));
                item.setQuantidade(rs.getInt("quantidade"));
                item.setPrecoUnitario(rs.getDouble("preco_unitario"));
                
                // Busca o livro
                Livro livro = livroDAO.buscarPorId(rs.getLong("livro_id"));
                item.setLivro(livro);
                
                itens.add(item);
            }

            stmt.close();
            rs.close();
            return itens;
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao buscar itens da venda", e);
        }
    }
}
