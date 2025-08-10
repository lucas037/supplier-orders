package com.dunnas.lucas.supplier_orders_api.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
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

    @RequestMapping("/create")
    public ResponseEntity<OrderDTO> create(@RequestBody OrderCreateDTO orderCreateDTO) {
        OrderDTO createdOrder =orderServ.create(orderCreateDTO);
        return ResponseEntity.ok().body(createdOrder);
    }
}
