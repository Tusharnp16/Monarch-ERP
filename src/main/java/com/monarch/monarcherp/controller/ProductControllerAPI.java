package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.dto.ApiResponse;
import com.monarch.monarcherp.model.Product;
import com.monarch.monarcherp.model.StockMaster;
import com.monarch.monarcherp.model.Variant;
import com.monarch.monarcherp.service.ProductService;
import com.monarch.monarcherp.service.StockMasterService;
import com.monarch.monarcherp.service.VariantService;
import org.springframework.data.domain.Page;
import org.springframework.data.web.PagedResourcesAssembler;
import org.springframework.hateoas.EntityModel;
import org.springframework.hateoas.PagedModel;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.linkTo;
import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

@RestController
@RequestMapping("/api/v1/products")
public class ProductControllerAPI {

    private final ProductService productService;
    private final VariantService variantService;
    private final StockMasterService stockMasterService;

    ProductControllerAPI(ProductService productService, VariantService variantService, StockMasterService stockMasterService) {
        this.productService = productService;
        this.variantService = variantService;
        this.stockMasterService = stockMasterService;
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping()
    public ResponseEntity<ApiResponse<Product>> saveProduct(@RequestBody Product product) {
        Product savedProduct = productService.saveProduct(product);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(savedProduct, "Product Created Successfully"));
    }


    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<EntityModel<Product>>> getProduct(@PathVariable Long id) {

        Product getProduct = productService.getProduct(id);
        if (getProduct == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ApiResponse.error("Product Fetched Failed"));

        }

        EntityModel<Product> resource = EntityModel.of(getProduct);
        resource.add(linkTo(methodOn(ProductControllerAPI.class).getProduct(id)).withSelfRel());
        return ResponseEntity.ok(ApiResponse.success(resource, "Product Fetched"));
    }

//    @GetMapping
//    public ResponseEntity<ApiResponse<Page<Product>>> getAllProducts(
//            @RequestParam(defaultValue = "2500") int page,
//            @RequestParam(defaultValue = "20") int size) {
//        Page<Product> products = productService.getAllProducts(page, size);
//        int end=page+20;
//        String message="Fetched products from " + page + " to " + end;
//        return ResponseEntity.ok(ApiResponse.success(products, message));
//    }

    @GetMapping
    public ResponseEntity<ApiResponse<PagedModel<EntityModel<Product>>>> getAllProducts(
            @RequestParam(defaultValue = "2499") int page,
            @RequestParam(defaultValue = "20") int size,
            PagedResourcesAssembler<Product> assembler) {

        Page<Product> products = productService.getAllProducts(page, size);

        PagedModel<EntityModel<Product>> pagedModel = assembler.toModel(products, product -> {
            EntityModel model = EntityModel.of(product,
                    linkTo(methodOn(ProductControllerAPI.class).getProduct(product.getProductId())).withSelfRel(),
                    linkTo(methodOn(ProductControllerAPI.class).getVariant(product.getProductId())).withRel("Variants")
                    //  linkTo(methodOn(ProductControllerAPI.class).)
            );

            List<Variant> variants = variantService.getVariantByProductId(product.getProductId());

            for (Variant v : variants) {
                model.add(linkTo(methodOn(ProductControllerAPI.class)
                        .getStock(v.getVariantId()))
                        .withRel("stock_variant_" + v.getVariantId()));
            }

            return model;
        });

        return ResponseEntity.ok(ApiResponse.success(pagedModel, "Fetched products"));
    }

    @GetMapping("{id}/variant")
    public ResponseEntity<ApiResponse<List<Variant>>> getVariant(@PathVariable Long id) {
        List<Variant> variant = variantService.getVariantByProductId(id);

        return ResponseEntity.ok(ApiResponse.success(variant, "Variant Fetched"));
    }

    @GetMapping("/{id}/stock")
    public ResponseEntity<ApiResponse<List<StockMaster>>> getStock(@PathVariable Long id) {
        List<StockMaster> stockMasters = stockMasterService.getStockMasterByVariantId(id);
        return ResponseEntity.ok(ApiResponse.success(stockMasters, "Stock Fetched"));
    }

    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteProduct(@PathVariable Long id) {
        productService.deleteProduct(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Product deleted"));
    }
//
//    @Operation(
//            summary = "Update product name",
//            description = "Updates the display name of an existing product. The ID must exist in the database."
//    )

    @PreAuthorize("hasRole('ADMIN')")
    @PatchMapping("/{id}/name")
    public ResponseEntity<ApiResponse<Product>> updateProductName(@PathVariable Long id, @RequestParam String newName) {
        Product updated = productService.updateProductName(id, newName);
        return ResponseEntity.ok(ApiResponse.success(updated, "Product name updated"));
    }


    @GetMapping("/count")
    public ResponseEntity<ApiResponse<Product>> getTotalProducts() {
        long total = productService.getTotalProducts();
        String message = "Products : " + total;
        return ResponseEntity.ok(ApiResponse.success(null, message));

    }

    @GetMapping("/exists/{id}")
    public ResponseEntity<ApiResponse<Product>> productExists(@PathVariable Long id) {
        boolean exists = productService.productExists(id);
        String message = exists ? "Product is in database " : "Product Not Exists";
        return ResponseEntity.ok(ApiResponse.success(null, message));
    }

}