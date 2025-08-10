package com.dunnas.lucas.supplier_orders_api.application.mapper;

import com.dunnas.lucas.supplier_orders_api.application.dto.TransactionHistoryDTO;
import com.dunnas.lucas.supplier_orders_api.infra.entity.TransactionHistoryEntity;

public class TransactionHistoryMapper {
    public static TransactionHistoryEntity toEntity(TransactionHistoryDTO dto) {
        return new TransactionHistoryEntity(
            dto.id(),
            dto.orderId(),
            dto.transationType(),
            dto.transationDate()
        );
    }

    public static TransactionHistoryDTO toDto(TransactionHistoryEntity entity, String clientName, String supplierName, String productName) {
        return new TransactionHistoryDTO(
            entity.getId(),
            entity.getOrderId(),
            entity.getTransationType(),
            entity.getTransationDate(),
            clientName,
            supplierName,
            productName
        );
    }
}
