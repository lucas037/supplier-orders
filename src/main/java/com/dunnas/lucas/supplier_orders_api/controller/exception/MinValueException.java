package com.dunnas.lucas.supplier_orders_api.controller.exception;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MinValueException extends RuntimeException {
    private final String name;
    private final int min;
    
    public MinValueException(String name, String classe, int min) {
        super(String.format("%s (%s) deve ser maior do que %d.", name, classe, min));
        this.name = name;
        this.min = min;
    }
}