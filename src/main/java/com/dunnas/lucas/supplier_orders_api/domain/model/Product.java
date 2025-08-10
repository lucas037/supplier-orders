package com.dunnas.lucas.supplier_orders_api.domain.model;

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

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public float getPrice() {
        return price;
    }

    public void setPrice(float price) {
        this.price = price;
    }
}
