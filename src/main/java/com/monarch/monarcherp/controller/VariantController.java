//package com.monarch.monarcherp.controller;
//
//import com.monarch.monarcherp.model.Product;
//import com.monarch.monarcherp.model.Variant;
//import com.monarch.monarcherp.service.ProductService;
//import com.monarch.monarcherp.service.VariantService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
//import org.springframework.web.bind.annotation.*;
//
//import java.util.List;
//
//@Controller
//@RequestMapping("/variants")
//class VariantController {
//
//    @Autowired
//    private VariantService variantService;
//    @Autowired
//    private ProductService productService;
//
////    @GetMapping
////    public String viewVariant(Model model) {
////        model.addAttribute("variants", variantService.getAllVariants());
////        model.addAttribute("parentProducts",productService.getAllProducts(2500,20));
////        return "variants";
////    }
//
//
////    @GetMapping("/contact")
////    public String health() {
////        return "contacts";
////    }
//
//
//    @GetMapping
//    public String viewPaginatedVariant(@RequestParam(value = "lastId",required = false) Long lastId, Model model) {
//
//       Long finalId= lastId == null ? 0L : lastId;
//
//        List<Variant> variants = variantService.getPaginatedVariant(finalId);
//
//        Long nextCursor = null;
//        boolean hasNext = false;
//
//        if (!variants.isEmpty()) {
//            nextCursor = variants.get(variants.size() - 1).getVariantId();
//            hasNext = variants.size() == 10;
//        }
//
//        model.addAttribute("variants", variants);
//        model.addAttribute("nextCursor", nextCursor);
//        model.addAttribute("hasNext", hasNext);
//        model.addAttribute("parentProducts", productService.getAllProducts(2500, 20));
//        return "variants";
//    }
//
//
//    @GetMapping("/{id}")
//    public String viewVariant(@PathVariable Long id, Model model) {
//        model.addAttribute("variants", java.util.Collections.singletonList(variantService.getVariant(id)));
//        return "variants";
//    }
//
//    @PostMapping("/add")
//    public String addVariant(@ModelAttribute Variant variant,@RequestParam Long productId) {
//        Product managedProduct = productService.getProduct(productId);
//        variant.setProduct(managedProduct);
//        variantService.saveVariant(variant);
//        return "redirect:/variants";
//    }
//
//    @PostMapping("/update")
//    public String updateVariantName(@ModelAttribute Variant variant,Long productId) {
//        Variant existing = variantService.getVariant(variant.getVariantId());
//        Product product=productService.getProduct(productId);
//        variant.setProduct(product);
//
//        if (existing != null) {
//            variant.setCreatedAt(existing.getCreatedAt());
//        }
//        variantService.saveVariant(variant);
//        return "redirect:/variants";
//    }
//
//    @PostMapping("/delete")
//    public String deleteVariant(@RequestParam Long id) {
//        variantService.deleteVariant(id);
//        return "redirect:/variants";
//    }
//
//}


package com.monarch.monarcherp.controller;

import com.fasterxml.jackson.annotation.JsonView;
import com.monarch.monarcherp.dto.ApiResponse;
import com.monarch.monarcherp.dto.VariantViews;
import com.monarch.monarcherp.model.Product;
import com.monarch.monarcherp.model.Variant;
import com.monarch.monarcherp.service.ProductService;
import com.monarch.monarcherp.service.VariantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/variants")
public class VariantController {

    @Autowired
    private VariantService variantService;

    @Autowired
    private ProductService productService;

    @GetMapping
    public ResponseEntity<ApiResponse<Map<String, Object>>> getPaginatedVariants(
            @RequestParam(value = "lastId", required = false) Long lastId) {

        Long finalId = (lastId == null) ? 0L : lastId;
        List<Variant> variants = variantService.getPaginatedVariant(finalId);

        Long nextCursor = null;
        boolean hasNext = false;

        if (!variants.isEmpty()) {
            nextCursor = variants.get(variants.size() - 1).getVariantId();
            hasNext = variants.size() == 10;
        }

        Map<String, Object> data = new HashMap<>();
        data.put("variants", variants);
        data.put("nextCursor", nextCursor);
        data.put("hasNext", hasNext);

        return ResponseEntity.ok(ApiResponse.success(data, "Variants fetched successfully"));
    }

    @GetMapping("/lookup")
    @JsonView(VariantViews.Compact.class)
    public ResponseEntity<ApiResponse<List<Variant>>> getProtectedVariant() {
        List<Variant> variant = variantService.getPrVariant();
        return ResponseEntity.ok(ApiResponse.success(variant, "Variant data retrieved"));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Variant>> getVariantById(@PathVariable Long id) {
        Variant variant = variantService.getVariant(id);
        if (variant == null) {
            return ResponseEntity.ok(ApiResponse.error("Variant not found with ID: " + id));
        }
        return ResponseEntity.ok(ApiResponse.success(variant, "Variant data retrieved"));
    }

//    @GetMapping("/kafka-variant")
//    public ResponseEntity<ApiResponse<Variant>> listingKafkaVarinat() {
//        return ResponseEntity.ok(ApiResponse.success(variant, "Variant data retrieved"));
//    }
//
//    @GetMapping("/kafka-inventory")
//    public ResponseEntity<ApiResponse<Variant>> listingKafkaInventory() {
//        Variant variant = variantService.getVariant(id);
//        if (variant == null) {
//            return ResponseEntity.ok(ApiResponse.error("Variant not found with ID: " + id));
//        }
//        return ResponseEntity.ok(ApiResponse.success(variant, "Variant data retrieved"));
//    }

    @PostMapping
    public ResponseEntity<ApiResponse<Variant>> addVariant(
            @RequestBody Variant variant,
            @RequestParam Long productId) {

        Product managedProduct = productService.getProduct(productId);
        if (managedProduct == null) {
            return ResponseEntity.ok(ApiResponse.error("Invalid Product ID: association failed"));
        }

        variant.setProduct(managedProduct);
        Variant savedVariant = variantService.saveVariant(variant);
        return new ResponseEntity<>(ApiResponse.success(savedVariant, "Variant created successfully"), HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Variant>> updateVariant(
            @PathVariable Long id,
            @RequestBody Variant variant,
            @RequestParam Long productId) {

        Variant existing = variantService.getVariant(id);
        if (existing == null) {
            return ResponseEntity.ok(ApiResponse.error("No variant found with ID: " + id));
        }

        Product product = productService.getProduct(productId);
        if (product == null) {
            return ResponseEntity.ok(ApiResponse.error("Cannot update: Product ID not found"));
        }

        variant.setVariantId(id);
        variant.setProduct(product);
        variant.setCreatedAt(existing.getCreatedAt());

        Variant updatedVariant = variantService.saveVariant(variant);
        return ResponseEntity.ok(ApiResponse.success(updatedVariant, "Variant updated successfully"));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteVariant(@PathVariable Long id) {
        variantService.deleteVariant(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Variant deleted successfully"));
    }
}