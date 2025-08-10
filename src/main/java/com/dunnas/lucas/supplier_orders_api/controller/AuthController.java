package com.dunnas.lucas.supplier_orders_api.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.dunnas.lucas.supplier_orders_api.application.dto.LoginDTO;
import com.dunnas.lucas.supplier_orders_api.application.dto.RegisterDTO;
import com.dunnas.lucas.supplier_orders_api.application.dto.TokenResponseDTO;
import com.dunnas.lucas.supplier_orders_api.application.dto.UserDTO;
import com.dunnas.lucas.supplier_orders_api.domain.service.AuthService;

@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {
    @Autowired
    AuthService authServ;

    @RequestMapping("/register")
    public ResponseEntity<UserDTO> register(@RequestBody RegisterDTO registerDTO) {
        UserDTO respDTO = authServ.register(registerDTO);
        return ResponseEntity.ok().body(respDTO);
    }

    @RequestMapping("/login")
    public ResponseEntity<TokenResponseDTO> login(@RequestBody LoginDTO loginDTO) {
        TokenResponseDTO tokenResponse = authServ.login(loginDTO);
        return ResponseEntity.ok().body(tokenResponse);
    }
}
