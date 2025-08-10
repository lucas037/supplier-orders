package com.dunnas.lucas.supplier_orders_api.domain.service;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.dunnas.lucas.supplier_orders_api.application.dto.LoginDTO;
import com.dunnas.lucas.supplier_orders_api.application.dto.RegisterDTO;
import com.dunnas.lucas.supplier_orders_api.application.dto.TokenResponseDTO;
import com.dunnas.lucas.supplier_orders_api.application.mapper.RegisterMapper;
import com.dunnas.lucas.supplier_orders_api.application.mapper.UserMapper;
import com.dunnas.lucas.supplier_orders_api.domain.model.User;
import com.dunnas.lucas.supplier_orders_api.infra.entity.UserEntity;
import com.dunnas.lucas.supplier_orders_api.infra.repository.UserRepository;
import com.dunnas.lucas.supplier_orders_api.security.TokenService;

@Service
public class AuthService {
   @Autowired
   UserRepository userRepo;
   
   @Autowired
   PasswordEncoder passEncoder;
   
   @Autowired
   private AuthenticationManager authenticationManager;

   @Autowired
   private TokenService tokenService;
   
   public void register(RegisterDTO registerDTO) {
        if (userRepo.findByUsername(registerDTO.username()).isPresent())
            throw new IllegalStateException("Nome de usuário já está em uso.");
            
        UserEntity userEntity = RegisterMapper.toEntity(registerDTO);

        String encodedPassword = passEncoder.encode(userEntity.getPassword());
        userEntity.setPassword(encodedPassword);

        userRepo.save(userEntity);
   }


   public TokenResponseDTO login(LoginDTO loginDTO) {
      UsernamePasswordAuthenticationToken authRequest =
         new UsernamePasswordAuthenticationToken(loginDTO.username(), loginDTO.password());

      var authentication = authenticationManager.authenticate(authRequest);

      UserEntity userEntity = (UserEntity) authentication.getPrincipal();

      User user = UserMapper.toUser(userEntity);

      return new TokenResponseDTO(tokenService.generateToken(user));
   }

}
