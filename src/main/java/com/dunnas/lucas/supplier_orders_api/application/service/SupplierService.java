package com.dunnas.lucas.supplier_orders_api.application.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dunnas.lucas.supplier_orders_api.application.dto.SupplierDTO;
import com.dunnas.lucas.supplier_orders_api.application.mapper.SupplierMapper;
import com.dunnas.lucas.supplier_orders_api.infra.entity.SupplierEntity;
import com.dunnas.lucas.supplier_orders_api.infra.repository.SupplierRepository;

@Service
public class SupplierService {
    @Autowired
    SupplierRepository supplierRepo;

    public SupplierDTO register(SupplierDTO supplierDTO) {
        SupplierEntity supplierEntity = SupplierMapper.toEntity(supplierDTO);
        SupplierEntity supplierSaved = supplierRepo.save(supplierEntity);
        return SupplierMapper.toDto(supplierSaved);
    }
}
