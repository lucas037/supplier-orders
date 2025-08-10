package com.dunnas.lucas.supplier_orders_api.application.dto;

import java.math.BigDecimal;
import java.util.UUID;

public record ProductDTO(Long id, UUID supplierId, String name, String description, BigDecimal price) {
}
