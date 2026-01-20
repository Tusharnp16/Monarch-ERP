package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.service.ProductService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/view/products")
public class ProductViewController {

    private final ProductService productService;

    public ProductViewController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping
    public String viewProducts(Model model) {
        model.addAttribute("products", productService.getAllProducts());
        return "products";
    }
}
