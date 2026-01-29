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

    @Autowired
    JwtUtils jwtUtils;

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private CustomUserDetailsService userDetailsService;

    @Autowired
    private UserService userService;

    @GetMapping("/admin")
    public String dashboard(){
        return "default";
    }


    @GetMapping("/login")
    public String getLoginPage(){
        return "login";
    }

    @GetMapping("/register")
    public String getRegisterPage(){
        return "register";
    }

   @PostMapping("/register")
   @ResponseBody
    public ResponseEntity<?> registerUser(@RequestBody User user){
        userService.saveUser(user);

        String token= jwtUtils.generateToken(user.getUserName(), user.getRole());

        return ResponseEntity.ok(new JwtResponse(token));
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest request) {

        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getUsername(), request.getPassword()
                )
        );

        UserDetails userDetails = userDetailsService.loadUserByUsername(request.getUsername());

        String role = userDetails.getAuthorities().stream()
                .findFirst()
                .map(grantedAuthority -> grantedAuthority.getAuthority()) // e.g. ROLE_ADMIN
                .orElse("ROLE_USER");

        String token = jwtUtils.generateToken(userDetails.getUsername(), role);

        ResponseCookie cookie = ResponseCookie.from("accessToken", token)
                .httpOnly(true)
                .secure(false)
                .path("/")
                .maxAge(24 * 60 * 60)
                .sameSite("Lax")
                .build();

        return ResponseEntity.ok()
                .header(HttpHeaders.SET_COOKIE, cookie.toString())
                .build();
    }


    @PostMapping("/logout")
    public ResponseEntity<?> logout() {

        ResponseCookie deleteCookie = ResponseCookie.from("accessToken", "")
                .httpOnly(true)
                .secure(false)
                .path("/")
                .maxAge(0)
                .sameSite("Lax")
                .build();

        return ResponseEntity.ok()
                .header(HttpHeaders.SET_COOKIE, deleteCookie.toString())
                .body("Logged out successfully");
    }
}
