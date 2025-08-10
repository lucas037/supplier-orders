package com.dunnas.lucas.supplier_orders_api.infra.repository;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.dunnas.lucas.supplier_orders_api.infra.entity.ClientEntity;

@Repository
public interface ClientRepository extends JpaRepository<ClientEntity, UUID> {
    
}
