package com.dunnas.lucas.supplier_orders_api.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.dunnas.lucas.supplier_orders_api.application.dto.OrderCreateDTO;
import com.dunnas.lucas.supplier_orders_api.application.dto.OrderDTO;
import com.dunnas.lucas.supplier_orders_api.domain.service.OrderService;

@RestController
@RequestMapping("/api/v1/order")
public class OrderController {
    @Autowired
    OrderService orderServ;

    @RequestMapping()
    public ResponseEntity<List<OrderDTO>> getAll() {
        System.out.println("Iniciando pesquisa...");
        try {
            List<OrderDTO> dtos = orderServ.getAll();
            return ResponseEntity.ok().body(dtos);
        } catch (Exception e) {
            System.err.println("OrderController.getAll() - Erro: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    @RequestMapping("/create")
    public ResponseEntity<OrderDTO> create(@RequestBody OrderCreateDTO orderCreateDTO) {
        OrderDTO createdOrder = orderServ.create(orderCreateDTO);
        return ResponseEntity.ok().body(createdOrder);
    }

    @RequestMapping("/update")
    public ResponseEntity<OrderDTO> update(@RequestBody OrderDTO orderDTO) {
        OrderDTO savedOrder = orderServ.update(orderDTO);
        return ResponseEntity.ok().body(savedOrder);
    }
}
