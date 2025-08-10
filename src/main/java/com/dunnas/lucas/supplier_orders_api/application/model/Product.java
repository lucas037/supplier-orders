package com.dunnas.lucas.supplier_orders_api.application.model;

public class Product {
    private final Long id;
    private String name;
    private String description;
    private float price;

    public Product(Long id, String name, String description, float price) {
        this. id = id;
        this.name = name;
        this.description = description;
        this.price = price;
    }
}
