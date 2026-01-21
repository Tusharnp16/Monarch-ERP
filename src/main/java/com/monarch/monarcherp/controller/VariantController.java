package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.service.ProductService;
import com.monarch.monarcherp.service.VariantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/variant")
class VariantController {

    @Autowired
    private VariantService variantService;

    @GetMapping("/view")
    public String viewProducts(Model model) {
        model.addAttribute("variants", variantService.getAllVariants());
        return "variants";
    }

}
