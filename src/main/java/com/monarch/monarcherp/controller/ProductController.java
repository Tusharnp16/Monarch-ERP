package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.model.Product;
import com.monarch.monarcherp.service.ProductService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/products")
public class ProductController {

    private final ProductService productService;

    ProductController(ProductService productService){
        this.productService=productService;
    }

    @PostMapping
    public Product saveProduct(@RequestBody Product product){
        return productService.saveProduct(product);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Product> getProduct(@PathVariable Long id){
        return productService.getProduct(id);
    }

    @GetMapping
    public List<Product> getAllProducts(){
        return productService.getAllProducts();
    }

    @DeleteMapping("/{id}")
    public void deleteProduct(@PathVariable Long id){
            productService.deleteProduct(id);
    }

    @GetMapping("/count")
    public long getTotalProducts(){
        return productService.getTotalProducts();
    }

    @GetMapping("/exists/{id}")
    public boolean productExists(@PathVariable Long id) {
        return productService.productExists(id);
    }

    @PatchMapping("/{id}/name")
    public Product updateProductName(@PathVariable Long id, @RequestBody String newName) {
        return productService.updateProductName(id, newName);
    }

}
