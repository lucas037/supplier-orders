package com.dunnas.lucas.supplier_orders_api.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.dunnas.lucas.supplier_orders_api.application.dto.TransactionHistoryDTO;
import com.dunnas.lucas.supplier_orders_api.domain.service.TransactionHistoryService;

@RestController
@RequestMapping("api/v1/transaction")
public class TransactionHistoryController {
    @Autowired
    TransactionHistoryService transationServ;

    @GetMapping("/{id}")
    public ResponseEntity<TransactionHistoryDTO> get(@PathVariable Long id) {
        TransactionHistoryDTO dto = transationServ.get(id);
        return ResponseEntity.ok().body(dto);
    }
}
