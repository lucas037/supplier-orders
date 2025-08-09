package com.dunnas.lucas.supplier_orders_api.controller.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class NotAuthenticatedUser extends RuntimeException {
    private String errorMessage;
}
