package com.dunnas.lucas.supplier_orders_api.application.dto;

import java.math.BigDecimal;
import java.util.UUID;

public record ProductResponseDTO(Long id, UUID supplierId, String supplierName, String name, String description, BigDecimal price, BigDecimal discount) {
}
