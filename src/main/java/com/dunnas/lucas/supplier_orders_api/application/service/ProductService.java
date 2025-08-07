package com.dunnas.lucas.supplier_orders_api.application.service;

import com.dunnas.lucas.supplier_orders_api.application.dto.ProductDTO;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.ArrayList;
import java.util.List;

@Service
public class ProductService {
    public List<ProductDTO> getAll() {
        List<ProductDTO> listProd = new ArrayList<>();

        listProd.add(new ProductDTO(1L, "Produto 1", "Desc", 200.0));
        listProd.add(new ProductDTO(2L, "Produto 2", "Desc2", 300.0));

        return listProd;
    }

    public ProductDTO getById(Long id) {
        ProductDTO prod = new ProductDTO(id, "Produto", "Desc", 100.0);
        return prod;
    }
}
