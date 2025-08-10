package com.dunnas.lucas.supplier_orders_api.domain.service;

import com.dunnas.lucas.supplier_orders_api.application.dto.ProductCreateDTO;
import com.dunnas.lucas.supplier_orders_api.application.dto.ProductDTO;
import com.dunnas.lucas.supplier_orders_api.application.mapper.ProductMapper;
import com.dunnas.lucas.supplier_orders_api.controller.exception.ItemNotFoundException;
import com.dunnas.lucas.supplier_orders_api.infra.entity.ProductEntity;
import com.dunnas.lucas.supplier_orders_api.infra.entity.UserEntity;
import com.dunnas.lucas.supplier_orders_api.infra.repository.ProductRepository;
import com.dunnas.lucas.supplier_orders_api.infra.repository.UserRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductService {
    @Autowired
    ProductRepository prodRepo;
    @Autowired
    UserRepository userRepo;
    
    public List<ProductDTO> getAll() {
        return prodRepo.findAll()
            .stream()
            .map(ProductMapper::toDto)
            .toList();
    }

    public ProductDTO getById(Long id) {
        ProductEntity entity = prodRepo.findById(id)
            .orElseThrow(() -> new ItemNotFoundException("Produto não existe."));

        return ProductMapper.toDto(entity);
    }

    public ProductDTO create(ProductCreateDTO product) {
        ProductEntity prodEntity = ProductMapper.toEntity(product);

        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        UserEntity user = userRepo.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

        prodEntity.setSupplierId(user.getId());

        ProductEntity prodSaved = prodRepo.save(prodEntity);
        return ProductMapper.toDto(prodSaved);
    }

    public void delete(Long id) {
        ProductEntity entity = prodRepo.findById(id)
            .orElseThrow(() -> new ItemNotFoundException("Produto não existe."));

        prodRepo.delete(entity);
    }

    public ProductDTO update(ProductDTO product, Long id) {
        ProductEntity entity = prodRepo.findById(id)
            .orElseThrow(() -> new ItemNotFoundException("Produto não existe."));

        entity.setName(product.name());
        entity.setDescription(product.description());
        entity.setPrice(product.price());

        prodRepo.save(entity);

        return ProductMapper.toDto(entity);
    }

}
