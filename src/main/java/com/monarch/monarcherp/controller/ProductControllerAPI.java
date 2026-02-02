package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.model.Product;
import com.monarch.monarcherp.service.ProductService;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("api/products")
public class ProductControllerAPI {

    private final ProductService productService;

    ProductControllerAPI(ProductService productService){
        this.productService=productService;
    }

    @PostMapping
    public Product saveProduct(@RequestBody Product product){
        return productService.saveProduct(product);
    }

    @GetMapping("/{id}")
    public Product getProduct(@PathVariable Long id){
        return productService.getProduct(id);
    }

    @GetMapping
    public Page<Product> getAllProducts(){
        return productService.getAllProducts(0,20);
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

    @Operation(
            summary = "Update product name",
            description = "Updates the display name of an existing product. The ID must exist in the database."
    )
    @PatchMapping("/{id}/name")
    public Product updateProductName(@PathVariable Long id, @RequestParam String newName) {
        return productService.updateProductName(id, newName);
    }

}
