package com.dunnas.lucas.supplier_orders_api.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.dunnas.lucas.supplier_orders_api.application.dto.SupplierDTO;
import com.dunnas.lucas.supplier_orders_api.application.service.SupplierService;

@RestController
@RequestMapping("/api/v1/supplier")
public class SupplierController {
    @Autowired
    SupplierService supplierServ;

    @RequestMapping("/register")
    public ResponseEntity<SupplierDTO> register(@RequestBody SupplierDTO supplierDTO) {
        SupplierDTO supplierResp = supplierServ.register(supplierDTO);
        return ResponseEntity.ok().body(supplierResp);
    }
}
