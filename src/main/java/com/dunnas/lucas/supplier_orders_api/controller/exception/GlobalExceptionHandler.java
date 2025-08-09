package com.dunnas.lucas.supplier_orders_api.controller.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.orm.jpa.JpaSystemException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(ItemNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleItemNotFoundException(ItemNotFoundException ex) {
        ErrorResponse errorResp = new ErrorResponse(HttpStatus.NOT_FOUND.value(), ex.getErrorMessage());
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorResp);
    }

    @ExceptionHandler(JpaSystemException.class)
    public ResponseEntity<ErrorResponse> handleDataIntegrityViolation(JpaSystemException ex) {
        String fullMessage = ex.getRootCause() != null ? ex.getRootCause().getMessage() : ex.getMessage();

        String cleanMessage = fullMessage.split("\n")[0].replace("ERRO: ", "").trim();

        ErrorResponse errorResp = new ErrorResponse(
            HttpStatus.BAD_REQUEST.value(),
            cleanMessage
        );

        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(errorResp);
    }

    @ExceptionHandler(BadCredentialsException.class)
    public ResponseEntity<ErrorResponse> badCredentialsException(BadCredentialsException ex) {
        ErrorResponse errorResp = new ErrorResponse(HttpStatus.UNAUTHORIZED.value(), "Usuário ou senha incorretos");
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorResp);
    }


}
