package com.dunnas.lucas.supplier_orders_api.controller.exception;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ErrorResponse {
    private String message;
    private int status;
    private LocalDateTime timestamp = LocalDateTime.now();

    public ErrorResponse(int status) {
        this.status = status;
        this.message = "";
    }

    public ErrorResponse(int status, String message) {
        this.message = message;
        this.status = status;
    }
}
