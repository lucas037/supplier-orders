package com.dunnas.lucas.supplier_orders_api.controller.exception;

import java.time.format.DateTimeParseException;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.orm.jpa.JpaSystemException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;

@RestControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(ItemNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleItemNotFoundException(ItemNotFoundException ex) {
        ErrorResponse errorResp = new ErrorResponse(HttpStatus.NOT_FOUND.value(), ex.getErrorMessage());
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorResp);
    }

    @ExceptionHandler(NotAuthenticatedUser.class)
    public ResponseEntity<ErrorResponse> handleNotAuthenticatedUser(NotAuthenticatedUser ex) {
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
    public ResponseEntity<ErrorResponse> handleBadCredentialsException(BadCredentialsException ex) {
        ErrorResponse errorResp = new ErrorResponse(HttpStatus.UNAUTHORIZED.value(), ex.getMessage());
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorResp);
    }

    @ExceptionHandler(IllegalStateException.class)
    public ResponseEntity<ErrorResponse> handleIllegalStateException(IllegalStateException ex) {
        ErrorResponse errorResp = new ErrorResponse(HttpStatus.CONFLICT.value(), ex.getMessage());
        return ResponseEntity.status(HttpStatus.CONFLICT).body(errorResp);
    }

    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<ErrorResponse> handleIntegrityViolation(DataIntegrityViolationException ex) {
        Throwable cause = ex.getCause();
        while (cause != null) {
            if (cause instanceof org.hibernate.PropertyValueException pve) {
                return ResponseEntity
                        .status(HttpStatus.BAD_REQUEST)
                        .body(new ErrorResponse(
                                HttpStatus.BAD_REQUEST.value(),
                                "O campo '"+pve.getPropertyName()+"' é obrigatório"
                        ));
            }
            cause = cause.getCause();
        }

        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(new ErrorResponse(
                        HttpStatus.BAD_REQUEST.value(),
                        "Violação de integridade de dados"
                ));
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ErrorResponse> handleHttpMessageNotReadable(HttpMessageNotReadableException ex) {
        String mensagem = "JSON inválido ou mal formatado.";
        Throwable causa = ex.getCause();

        while (causa != null && !(causa instanceof JsonParseException) && !(causa instanceof JsonMappingException)) {
            causa = causa.getCause();
        }

        if (causa instanceof JsonParseException) {
            mensagem = "Erro de sintaxe no JSON.";
        } 
        else if (causa instanceof JsonMappingException) {
            Throwable raiz = causa.getCause();
            if (raiz instanceof DateTimeParseException) {
                mensagem = "Formato de data inválido. Use o padrão yyyy-MM-dd.";
            } else if (raiz instanceof NumberFormatException) {
                mensagem = "Valor numérico inválido no JSON.";
            } else {
                mensagem = "Erro ao mapear JSON para o objeto.";
            }
        }

        ErrorResponse erro = new ErrorResponse(
                HttpStatus.BAD_REQUEST.value(),
                mensagem
        );

        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(erro);
    }

    @ExceptionHandler(MinValueException.class)
    public ResponseEntity<ErrorResponse> handleMinValueException(MinValueException ex) {
        ErrorResponse error = new ErrorResponse(HttpStatus.BAD_REQUEST.value(), ex.getMessage());
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);
    }


}
