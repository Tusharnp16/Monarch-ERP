package com.monarch.monarcherp.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping
class TestingController {

    @GetMapping("/")
    public String getDefaultPage(){
        return "defaultpage";
    }

}
