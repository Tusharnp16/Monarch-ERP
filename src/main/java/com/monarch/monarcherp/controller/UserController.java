package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.model.User;
import com.monarch.monarcherp.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.Map;

@Controller
public class UserController {

    @GetMapping("/admin")
    public String dashboard() {
        return "default";
    }

    @Autowired
    UserService userService;

    @PostMapping
    public ResponseEntity<User> createUser(@RequestBody Map<String, String> userData) {
        User user = userService.saveAndNotify(userData.get("name"), userData.get("email"));
        return new ResponseEntity<>(user, HttpStatus.CREATED);
    }


}
