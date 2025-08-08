package com.dunnas.lucas.supplier_orders_api.application.service;

import com.dunnas.lucas.supplier_orders_api.application.dto.ProductDTO;
import com.dunnas.lucas.supplier_orders_api.application.mapper.ProductMapper;
import com.dunnas.lucas.supplier_orders_api.domain.repository.ProductRepository;
import com.dunnas.lucas.supplier_orders_api.infra.entity.ProductEntity;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductService {
    @Autowired
    ProductRepository prodRepo;
    
    public List<ProductDTO> getAll() {
        return prodRepo.findAll()
            .stream()
            .map(ProductMapper::toDto)
            .toList();
    }

    public ProductDTO getById(Long id) {
        ProductEntity entity = prodRepo.findById(id)
            .orElseThrow(() -> new RuntimeException("Produto não encontrado"));

        return ProductMapper.toDto(entity);
    }

    public ProductDTO create(ProductDTO product) {
        ProductEntity prodEntity = ProductMapper.toEntity(product);
        ProductEntity prodSaved = prodRepo.save(prodEntity);
        return ProductMapper.toDto(prodSaved);
    }

    public void delete(Long id) {
        ProductEntity entity = prodRepo.findById(id)
            .orElseThrow(() -> new RuntimeException("Produto não encontrado"));

        prodRepo.delete(entity);
    }

    public ProductDTO update(ProductDTO product, Long id) {
        ProductEntity entity = prodRepo.findById(id)
            .orElseThrow(() -> new RuntimeException("Produto não encontrado"));

        entity.setName(product.name());
        entity.setDescription(product.description());
        entity.setPrice(product.price());

        prodRepo.save(entity);

        return ProductMapper.toDto(entity);
    }

}
