package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.model.Purchase;
import com.monarch.monarcherp.service.ContactService;
import com.monarch.monarcherp.service.PurchaseService;
import com.monarch.monarcherp.service.VariantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/purchase")
class PurchaseController {

    private final PurchaseService purchaseService;

    @Autowired
    private ContactService contactService;

    @Autowired
    private VariantService variantService;

    public PurchaseController(PurchaseService purchaseService) {
        this.purchaseService = purchaseService;
    }

    @GetMapping
    public String viewPurchases(Model model) {
        model.addAttribute("purchases", purchaseService.getAllPurchases());
        model.addAttribute("variants",variantService.getAllVariants());
        model.addAttribute("suppliers",contactService.getAllContacts());
        return "purchases";
    }

    @GetMapping("/{id}")
    public String viewPurchase(@PathVariable Long id, Model model) {
        model.addAttribute("purchases", java.util.Collections.singletonList(purchaseService.getPurchase(id)));
        return "purchases";
    }

    @PostMapping("/add")
    public String addPurchase(@ModelAttribute Purchase purchase) {
        purchaseService.savePurchase(purchase);

        return "redirect:/purchases";
    }

    @PostMapping("/update")
    public String updatePurchase(@ModelAttribute Purchase purchase) {
        purchaseService.savePurchase(purchase);
        return "redirect:/purchase/" + purchase.getPurchaseId();
    }

    @PostMapping("/delete")
    public String deletePurchase(@RequestParam Long id) {
        purchaseService.deletePurchase(id);
        return "redirect:/purchase";
    }

}
