package com.dunnas.lucas.supplier_orders_api.application.mapper;

import java.math.BigDecimal;

import com.dunnas.lucas.supplier_orders_api.application.dto.OrderCreateDTO;
import com.dunnas.lucas.supplier_orders_api.application.dto.OrderDTO;
import com.dunnas.lucas.supplier_orders_api.application.dto.OrderResponseDTO;
import com.dunnas.lucas.supplier_orders_api.infra.entity.OrderEntity;

public class OrderMapper {
    public static OrderEntity toEntity(OrderDTO orderDTO) {
        return new OrderEntity(
            orderDTO.id(),
            orderDTO.userId(),
            orderDTO.productId(),
            orderDTO.quant(),
            orderDTO.status()
        );
    }

    public static OrderEntity toEntity(OrderCreateDTO orderDTO) {
        return new OrderEntity(
            orderDTO.productId(),
            orderDTO.quant()
        );
    }

    public static OrderDTO toDto(OrderEntity orderEntity) {
        return new OrderDTO(
            orderEntity.getId(),
            orderEntity.getUserId(),
            orderEntity.getProductId(),
            orderEntity.getQuant(),
            orderEntity.getStatus()
        );
    }

    public static OrderCreateDTO createOrderToDto(OrderEntity orderEntity) {
        return new OrderCreateDTO(
            orderEntity.getProductId(),
            orderEntity.getQuant()
        );
    }

    public static OrderResponseDTO toDto(OrderEntity orderEntity, String productName, BigDecimal totalPrice) {
        return new OrderResponseDTO(
            orderEntity.getId(),
            orderEntity.getUserId(),
            orderEntity.getProductId(),
            orderEntity.getQuant(),
            orderEntity.getStatus(),
            productName,
            totalPrice
        );
    }

}
