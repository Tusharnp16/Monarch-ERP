package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.dto.ApiResponse;
import com.monarch.monarcherp.model.Product;
import com.monarch.monarcherp.model.PurchaseItem;
import com.monarch.monarcherp.repository.PurchaseDetailProjection;
import com.monarch.monarcherp.service.PurchaseItemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/purchaseitem")
public class PurchaseItemController {

    @Autowired
    private PurchaseItemService purchaseItemService;

//    @Autowired
//    private ProductService productService;

//    @GetMapping
//    public String viewPurchaseItems(Model model) {
//        model.addAttribute("purchaseItems", purchaseItemService.getAllPurchaseItems());
////        model.addAttribute("parentProducts",productService.getAllProducts());
//        return "purchase-item";
//    }

    @GetMapping("/pr/{id}")
    @ResponseBody
    public ResponseEntity<ApiResponse<List<PurchaseDetailProjection>>> viewPurchaseItems(@PathVariable("id") Long id) {
        return ResponseEntity.ok(ApiResponse.success(purchaseItemService.getPurchaseItems(id),"Data Fetched"));
    }


    @GetMapping("/{id}")
    public String viewPurchaseItem(@PathVariable Long id, Model model) {
        model.addAttribute("purchaseItems", java.util.Collections.singletonList(purchaseItemService.getPurchaseItem(id)));
        return "purchase-item";
    }

    @PostMapping("/add")
    public String addPurchaseItem(@ModelAttribute PurchaseItem purchaseItem,@RequestParam("gstIn") int gstIn) {
//        Product managedProduct = productService.getProduct(productId);
//        purchaseItem.setProduct(managedProduct);
          purchaseItemService.savePurchaseItems(purchaseItem,gstIn);
        return "redirect:/purchase-item";
    }

    @PostMapping("/update")
    public String updatePurchaseItemName(@ModelAttribute PurchaseItem purchaseItem, Long purchaseId,@RequestParam("gstIn") int gstIn) {
          PurchaseItem existing = purchaseItemService.getPurchaseItem(purchaseItem.getPurchaseItemId());
//        Product product=productService.getProduct(productId);
//        purchaseItem.setProduct(product);
//
//        if (existing != null) {
//            purchaseItem.setCreatedAt(existing.getCreatedAt());
//        }
        purchaseItemService.savePurchaseItems(existing,gstIn);
    return "redirect:/purchase-item";
    }

    @PostMapping("/delete")
    public String deletePurchaseItem(@RequestParam Long id) {
        purchaseItemService.deletePurchaseItem(id);
        return "redirect:/purchase-item";
    }


}
