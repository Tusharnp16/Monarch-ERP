package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.config.JwtResponse;
import com.monarch.monarcherp.config.JwtUtils;
import com.monarch.monarcherp.config.SecurityConfig;
import com.monarch.monarcherp.dto.LoginRequest;
import com.monarch.monarcherp.model.User;
import com.monarch.monarcherp.repository.UserRepository;
import com.monarch.monarcherp.service.UserService;
import org.hibernate.sql.exec.spi.PostAction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.actuate.endpoint.SecurityContext;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.net.Authenticator;

@Controller
public class UserController {

    @Autowired
    JwtUtils jwtUtils;

    @Autowired
    private AuthenticationManager authenticationManager;

    private final UserRepository userRepository;
    @Autowired
    private UserService userService;

    public UserController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @GetMapping("/admin")
    public String dashboard(){
        return "default";
    }


    @GetMapping("/loginn")
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
        User savedUser=userService.saveUser(user);

        String token= jwtUtils.generateToken(user.getUserName(),user.getRole());

        return ResponseEntity.ok(new JwtResponse(token));
    }

    @PostMapping("/login")
    @ResponseBody
    public ResponseEntity<?> loginUser(@RequestBody LoginRequest loginRequest){

        Authentication authentication= authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(loginRequest.getUsername(), loginRequest.getPassword())
        );

        SecurityContextHolder.getContext().setAuthentication(authentication);

        User user=userRepository.findByUserName(loginRequest.getUsername()).orElseThrow(()->new UsernameNotFoundException("User not found"));

        String token=jwtUtils.generateToken(user.getUserName(),user.getRole());

        return ResponseEntity.ok(new JwtResponse(token));
    }


}
