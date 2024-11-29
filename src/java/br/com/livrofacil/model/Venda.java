package br.com.livrofacil.model;

import java.util.Date;
import java.util.List;
import java.util.ArrayList;

public class Venda {
    private Long id;
    private Cliente cliente;
    private Date dataVenda;
    private double valorTotal;
    private List<ItemVenda> itens;

    public Venda() {
        this.dataVenda = new Date();
        this.itens = new ArrayList<>();
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Cliente getCliente() {
        return cliente;
    }

    public void setCliente(Cliente cliente) {
        this.cliente = cliente;
    }

    public Date getDataVenda() {
        return dataVenda;
    }

    public void setDataVenda(Date dataVenda) {
        this.dataVenda = dataVenda;
    }

    public double getValorTotal() {
        return valorTotal;
    }

    public void setValorTotal(double valorTotal) {
        this.valorTotal = valorTotal;
    }

    public List<ItemVenda> getItens() {
        return itens;
    }

    public void setItens(List<ItemVenda> itens) {
        this.itens = itens;
    }

    public void addItem(ItemVenda item) {
        this.itens.add(item);
        calcularValorTotal();
    }

    private void calcularValorTotal() {
        this.valorTotal = 0;
        for (ItemVenda item : itens) {
            this.valorTotal += item.getSubtotal();
        }
    }
}
