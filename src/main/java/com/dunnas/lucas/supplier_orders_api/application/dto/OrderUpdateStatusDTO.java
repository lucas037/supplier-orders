package com.dunnas.lucas.supplier_orders_api.application.dto;

import com.dunnas.lucas.supplier_orders_api.domain.enums.OrderStatus;

public record OrderUpdateStatusDTO(Long id, OrderStatus status) {
    
}
