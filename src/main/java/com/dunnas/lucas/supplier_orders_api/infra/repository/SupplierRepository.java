package com.dunnas.lucas.supplier_orders_api.infra.repository;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.dunnas.lucas.supplier_orders_api.infra.entity.SupplierEntity;

public interface SupplierRepository extends JpaRepository<SupplierEntity, UUID> {
    
}
