package com.dunnas.lucas.supplier_orders_api.controller;

import com.dunnas.lucas.supplier_orders_api.application.dto.ProductDTO;
import com.dunnas.lucas.supplier_orders_api.application.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/product")
public class ProductController {
    @Autowired
    ProductService prodServ;

    @GetMapping
    public ResponseEntity<List<ProductDTO>> getAll() {
        List<ProductDTO> listProd = prodServ.getAll();
        return ResponseEntity.ok(listProd);
    }

    @GetMapping("/{id}")
    public ResponseEntity<ProductDTO> getById(@PathVariable Long id) {
        ProductDTO prod = prodServ.getById(id);
        return ResponseEntity.ok(prod);
    }
}
