package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.config.JwtResponse;
import com.monarch.monarcherp.config.JwtUtils;
import com.monarch.monarcherp.config.SecurityConfig;
import com.monarch.monarcherp.dto.LoginRequest;
import com.monarch.monarcherp.model.User;
import com.monarch.monarcherp.repository.UserRepository;
import com.monarch.monarcherp.service.CustomUserDetailsService;
import com.monarch.monarcherp.service.UserService;
import org.hibernate.sql.exec.spi.PostAction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.actuate.endpoint.SecurityContext;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseCookie;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.management.relation.Role;
import java.net.Authenticator;

@Controller
public class UserController {

    @GetMapping("/admin")
    public String dashboard(){
        return "default";
    }


}
