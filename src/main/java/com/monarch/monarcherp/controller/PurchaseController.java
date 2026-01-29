package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.model.Purchase;
import com.monarch.monarcherp.model.PurchaseItem;
import com.monarch.monarcherp.service.ContactService;
import com.monarch.monarcherp.service.PurchaseService;
import com.monarch.monarcherp.service.ReportService;
import com.monarch.monarcherp.service.VariantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/purchase")
class PurchaseController {

    private final PurchaseService purchaseService;

    @Autowired
    private ContactService contactService;

    @Autowired
    private ReportService reportService;

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

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        binder.setAutoGrowCollectionLimit(1000);
    }

    @PostMapping("/add")
    public String addPurchase(@ModelAttribute Purchase purchase,@RequestParam("gstIn") int gstIn) {
        purchaseService.savePurchase(purchase,gstIn);
        return "redirect:/purchase";
    }

    @PostMapping("/update")
    public String updatePurchase(@ModelAttribute Purchase purchase,@RequestParam("gstIn") int gstIn) {
        purchaseService.savePurchase(purchase,gstIn);
        return "redirect:/purchase";
    }

    @PostMapping("/delete")
    public String deletePurchase(@RequestParam Long id) {
        purchaseService.deletePurchase(id);
        return "redirect:/purchase";
    }

    @GetMapping("/report")
    public String getExpiringItemsReport(Model model) {
        Map<String, List<PurchaseItem>> groupedItems = reportService.getPurchaseItemByExpire();
        model.addAttribute("groupedItems", groupedItems);
        return "purchase-expiry-report";
    }


}
