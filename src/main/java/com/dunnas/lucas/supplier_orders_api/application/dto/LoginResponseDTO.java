package com.dunnas.lucas.supplier_orders_api.application.dto;

import com.dunnas.lucas.supplier_orders_api.domain.enums.Role;

public record LoginResponseDTO(String token, Role role) {
    
}
