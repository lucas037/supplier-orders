package com.dunnas.lucas.supplier_orders_api.domain.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import com.dunnas.lucas.supplier_orders_api.application.dto.OrderCreateDTO;
import com.dunnas.lucas.supplier_orders_api.application.dto.OrderDTO;
import com.dunnas.lucas.supplier_orders_api.application.mapper.OrderMapper;
import com.dunnas.lucas.supplier_orders_api.infra.entity.OrderEntity;
import com.dunnas.lucas.supplier_orders_api.infra.entity.UserEntity;
import com.dunnas.lucas.supplier_orders_api.infra.repository.OrderRepository;
import com.dunnas.lucas.supplier_orders_api.infra.repository.UserRepository;

@Service
public class OrderService {
    @Autowired
    OrderRepository orderRepo;
    @Autowired
    UserRepository userRepo;

    public OrderDTO create(OrderCreateDTO orderDTO) {
        OrderEntity orderEntity = OrderMapper.toEntity(orderDTO);

        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        UserEntity user = userRepo.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

        orderEntity.setUserId(user.getId());

        OrderEntity savedOrder = orderRepo.save(orderEntity);

        return OrderMapper.toDto(savedOrder);
    }
}
