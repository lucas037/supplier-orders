package com.dunnas.lucas.supplier_orders_api.controller.exception;

import lombok.Getter;

@Getter
public class ItemNotFoundException extends RuntimeException {
    String errorMessage;

    public ItemNotFoundException(String errorMessage) {
        this.errorMessage = errorMessage;
    }
}
