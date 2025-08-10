package com.dunnas.lucas.supplier_orders_api.application.dto;

import com.dunnas.lucas.supplier_orders_api.domain.enums.Role;

public record RegisterDTO(String name, String username, String password, Role role) {
    
}
