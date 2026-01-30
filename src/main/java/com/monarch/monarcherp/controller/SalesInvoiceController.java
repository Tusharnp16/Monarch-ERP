package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.model.Customer;
import com.monarch.monarcherp.model.SalesInvoice;
import com.monarch.monarcherp.service.SalesInvoiceService;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/salesinvoice")
class SalesInvoiceController {

    private final SalesInvoiceService salesInvoiceService;

    public SalesInvoiceController(SalesInvoiceService salesInvoiceService) {
        this.salesInvoiceService = salesInvoiceService;
    }

    @GetMapping
    public String viewSalesInvoices(Model model) {
        model.addAttribute("salesInvoices", salesInvoiceService.getAllSalesInvoices());
        model.addAttribute("Associate SalesInvoice",salesInvoiceService.getAllSalesInvoices());
        return "salesInvoices";
    }

    @GetMapping("/{id}")
    public String viewSalesInvoice(@PathVariable Long id, Model model) {
        model.addAttribute("salesInvoices", java.util.Collections.singletonList(salesInvoiceService.getSalesInvoice(id)));
        return "salesInvoices";
    }

    @PostMapping("/add")
    public String addSalesInvoice(@ModelAttribute SalesInvoice salesInvoice) {
        salesInvoiceService.saveSalesInvoice(salesInvoice);
        return "redirect:/salesInvoice";
    }

    @PostMapping("/update")
    public String updateSalesInvoice(@ModelAttribute SalesInvoice salesInvoice) {
//        SalesInvoice existing = salesInvoiceService.getSalesInvoice(salesInvoice.getSalesInvoiceId());
//        if (existing != null) {
//            salesInvoice.setCreatedAt(existing.getCreatedAt());
//        }
        salesInvoiceService.saveSalesInvoice(salesInvoice);
        return "redirect:/salesInvoice";
    }

    @PostMapping("/delete")
    public String deleteSalesInvoice(@RequestParam("id") Long id) {
        salesInvoiceService.deleteSalesInvoice(id);
        return "redirect:/salesInvoice";
    }


}
