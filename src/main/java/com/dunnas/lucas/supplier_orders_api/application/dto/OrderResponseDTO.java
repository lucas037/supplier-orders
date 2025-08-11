package com.dunnas.lucas.supplier_orders_api.application.dto;

import java.math.BigDecimal;
import java.util.UUID;

import com.dunnas.lucas.supplier_orders_api.domain.enums.OrderStatus;

public record OrderResponseDTO(Long id, UUID userId, Long productId, int quant, OrderStatus status, String productName, BigDecimal price, BigDecimal discount) {
    
}
