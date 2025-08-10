package com.dunnas.lucas.supplier_orders_api.application.dto;

import java.time.LocalDateTime;

public record TransactionHistoryDTO(Long id, Long orderId, String transationType, LocalDateTime transationDate, String clientName, String supplierName, String productName) {
    
}
