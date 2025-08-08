package com.dunnas.lucas.supplier_orders_api.application.mapper;

import com.dunnas.lucas.supplier_orders_api.application.dto.ProductDTO;
import com.dunnas.lucas.supplier_orders_api.infra.entity.ProductEntity;

public class ProductMapper {
    public static ProductDTO toDto(ProductEntity entity) {
        return new ProductDTO(
            entity.getId(),
            entity.getName(),
            entity.getDescription(),
            entity.getPrice()    
        );
    }

    public static ProductEntity toEntity(ProductDTO dto) {
        return new ProductEntity(
            dto.id(),
            dto.name(),
            dto.description(),
            dto.price()
        );
    }
}
