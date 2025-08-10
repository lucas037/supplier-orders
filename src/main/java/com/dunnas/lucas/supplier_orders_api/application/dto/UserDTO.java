package com.dunnas.lucas.supplier_orders_api.application.dto;

import java.util.UUID;

import com.dunnas.lucas.supplier_orders_api.domain.enums.Role;

public record UserDTO(UUID id, String name, String username, Role role) {
    
}
