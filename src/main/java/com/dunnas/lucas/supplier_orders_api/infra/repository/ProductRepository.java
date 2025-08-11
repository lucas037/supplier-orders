package com.dunnas.lucas.supplier_orders_api.infra.repository;

import java.util.UUID;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.dunnas.lucas.supplier_orders_api.infra.entity.ProductEntity;

public interface ProductRepository extends JpaRepository<ProductEntity, Long> {
    List<ProductEntity> findBySupplierId(UUID supplierId);
}