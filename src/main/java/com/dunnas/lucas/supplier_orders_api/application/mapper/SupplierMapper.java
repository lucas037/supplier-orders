package com.dunnas.lucas.supplier_orders_api.application.mapper;

import com.dunnas.lucas.supplier_orders_api.application.dto.SupplierDTO;
import com.dunnas.lucas.supplier_orders_api.infra.entity.SupplierEntity;

public class SupplierMapper {
    public static SupplierEntity toEntity(SupplierDTO supplierDTO) {
        return new SupplierEntity(
            supplierDTO.id(),
            supplierDTO.cnpj()
        );
    }

    public static SupplierDTO toDto(SupplierEntity supplierEntity) {
        return new SupplierDTO(
            supplierEntity.getId(),
            supplierEntity.getCnpj()
        );
    }

}
