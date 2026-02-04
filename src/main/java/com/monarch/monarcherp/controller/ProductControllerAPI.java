package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.dto.ApiResponse;
import com.monarch.monarcherp.model.Product;
import com.monarch.monarcherp.service.ProductService;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("api/products")
public class ProductControllerAPI {

    private final ProductService productService;

    ProductControllerAPI(ProductService productService) {
        this.productService = productService;
    }

    @PostMapping()
    public ResponseEntity<ApiResponse<Product>> saveProduct(@RequestBody Product product) {
        Product savedProduct = productService.saveProduct(product);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(savedProduct, "Product Created Successfully"));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Product>> getProduct(@PathVariable Long id) {
        Product getProduct = productService.getProduct(id);
        if(getProduct==null){
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ApiResponse.error("Product Fetched Failed"));

        }
        return ResponseEntity.status(HttpStatus.OK)
                .body(ApiResponse.success(getProduct, "Product Fetched"));
    }

    @GetMapping
    public ResponseEntity<ApiResponse<Page<Product>>> getAllProducts(
            @RequestParam(defaultValue = "2500") int page,
            @RequestParam(defaultValue = "20") int size) {
        Page<Product> products = productService.getAllProducts(page, size);
        int end=page+20;
        String message="Fetched products from " + page + " to " + end;
        return ResponseEntity.ok(ApiResponse.success(products, message));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteProduct(@PathVariable Long id) {
        productService.deleteProduct(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Product deleted"));
    }

    @Operation(
            summary = "Update product name",
            description = "Updates the display name of an existing product. The ID must exist in the database."
    )

    @PatchMapping("/{id}/name")
    public ResponseEntity<ApiResponse<Product>> updateProductName(@PathVariable Long id, @RequestParam String newName) {
        Product updated = productService.updateProductName(id, newName);
        return ResponseEntity.ok(ApiResponse.success(updated, "Product name updated"));
    }


    @GetMapping("/count")
    public ResponseEntity<ApiResponse<Product>> getTotalProducts() {
        long total= productService.getTotalProducts();
        String message="Products : " + total;
        return ResponseEntity.ok(ApiResponse.success(null,message));

    }

    @GetMapping("/exists/{id}")
    public ResponseEntity<ApiResponse<Product>> productExists(@PathVariable Long id) {
        boolean exists= productService.productExists(id);
        String message = exists ? "Product is in database " : "Product Not Exists";
        return ResponseEntity.ok(ApiResponse.success(null,message));
    }

}
