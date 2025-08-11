package com.dunnas.lucas.supplier_orders_api.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.dunnas.lucas.supplier_orders_api.application.dto.BalanceResponseDTO;
import com.dunnas.lucas.supplier_orders_api.application.dto.ClientDTO;
import com.dunnas.lucas.supplier_orders_api.application.dto.DepositDTO;
import com.dunnas.lucas.supplier_orders_api.domain.service.ClientService;

@RestController
@RequestMapping("/api/v1")
public class ClientController {
    @Autowired
    ClientService clientServ;

    @RequestMapping("/client/register")
    public ResponseEntity<ClientDTO> register(@RequestBody ClientDTO clientDTO) {
        ClientDTO respDTO = clientServ.register(clientDTO);
        return ResponseEntity.ok().body(respDTO);
    }

    @RequestMapping("/client/deposit")
    public ResponseEntity<ClientDTO> deposit(@RequestBody DepositDTO depositDTO) {
        ClientDTO respDTo = clientServ.deposit(depositDTO);
        return ResponseEntity.ok().body(respDTo);
    }
    
    @RequestMapping("/client/balance")
    public ResponseEntity<BalanceResponseDTO> getBalance() {
        BalanceResponseDTO respDto = clientServ.getBalance();
        return ResponseEntity.ok().body(respDto);
    }
}
