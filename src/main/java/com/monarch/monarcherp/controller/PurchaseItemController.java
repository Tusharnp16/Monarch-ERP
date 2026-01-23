package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.model.Product;
import com.monarch.monarcherp.model.PurchaseItem;
import com.monarch.monarcherp.service.PurchaseItemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/purchaseitem")
public class PurchaseItemController {

    @Autowired
    private PurchaseItemService purchaseItemService;

//    @Autowired
//    private ProductService productService;

    @GetMapping
    public String viewPurchaseItems(Model model) {
        model.addAttribute("purchaseItems", purchaseItemService.getAllPurchaseItems());
//        model.addAttribute("parentProducts",productService.getAllProducts());
        return "purchase-item";
    }

    @GetMapping("/{id}")
    public String viewPurchaseItem(@PathVariable Long id, Model model) {
        model.addAttribute("purchaseItems", java.util.Collections.singletonList(purchaseItemService.getPurchaseItem(id)));
        return "purchase-item";
    }

    @PostMapping("/add")
    public String addPurchaseItem(@ModelAttribute PurchaseItem purchaseItem) {
//        Product managedProduct = productService.getProduct(productId);
//        purchaseItem.setProduct(managedProduct);
          purchaseItemService.savePurchaseItems(purchaseItem);
        return "redirect:/purchase-item";
    }

    @PostMapping("/update")
    public String updatePurchaseItemName(@ModelAttribute PurchaseItem purchaseItem, Long purchaseId) {
          PurchaseItem existing = purchaseItemService.getPurchaseItem(purchaseItem.getPurchaseItemId());
//        Product product=productService.getProduct(productId);
//        purchaseItem.setProduct(product);
//
//        if (existing != null) {
//            purchaseItem.setCreatedAt(existing.getCreatedAt());
//        }
        purchaseItemService.savePurchaseItems(existing);
    return "redirect:/purchase-item";
    }

    @PostMapping("/delete")
    public String deletePurchaseItem(@RequestParam Long id) {
        purchaseItemService.deletePurchaseItem(id);
        return "redirect:/purchase-item";
    }
}
