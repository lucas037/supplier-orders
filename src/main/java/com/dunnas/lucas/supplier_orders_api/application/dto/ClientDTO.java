package com.dunnas.lucas.supplier_orders_api.application.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record ClientDTO(UUID id, String cpf, LocalDate birthdate, BigDecimal balance) {
    
}
