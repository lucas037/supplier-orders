package com.dunnas.lucas.supplier_orders_api.domain.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dunnas.lucas.supplier_orders_api.application.dto.TransactionHistoryDTO;
import com.dunnas.lucas.supplier_orders_api.application.mapper.TransactionHistoryMapper;
import com.dunnas.lucas.supplier_orders_api.controller.exception.ItemNotFoundException;
import com.dunnas.lucas.supplier_orders_api.infra.entity.TransactionHistoryEntity;
import com.dunnas.lucas.supplier_orders_api.infra.repository.TransactionHistoryRepository;

@Service
public class TransactionHistoryService {
    @Autowired
    TransactionHistoryRepository transactionsRepo;

    public TransactionHistoryDTO get(Long id) {
        TransactionHistoryEntity transaction = transactionsRepo.findById(id)
            .orElseThrow(() -> new ItemNotFoundException("Transação não existe não existe."));
        
        return TransactionHistoryMapper.toDto(transaction);
    }
}
