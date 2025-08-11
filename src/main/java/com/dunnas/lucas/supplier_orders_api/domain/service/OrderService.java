package com.dunnas.lucas.supplier_orders_api.domain.service;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import com.dunnas.lucas.supplier_orders_api.application.dto.OrderCreateDTO;
import com.dunnas.lucas.supplier_orders_api.application.dto.OrderDTO;
import com.dunnas.lucas.supplier_orders_api.application.dto.OrderResponseDTO;
import com.dunnas.lucas.supplier_orders_api.application.mapper.OrderMapper;
import com.dunnas.lucas.supplier_orders_api.domain.enums.OrderStatus;
import com.dunnas.lucas.supplier_orders_api.infra.entity.OrderEntity;
import com.dunnas.lucas.supplier_orders_api.infra.entity.ProductEntity;
import com.dunnas.lucas.supplier_orders_api.infra.entity.UserEntity;
import com.dunnas.lucas.supplier_orders_api.infra.repository.OrderRepository;
import com.dunnas.lucas.supplier_orders_api.infra.repository.UserRepository;

@Service
public class OrderService {
    @Autowired
    OrderRepository orderRepo;
    @Autowired
    UserRepository userRepo;
    @Autowired
    ProductService productServ;

    public List<OrderResponseDTO> getAll() {
        try {
            String username = SecurityContextHolder.getContext().getAuthentication().getName();
            
            UserEntity user = userRepo.findByUsername(username)
                    .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

            List<OrderEntity> orders = orderRepo.findAllByUserId(user.getId());
            
            List<OrderResponseDTO> dtos = orders.stream()
                .filter(o -> OrderStatus.AGUARDANDO_PAGAMENTO.equals(o.getStatus()))
                .map(o -> {
                    ProductEntity product = productServ.getProduct(o.getProductId());
                    return OrderMapper.toDto(o, product.getName(), product.getPrice(), product.getDiscount());
                })
                .toList();

            return dtos;


        } catch (Exception e) {
            System.err.println("OrderService.getAll() - Erro: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    public OrderDTO create(OrderCreateDTO orderDTO) {
        OrderEntity orderEntity = OrderMapper.toEntity(orderDTO);

        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        UserEntity user = userRepo.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

        orderEntity.setUserId(user.getId());

        OrderEntity savedOrder = orderRepo.save(orderEntity);

        return OrderMapper.toDto(savedOrder);
    }

    public OrderDTO update(OrderDTO orderDTO) {
        OrderEntity order = orderRepo.findById(orderDTO.id())
            .orElseThrow(() -> new RuntimeException("Pedido não encontrado"));

        if (orderDTO.status() != null)
            order.setStatus(orderDTO.status());

        if (orderDTO.quant() >= 0 && orderDTO.quant() != order.getQuant())
            order.setQuant(orderDTO.quant());

        OrderEntity savedOrder = orderRepo.save(order);

        return OrderMapper.toDto(savedOrder);

    }
}
