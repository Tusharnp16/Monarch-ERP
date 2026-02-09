package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.repository.UserLoginLogRepository;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping
class TestingController {

    @Autowired
    UserLoginLogRepository userLoginLogRepository;

    @GetMapping("/")
    public String getDefaultPage(){
        return "403";
    }

//    @GetMapping("/serverlog")
//    public String getServerLog(ServletRequest servletRequest){
//        return "serverlog";
//    }
//
    @GetMapping("/userlogs")
    public String showUserLogs(HttpServletRequest request, Model model) {
        String currentUsername = SecurityContextHolder
                .getContext().getAuthentication().getName();

        System.out.println("DEBUG : " + currentUsername);

        model.addAttribute("logs", userLoginLogRepository.findByUsernameOrderByLoginTimeDesc(currentUsername));
        return "serverlog";
    }

    @GetMapping("/contacts")
    public String contact() {
        return "contacts";
    }


    @GetMapping("/products")
    public String product() {
        return "products";
    }

    @GetMapping("/variants")
    public String varinat() {
        return "variants";
    }

    @GetMapping("/customers")
    public String customer() {
        return "customers";
    }
}
