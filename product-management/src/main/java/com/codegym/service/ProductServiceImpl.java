package com.codegym.service;

import com.codegym.model.Product;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProductServiceImpl implements ProductService {
    private static final Map<Integer, Product> products;

    static {
        products = new HashMap<>();
        products.put(1, new Product(1, "iPhone 15 Pro", 999.0, "Titanium design, A17 Pro chip, Action button", "Apple"));
        products.put(2, new Product(2, "Samsung Galaxy S24 Ultra", 1199.0, "Galaxy AI, Snapdragon 8 Gen 3, S-Pen included", "Samsung"));
        products.put(3, new Product(3, "Sony WH-1000XM5", 399.0, "Industry leading noise canceling headphones", "Sony"));
        products.put(4, new Product(4, "MacBook Pro 14", 1999.0, "M3 Pro chip, Liquid Retina XDR display", "Apple"));
        products.put(5, new Product(5, "Dell XPS 15", 1499.0, "OLED InfinityEdge display, Intel Core i7", "Dell"));
        products.put(6, new Product(6, "Xiaomi 14 Ultra", 899.0, "Leica quad camera system, 120Hz AMOLED", "Xiaomi"));
    }

    @Override
    public List<Product> findAll() {
        return new ArrayList<>(products.values());
    }

    @Override
    public void save(Product product) {
        products.put(product.getId(), product);
    }

    @Override
    public Product findById(int id) {
        return products.get(id);
    }

    @Override
    public void update(int id, Product product) {
        products.put(id, product);
    }

    @Override
    public void remove(int id) {
        products.remove(id);
    }

    @Override
    public List<Product> findByName(String name) {
        List<Product> result = new ArrayList<>();
        if (name == null || name.trim().isEmpty()) {
            return findAll();
        }
        String keyword = name.trim().toLowerCase();
        for (Product product : products.values()) {
            if (product.getName() != null && product.getName().toLowerCase().contains(keyword)) {
                result.add(product);
            }
        }
        return result;
    }
}
