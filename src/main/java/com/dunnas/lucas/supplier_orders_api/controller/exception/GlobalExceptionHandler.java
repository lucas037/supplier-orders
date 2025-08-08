package com.dunnas.lucas.supplier_orders_api.controller.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(ItemNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleItemNotFoundException(ItemNotFoundException ex) {
        ErrorResponse errorResp = new ErrorResponse(HttpStatus.NOT_FOUND.value(), ex.getErrorMessage());
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorResp);
    }
}
