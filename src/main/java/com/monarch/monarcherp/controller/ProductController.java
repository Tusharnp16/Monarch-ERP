package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.repository.ProductRepository;
import com.monarch.monarcherp.service.ProductService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;


import com.monarch.monarcherp.model.Product;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/products")
public class ProductController {

    private final ProductService productService;
    private final ProductRepository productRepository;

    public ProductController(ProductService productService, ProductRepository productRepository) {
        this.productService = productService;
        this.productRepository = productRepository;
    }

    @GetMapping
    public String viewProducts(Model model) {
        model.addAttribute("products", productService.getAllProducts());
        return "products";
    }

    @GetMapping("/{id}")
    public String viewProduct(@PathVariable Long id, Model model) {
        model.addAttribute("products", java.util.Collections.singletonList(productService.getProduct(id)));
        return "products";
    }

    @PostMapping("/add")
    public String addProduct(@ModelAttribute Product product) {
        productService.saveProduct(product);
        return "redirect:/products";
    }

    @PostMapping("/update")
    public String updateProductName(@ModelAttribute Product product) {
        Product existing = productService.getProduct(product.getProductId());
        if (existing != null) {
            product.setCreatedAt(existing.getCreatedAt());
        }
        productRepository.save(product);
        return "redirect:/products/" + product.getProductId();
    }

    @PostMapping("/{id}/delete")
    public String deleteProduct(@PathVariable Long id) {
        productService.deleteProduct(id);
        return "redirect:/products";
    }
}

