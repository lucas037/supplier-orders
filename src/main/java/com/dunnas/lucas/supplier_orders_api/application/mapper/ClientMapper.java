package com.dunnas.lucas.supplier_orders_api.application.mapper;

import com.dunnas.lucas.supplier_orders_api.application.dto.ClientDTO;
import com.dunnas.lucas.supplier_orders_api.infra.entity.ClientEntity;

public class ClientMapper {
    public static ClientEntity toEntity(ClientDTO clientDTO) {
        return new ClientEntity(
            clientDTO.id(),
            clientDTO.cpf(),
            clientDTO.birthdate(),
            clientDTO.balance()
        );
    }

    public static ClientDTO toDTO(ClientEntity clientEntity) {
        return new ClientDTO(
            clientEntity.getId(),
            clientEntity.getCpf(),
            clientEntity.getBirthdate(),
            clientEntity.getBalance()
        );
    }
}
