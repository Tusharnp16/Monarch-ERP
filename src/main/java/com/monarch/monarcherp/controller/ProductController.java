package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.repository.ProductRepository;
import com.monarch.monarcherp.service.ProductService;
import org.springframework.data.domain.Page;
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

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

//    @GetMapping
//    public String viewProducts(@RequestParam(defaultValue = "0") int page, Model model) {
//        model.addAttribute("products", productService.getAllProducts(page,20));
//        model.addAttribute("currentPage", page);
//        model.addAttribute("activeCount",2);
//        return "products";
//    }

//    @GetMapping
//    public String viewProducts(
//            @RequestParam(defaultValue = "0") int page,
//            @RequestParam(required = false) String search,
//            Model model
//    ) {
//        Page<Product> productPage;
//        if (search != null && !search.isEmpty()) {
//            productPage = productService.searchProducts(search, page, 20);
//        } else {
//            productPage = productService.getAllProducts(page, 20);
//        }
//        model.addAttribute("products", productPage);
//        model.addAttribute("currentPage", page);
//        model.addAttribute("activeCount",2);
//        return "products";
//    }

    @GetMapping
    public String viewProducts(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(required = false) String search,
            Model model
    ) {
        Page<Product> productPage;

        if (search != null && !search.trim().isEmpty()) {
            productPage = productService.searchProducts(search.trim(), page, 20);
        } else {
            productPage = productService.getAllProducts(page, 20);
            search = ""; // prevent null in JSP
        }

        model.addAttribute("products", productPage);
        model.addAttribute("search", search);   // ⭐ IMPORTANT
        model.addAttribute("activeCount", 2);

        return "products";
    }



//    @GetMapping("/{id}")
//    public String viewProduct(@PathVariable Long id, Model model) {
//        model.addAttribute("products", java.util.Collections.singletonList(productService.getProduct(id)));
//        return "products";
//    }

    @PostMapping("/add")
    public String addProduct(@ModelAttribute Product product) {
        productService.saveProduct(product);

        return "redirect:/products";
    }

    @PostMapping("/update")
    public String updateProduct(@ModelAttribute Product product) {
        Product existing = productService.getProduct(product.getProductId());
        if (existing != null) {
            product.setCreatedAt(existing.getCreatedAt());
        }
        productService.saveProduct(product);
        return "redirect:/products";
    }

    @PostMapping("/delete")
    public String deleteProduct(@RequestParam Long id) {
        productService.deleteProduct(id);
        return "redirect:/products";
    }
}

