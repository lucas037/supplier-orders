package com.dunnas.lucas.supplier_orders_api.controller.jsp;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class BuyProductsPageController {
    @GetMapping("/buy-products")
    public String buyProducts() {
        return "buy-products";
    }
}
