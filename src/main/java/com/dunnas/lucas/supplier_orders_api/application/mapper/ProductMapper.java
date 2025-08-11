package com.dunnas.lucas.supplier_orders_api.application.mapper;

import java.math.BigDecimal;

import com.dunnas.lucas.supplier_orders_api.application.dto.ProductCreateDTO;
import com.dunnas.lucas.supplier_orders_api.application.dto.ProductDTO;
import com.dunnas.lucas.supplier_orders_api.infra.entity.ProductEntity;

public class ProductMapper {
    public static ProductDTO toDto(ProductEntity entity) {
        return new ProductDTO(
            entity.getId(),
            entity.getSupplierId(),
            entity.getName(),
            entity.getDescription(),
            entity.getPrice(),
            entity.getDiscount() 
        );
    }
    
    public static ProductCreateDTO prodCreateToDto(ProductEntity entity) {
        return new ProductCreateDTO(
            entity.getId(),
            entity.getName(),
            entity.getDescription(),
            entity.getPrice(),
            entity.getDiscount()
        );
    }

    public static ProductEntity toEntity(ProductDTO dto) {
        return new ProductEntity(
            dto.id(),
            dto.supplierId(),
            dto.name(),
            dto.description(),
            dto.price(),
            dto.discount()
        );
    }

    public static ProductEntity toEntity(ProductCreateDTO dto) {
        return new ProductEntity(
            dto.id(),
            null,
            dto.name(),
            dto.description(),
            dto.price(),
            dto.discount()
        );
    }
}
