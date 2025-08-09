package com.dunnas.lucas.supplier_orders_api.application.mapper;

import com.dunnas.lucas.supplier_orders_api.application.dto.LoginDTO;
import com.dunnas.lucas.supplier_orders_api.infra.entity.UserEntity;

public class LoginMapper {

    public static LoginDTO toDto(UserEntity entity) {
        return new LoginDTO(
            entity.getUsername(),
            entity.getPassword()
        );
    }

    public static UserEntity toEntity(LoginDTO dto) {
        return new UserEntity(
            dto.username(),
            dto.password()
        );
    }
}
