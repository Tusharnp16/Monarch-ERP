//package com.monarch.monarcherp.controller;
//
//import com.monarch.monarcherp.repository.ProductRepository;
//import com.monarch.monarcherp.service.ProductService;
//import org.springframework.data.domain.Page;
//import org.springframework.format.annotation.DateTimeFormat;
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.RequestMapping;
//
//
//import com.monarch.monarcherp.model.Product;
//import org.springframework.web.bind.annotation.*;
//
//import java.time.LocalDate;
//
//@Controller
//@RequestMapping("/products")
//public class ProductController {
//
//    private final ProductService productService;
//
//    public ProductController(ProductService productService) {
//        this.productService = productService;
//    }
//
////    @GetMapping
////    public String viewProducts(@RequestParam(defaultValue = "0") int page, Model model) {
////        model.addAttribute("products", productService.getAllProducts(page,20));
////        model.addAttribute("currentPage", page);
////        model.addAttribute("activeCount",2);
////        return "products";
////    }
//
////    @GetMapping
////    public String viewProducts(
////            @RequestParam(defaultValue = "0") int page,
////            @RequestParam(required = false) String search,
////            Model model
////    ) {
////        Page<Product> productPage;
////        if (search != null && !search.isEmpty()) {
////            productPage = productService.searchProducts(search, page, 20);
////        } else {
////            productPage = productService.getAllProducts(page, 20);
////        }
////        model.addAttribute("products", productPage);
////        model.addAttribute("currentPage", page);
////        model.addAttribute("activeCount",2);
////        return "products";
////    }
//
//    @GetMapping
//    public String viewProducts(
//            @RequestParam(defaultValue = "0") int page,
//            @RequestParam(required = false) String search,
//            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
//            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
//            Model model
//    ) {
//        Page<Product> productPage;
////
////        if (search != null && !search.trim().isEmpty()) {
////            productPage = productService.searchProducts(search.trim(), page, 20,startDate,endDate);
////        } else {
////            productPage = productService.getAllProducts(page, 20);
////            search = ""; // prevent null in JSP
////        }
//
//        productPage = productService.searchProducts(search, page, 20, startDate, endDate);
//
//        model.addAttribute("products", productPage);
//        model.addAttribute("search", search);
//        model.addAttribute("startDate", startDate);
//        model.addAttribute("endDate", endDate);
//        model.addAttribute("activeCount", 2);
//
//        return "products";
//    }
//
//
//
////    @GetMapping("/{id}")
////    public String viewProduct(@PathVariable Long id, Model model) {
////        model.addAttribute("products", java.util.Collections.singletonList(productService.getProduct(id)));
////        return "products";
////    }
//
//    @PostMapping("/add")
//    public String addProduct(@ModelAttribute Product product) {
//        productService.saveProduct(product);
//
//        return "redirect:/products";
//    }
//
//    @PostMapping("/update")
//    public String updateProduct(@ModelAttribute Product product) {
//        Product existing = productService.getProduct(product.getProductId());
//        if (existing != null) {
//            product.setCreatedAt(existing.getCreatedAt());
//        }
//        productService.saveProduct(product);
//        return "redirect:/products";
//    }
//
//    @PostMapping("/delete")
//    public String deleteProduct(@RequestParam Long id) {
//        productService.deleteProduct(id);
//        return "redirect:/products";
//    }
//}

package com.monarch.monarcherp.controller;

import com.fasterxml.jackson.annotation.JsonView;
import com.monarch.monarcherp.dto.ApiResponse;
import com.monarch.monarcherp.dto.VariantViews;
import com.monarch.monarcherp.model.Product;
import com.monarch.monarcherp.service.ProductService;
import org.springframework.data.domain.Page;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/products")
public class ProductController {

    private final ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping
    public ResponseEntity<ApiResponse<Page<Product>>> getAllProducts(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate
    ) {
        Page<Product> productPage = productService.searchProducts(search, page, size, startDate, endDate);
        return ResponseEntity.ok(ApiResponse.success(productPage,"Data fetched succesfully"));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Product>> getProductById(@PathVariable Long id) {
        Product product = productService.getProduct(id);
      //  return (product != null) ? ResponseEntity.ok(product) : ResponseEntity.notFound().build();

        return (product != null) ? ResponseEntity.ok(ApiResponse.success(product,"Product Not Found")) : ResponseEntity.ok(ApiResponse.success(product,"Data fetched succesfully"));
    }

    @GetMapping("/compact")
    @JsonView(VariantViews.forProducts.class)
    public ResponseEntity<ApiResponse<List<Product>>> getCompactProduct(@RequestParam(required = false) String name) {
        List<Product> product = productService.getAllCompactProducts(name);
        return ResponseEntity.ok(ApiResponse.success(product,"Data fetched succesfully"));
    }


    @PostMapping
    public ResponseEntity<Product> createProduct(@RequestBody Product product) {
        Product savedProduct = productService.saveProduct(product);
        return new ResponseEntity<>(savedProduct, HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Product>> updateProduct(@PathVariable Long id, @RequestBody Product product) {
        Product existing = productService.getProduct(id);
        if (existing == null) {
            return ResponseEntity.ok(ApiResponse.error("No product aligned with this id"));
        }

        product.setProductId(id);
        product.setCreatedAt(existing.getCreatedAt());

        Product updatedProduct = productService.saveProduct(product);
        return ResponseEntity.ok(ApiResponse.success(updatedProduct,"Product Updated"));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteProduct(@PathVariable Long id) {
        productService.deleteProduct(id);
        return ResponseEntity.noContent().build();
    }
}