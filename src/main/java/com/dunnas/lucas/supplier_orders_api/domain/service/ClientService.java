package com.dunnas.lucas.supplier_orders_api.domain.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dunnas.lucas.supplier_orders_api.application.dto.ClientDTO;
import com.dunnas.lucas.supplier_orders_api.application.mapper.ClientMapper;
import com.dunnas.lucas.supplier_orders_api.infra.entity.ClientEntity;
import com.dunnas.lucas.supplier_orders_api.infra.repository.ClientRepository;

@Service
public class ClientService {
    @Autowired
    ClientRepository clientRepo;

    public ClientDTO register(ClientDTO clientDTO) {
        ClientEntity clientEntity = ClientMapper.toEntity(clientDTO);
        ClientEntity clientSaved = clientRepo.save(clientEntity);
        return ClientMapper.toDTO(clientSaved);
    }
}
