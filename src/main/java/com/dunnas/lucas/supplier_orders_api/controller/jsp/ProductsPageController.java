package com.dunnas.lucas.supplier_orders_api.controller.jsp;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ProductsPageController {
    @RequestMapping("/products")
    public static String products() {
        return "products";
    }
}
