package com.dunnas.lucas.supplier_orders_api.infra.entity;

import java.util.UUID;

import com.dunnas.lucas.supplier_orders_api.domain.enums.OrderStatus;

import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "orders")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class OrderEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id;

    UUID userId;
    Long productId;
    int quant;
    
    @Enumerated(EnumType.STRING)
    OrderStatus status;

    public OrderEntity(Long productId, int quant) {
        this.productId = productId;
        this.quant = quant;
        status = OrderStatus.AGUARDANDO_PAGAMENTO;
    }
}
