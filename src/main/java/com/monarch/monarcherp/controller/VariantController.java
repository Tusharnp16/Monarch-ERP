package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.model.Product;
import com.monarch.monarcherp.model.Variant;
import com.monarch.monarcherp.service.ProductService;
import com.monarch.monarcherp.service.VariantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/variants")
class VariantController {

    @Autowired
    private VariantService variantService;
    @Autowired
    private ProductService productService;

//    @GetMapping
//    public String viewVariant(Model model) {
//        model.addAttribute("variants", variantService.getAllVariants());
//        model.addAttribute("parentProducts",productService.getAllProducts(2500,20));
//        return "variants";
//    }


//    @GetMapping("/contact")
//    public String health() {
//        return "contacts";
//    }


    @GetMapping
    public String viewPaginatedVariant(@RequestParam(value = "lastId",required = false) Long lastId, Model model) {

       Long finalId= lastId == null ? 0L : lastId;

        List<Variant> variants = variantService.getPaginatedVariant(finalId);

        Long nextCursor = null;
        boolean hasNext = false;

        if (!variants.isEmpty()) {
            nextCursor = variants.get(variants.size() - 1).getVariantId();
            hasNext = variants.size() == 10;
        }

        model.addAttribute("variants", variants);
        model.addAttribute("nextCursor", nextCursor);
        model.addAttribute("hasNext", hasNext);
        model.addAttribute("parentProducts", productService.getAllProducts(2500, 20));
        return "variants";
    }


    @GetMapping("/{id}")
    public String viewVariant(@PathVariable Long id, Model model) {
        model.addAttribute("variants", java.util.Collections.singletonList(variantService.getVariant(id)));
        return "variants";
    }

    @PostMapping("/add")
    public String addVariant(@ModelAttribute Variant variant,@RequestParam Long productId) {
        Product managedProduct = productService.getProduct(productId);
        variant.setProduct(managedProduct);
        variantService.saveVariant(variant);
        return "redirect:/variants";
    }

    @PostMapping("/update")
    public String updateVariantName(@ModelAttribute Variant variant,Long productId) {
        Variant existing = variantService.getVariant(variant.getVariantId());
        Product product=productService.getProduct(productId);
        variant.setProduct(product);

        if (existing != null) {
            variant.setCreatedAt(existing.getCreatedAt());
        }
        variantService.saveVariant(variant);
        return "redirect:/variants";
    }

    @PostMapping("/delete")
    public String deleteVariant(@RequestParam Long id) {
        variantService.deleteVariant(id);
        return "redirect:/variants";
    }

}