package com.dunnas.lucas.supplier_orders_api.controller.jsp;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class DepositPageController {
    @GetMapping("/deposit")
    public String cart() {
        return "deposit";
    }
}
