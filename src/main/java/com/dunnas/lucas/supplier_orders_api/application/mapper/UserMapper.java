package com.dunnas.lucas.supplier_orders_api.application.mapper;

import com.dunnas.lucas.supplier_orders_api.domain.model.User;
import com.dunnas.lucas.supplier_orders_api.infra.entity.UserEntity;

public class UserMapper {
    public static UserEntity toEntity(User user) {
        return new UserEntity(
            user.getId(),
            user.getName(),
            user.getUsername(),
            user.getPassword(),
            user.getRole()
        );
    }

    public static User toUser(UserEntity entity) {
        return new User(
            entity.getId(),
            entity.getName(),
            entity.getUsername(),
            entity.getPassword(),
            entity.getRole()
        );
    }
}
