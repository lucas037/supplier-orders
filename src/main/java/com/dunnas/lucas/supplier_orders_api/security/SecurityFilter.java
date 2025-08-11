package com.dunnas.lucas.supplier_orders_api.security;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import com.dunnas.lucas.supplier_orders_api.controller.exception.NotAuthenticatedUser;
import com.dunnas.lucas.supplier_orders_api.infra.repository.UserRepository;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class SecurityFilter extends OncePerRequestFilter {
    @Autowired
    TokenService tokenService;

    @Autowired
    UserRepository userRepository;


    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        // Ignorar filtro para rotas públicas
        String requestURI = request.getRequestURI();
        if (requestURI.equals("/login") || 
            requestURI.startsWith("/api/v1/auth/") ||
            requestURI.startsWith("/WEB-INF/") ||
            requestURI.startsWith("/static/") ||
            requestURI.startsWith("/css/") ||
            requestURI.startsWith("/js/") ||
            requestURI.startsWith("/images/")) {
            filterChain.doFilter(request, response);
            return;
        }

        var token = this.recoverToken(request);

        if (token != null) {
            var username = tokenService.validateToken(token);
            if (!username.isEmpty()) {
                try {
                    UserDetails user = userRepository.findByUsername(username)
                        .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

                    var authentication = new UsernamePasswordAuthenticationToken(user, null, user.getAuthorities());
                    SecurityContextHolder.getContext().setAuthentication(authentication);
                } catch (Exception e) {
                    // Log do erro mas continua o filtro
                    System.err.println("Erro ao processar token: " + e.getMessage());
                }
            }
        }
        filterChain.doFilter(request, response);
    }

    private String recoverToken(HttpServletRequest request) {
        var authHeader = request.getHeader("Authorization");
        if (authHeader == null || !authHeader.startsWith("Bearer ")) return null;
        return authHeader.replace("Bearer ", "");
    }

    
}