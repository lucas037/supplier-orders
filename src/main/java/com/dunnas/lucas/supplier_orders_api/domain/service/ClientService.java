package com.dunnas.lucas.supplier_orders_api.domain.service;

import java.math.BigDecimal;
import java.util.UUID;

import javax.management.RuntimeErrorException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import com.dunnas.lucas.supplier_orders_api.application.dto.BalanceResponseDTO;
import com.dunnas.lucas.supplier_orders_api.application.dto.ClientDTO;
import com.dunnas.lucas.supplier_orders_api.application.dto.DepositDTO;
import com.dunnas.lucas.supplier_orders_api.application.mapper.ClientMapper;
import com.dunnas.lucas.supplier_orders_api.controller.exception.MinValueException;
import com.dunnas.lucas.supplier_orders_api.infra.entity.ClientEntity;
import com.dunnas.lucas.supplier_orders_api.infra.entity.UserEntity;
import com.dunnas.lucas.supplier_orders_api.infra.repository.ClientRepository;
import com.dunnas.lucas.supplier_orders_api.infra.repository.UserRepository;

@Service
public class ClientService {
    @Autowired
    ClientRepository clientRepo;
    @Autowired
    UserRepository userRepo;

    public ClientDTO register(ClientDTO clientDTO) {
        ClientEntity clientEntity = ClientMapper.toEntity(clientDTO);
        ClientEntity clientSaved = clientRepo.save(clientEntity);
        return ClientMapper.toDTO(clientSaved);
    }

    public ClientDTO deposit(DepositDTO depositDTO) {
        if (depositDTO.value().compareTo(BigDecimal.valueOf(10.0)) < 0) {
            throw new MinValueException("Depósito", "Cliente", 10);
        }


        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        UserEntity user = userRepo.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

        UUID userId = user.getId();
        ClientEntity client = clientRepo.findById(userId)
                .orElseThrow(() -> new RuntimeException("Cliente não encontrado"));

        BigDecimal newValue = client.getBalance().add(depositDTO.value());
        client.setBalance(newValue);
        
        ClientEntity clientSaved = clientRepo.save(client);
        
        return ClientMapper.toDTO(clientSaved);
    }

    public BalanceResponseDTO getBalance() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        UserEntity user = userRepo.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

        UUID userId = user.getId();
        ClientEntity client = clientRepo.findById(userId)
                .orElseThrow(() -> new RuntimeException("Cliente não encontrado"));

        return new BalanceResponseDTO(client.getBalance());
    }

}
