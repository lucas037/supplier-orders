package com.dunnas.lucas.supplier_orders_api.application.dto;

import java.math.BigDecimal;

public record ProductDTO(Long id, String name, String description, BigDecimal price) {
}
