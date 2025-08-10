package com.dunnas.lucas.supplier_orders_api.infra.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.dunnas.lucas.supplier_orders_api.infra.entity.OrderEntity;

public interface OrderRepository extends JpaRepository<OrderEntity, Long> {
    
}
