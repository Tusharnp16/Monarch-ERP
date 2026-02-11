package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.config.DiscountConfig;
import com.monarch.monarcherp.model.Inventory;
import com.monarch.monarcherp.model.SalesInvoice;
import com.monarch.monarcherp.repository.SalesInvoiceRepository;
import com.monarch.monarcherp.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/salesinvoice")
class SalesInvoiceController {

    private final SalesInvoiceService salesInvoiceService;
    private final SalesItemService salesItemService;
    private final CustomerService customerService;
    private final InventoryService inventoryService;
    private final DiscountConfig discountConfig;
    private final NotificationService notificationService;

    @Autowired
    private SalesInvoiceRepository salesInvoiceRepository;

    SalesInvoiceController(SalesInvoiceService salesInvoiceService, CustomerService customerService, VariantService variantService, InventoryService inventoryService, SalesItemService salesItemService, DiscountConfig discountConfig, NotificationService notificationService) {
        this.salesInvoiceService = salesInvoiceService;
        this.customerService = customerService;
        this.inventoryService = inventoryService;
        this.salesItemService=salesItemService;
        this.discountConfig = discountConfig;
        this.notificationService = notificationService;
    }

    @GetMapping
    public String viewSalesInvoices(Model model) {
        model.addAttribute("salesInvoices", salesInvoiceService.getAllSalesInvoices());
        model.addAttribute("customers", customerService.getAllCustomers());

        List<Inventory> activeInventory = inventoryService.getInventory().stream()
                        .filter(i->i.getVariant()!=null)
                        .collect(Collectors.toList());
        model.addAttribute("inventory", activeInventory);

        model.addAttribute("maxDiscountLimit", discountConfig.getMaxDiscountValue());

        try {
            List<Object[]> topSeller = salesItemService.getWeeklySales();
            System.out.println("Data found: " + topSeller.size());
            model.addAttribute("topSellers", topSeller);
        } catch (Exception e) {
            System.out.println("Error fetching top sellers: " + e.getMessage());
            e.printStackTrace();
        }
        return "sales";
    }

    @GetMapping("/{id}")
    public String viewSalesInvoice(@PathVariable Long id, Model model) {
        model.addAttribute("salesInvoices", java.util.Collections.singletonList(salesInvoiceService.getSalesInvoice(id)));
        return "sales";
    }

    @GetMapping("/salesinvoice/view")
    public String viewInvoice(Model model) {

        model.addAttribute("invoice", salesInvoiceService.getAllSalesInvoices());
        model.addAttribute("items", salesItemService.getAllSalesItems());
        model.addAttribute("customer", customerService.getAllCustomers());

        return "salesview";
    }

    @PostMapping("/add")
    public String addSalesInvoice(@ModelAttribute SalesInvoice salesInvoice) {
        System.out.println(salesInvoice.getCustomer());
        System.out.println(salesInvoice.getItems());

        System.out.println(salesInvoice.getId());
        salesInvoiceService.saveSalesInvoice(salesInvoice);

        System.out.println(salesInvoice.getId());

            if(salesInvoice.getCustomer().getEmail()!=null){
                notificationService.sendInvoiceEmail(salesInvoice);
            }
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

    @GetMapping("/next-number")
    @ResponseBody
    public String getNextInvoiceNumber() {
        String financialYear = salesInvoiceService.getFinancialYear();
        String prefix = "INV/" + financialYear + "/";

        long count = salesInvoiceRepository.countByFinancialYearPrefix(prefix) + 1;
        return prefix + String.format("%04d", count);
    }
}
