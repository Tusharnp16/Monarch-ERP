package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.model.Inventory;
import com.monarch.monarcherp.model.SalesInvoice;
import com.monarch.monarcherp.service.CustomerService;
import com.monarch.monarcherp.service.InventoryService;
import com.monarch.monarcherp.service.SalesInvoiceService;
import com.monarch.monarcherp.service.VariantService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/salesinvoice")
class SalesInvoiceController {

    private final SalesInvoiceService salesInvoiceService;
    private final CustomerService customerService;
    private final InventoryService inventoryService;

    SalesInvoiceController(SalesInvoiceService salesInvoiceService, CustomerService customerService, VariantService variantService, InventoryService inventoryService) {
        this.salesInvoiceService = salesInvoiceService;
        this.customerService = customerService;
        this.inventoryService = inventoryService;
    }

    @GetMapping
    public String viewSalesInvoices(Model model) {
        model.addAttribute("salesInvoices", salesInvoiceService.getAllSalesInvoices());
        model.addAttribute("customers", customerService.getAllCustomers());

        List<Inventory> activeInventory = inventoryService.getInventory().stream()
                        .filter(i->i.getVariant()!=null)
                        .collect(Collectors.toList());
        model.addAttribute("inventory", activeInventory);
        return "sales";
    }

    @GetMapping("/{id}")
    public String viewSalesInvoice(@PathVariable Long id, Model model) {
        model.addAttribute("salesInvoices", java.util.Collections.singletonList(salesInvoiceService.getSalesInvoice(id)));
        return "sales";
    }

    @PostMapping("/add")
    public String addSalesInvoice(@ModelAttribute SalesInvoice salesInvoice) {
        salesInvoiceService.saveSalesInvoice(salesInvoice);
        return "redirect:/salesinvoice";
    }

    @PostMapping("/update")
    public String updateSalesInvoice(@ModelAttribute SalesInvoice salesInvoice) {
//        SalesInvoice existing = salesInvoiceService.getSalesInvoice(salesInvoice.getSalesInvoiceId());
//        if (existing != null) {
//            salesInvoice.setCreatedAt(existing.getCreatedAt());
//        }
        salesInvoiceService.saveSalesInvoice(salesInvoice);
        return "redirect:/salesinvoice";
    }

    @PostMapping("/delete")
    public String deleteSalesInvoice(@RequestParam("id") Long id) {
        salesInvoiceService.deleteSalesInvoice(id);
        return "redirect:/salesinvoice";
    }

}
