package com.dunnas.lucas.supplier_orders_api.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import com.dunnas.lucas.supplier_orders_api.controller.exception.CustomAccessDeniedHandler;

@Configuration
public class SecurityConfig {
    @Autowired
    private CustomAccessDeniedHandler accessDeniedHandler;
    
    @Autowired
    SecurityFilter securityFilter;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        return http
                .csrf(csrf -> csrf.disable())
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                    .requestMatchers("/login", "/register", "/products", "/buy-products").permitAll()
                    .requestMatchers("/WEB-INF/**").permitAll()
                    .requestMatchers("/static/**").permitAll()
                    .requestMatchers("/css/**", "/js/**", "/images/**").permitAll()
                    .requestMatchers("/api/v1/auth/login", "/api/v1/auth/register").permitAll()
                    .requestMatchers("/api/v1/client/register", "/api/v1/supplier/register").permitAll()

                    .requestMatchers("/api/v1/product").hasAnyRole("CLIENT", "SUPPLIER")
                    .requestMatchers("/api/v1/product/**").hasRole("SUPPLIER")
                    .requestMatchers("/api/v1/order/**").hasRole("CLIENT")
                    .anyRequest().authenticated()
                )
                .exceptionHandling(exception -> exception
                    .accessDeniedHandler(accessDeniedHandler)
                )
                .addFilterBefore(securityFilter, UsernamePasswordAuthenticationFilter.class)
                .build();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authConfig) throws Exception {
        return authConfig.getAuthenticationManager();
    }

}
