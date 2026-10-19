package com.codegym.dao;

import com.codegym.model.Product;

import java.util.List;

public interface IProductDAO {
    List<Product> selectAllProducts();

    Product selectProduct(int id);

    void insertProduct(Product product) throws Exception;

    boolean updateProduct(Product product) throws Exception;

    boolean deleteProduct(int id) throws Exception;

    List<Product> searchByName(String keyword);
}
