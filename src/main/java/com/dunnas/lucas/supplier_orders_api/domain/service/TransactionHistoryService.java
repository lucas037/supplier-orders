package com.dunnas.lucas.supplier_orders_api.domain.service;

import java.util.List;
import java.util.Objects;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import com.dunnas.lucas.supplier_orders_api.application.dto.TransactionHistoryDTO;
import com.dunnas.lucas.supplier_orders_api.application.mapper.TransactionHistoryMapper;
import com.dunnas.lucas.supplier_orders_api.controller.exception.ItemNotFoundException;
import com.dunnas.lucas.supplier_orders_api.infra.entity.OrderEntity;
import com.dunnas.lucas.supplier_orders_api.infra.entity.ProductEntity;
import com.dunnas.lucas.supplier_orders_api.infra.entity.TransactionHistoryEntity;
import com.dunnas.lucas.supplier_orders_api.infra.entity.UserEntity;
import com.dunnas.lucas.supplier_orders_api.infra.repository.OrderRepository;
import com.dunnas.lucas.supplier_orders_api.infra.repository.ProductRepository;
import com.dunnas.lucas.supplier_orders_api.infra.repository.TransactionHistoryRepository;
import com.dunnas.lucas.supplier_orders_api.infra.repository.UserRepository;

@Service
public class TransactionHistoryService {
    @Autowired
    TransactionHistoryRepository transactionsRepo;
    @Autowired
    OrderRepository orderRepo;
    @Autowired
    UserRepository userRepo;
    @Autowired
    ProductRepository productRepo;

    public TransactionHistoryDTO get(Long id) {
        TransactionHistoryEntity transaction = transactionsRepo.findById(id)
            .orElseThrow(() -> new ItemNotFoundException("Transação não existe."));

        Long orderId = transaction.getOrderId();
        OrderEntity order = orderRepo.findById(orderId)
            .orElseThrow(() -> new ItemNotFoundException("Compra não existe."));

        UUID userId = order.getUserId();
        UserEntity user = userRepo.findById(userId)
            .orElseThrow(() -> new ItemNotFoundException("Usuário não existe."));

        Long productId = order.getProductId();
        ProductEntity product = productRepo.findById(productId)
            .orElseThrow(() -> new ItemNotFoundException("Produto não existe."));

        UUID supplierId = product.getSupplierId();
        UserEntity supplier = userRepo.findById(supplierId)
            .orElseThrow(() -> new ItemNotFoundException("Usuário não existe."));

        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        if (!username.equals(supplier.getUsername()) && !username.equals(user.getUsername()))
            return null;

        TransactionHistoryDTO transactionDto = TransactionHistoryMapper.toDto(transaction, user.getName(), supplier.getName(), product.getName());
        
        return transactionDto;
    }

    public List<TransactionHistoryDTO> getAll() {
        List<TransactionHistoryEntity> transactions = transactionsRepo.findAll();

        List<TransactionHistoryDTO> dtos = transactions.stream()
            .map(t -> get(t.getId()))
            .filter(Objects::nonNull)
            .toList();

            
        return dtos;
    }
}
