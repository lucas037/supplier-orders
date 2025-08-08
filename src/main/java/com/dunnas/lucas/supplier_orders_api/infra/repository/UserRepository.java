package com.dunnas.lucas.supplier_orders_api.infra.repository;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.dunnas.lucas.supplier_orders_api.infra.entity.UserEntity;

public interface UserRepository extends JpaRepository <UserEntity, UUID> {
    Optional<UserEntity> findByUsername(String username);
}
