package com.dunnas.lucas.supplier_orders_api.application.mapper;

import com.dunnas.lucas.supplier_orders_api.application.dto.RegisterDTO;
import com.dunnas.lucas.supplier_orders_api.infra.entity.UserEntity;

public class RegisterMapper {

    public static RegisterDTO toDto(UserEntity entity) {
        return new RegisterDTO(
            entity.getName(),
            entity.getUsername(),
            entity.getPassword()
        );
    }

    public static UserEntity toEntity(RegisterDTO dto) {
        return new UserEntity(
            dto.name(),
            dto.username(),
            dto.password()
        );
    }
}
