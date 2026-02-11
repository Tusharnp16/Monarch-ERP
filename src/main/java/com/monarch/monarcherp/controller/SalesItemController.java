package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.dto.ApiResponse;
import com.monarch.monarcherp.model.SalesInvoice;
import com.monarch.monarcherp.model.SalesItem;
import com.monarch.monarcherp.repository.InvoiceDisplayProjection;
import com.monarch.monarcherp.service.SalesInvoiceService;
import com.monarch.monarcherp.service.SalesItemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/salesitem")
class SalesItemController {

    private final SalesItemService salesItemService;

    @Autowired
    private SalesInvoiceService salesInvoiceService;

    public SalesItemController(SalesItemService salesItemService) {
        this.salesItemService = salesItemService;
    }

    @GetMapping
    public String viewSalesItems(Model model) {
        model.addAttribute("salesItems", salesItemService.getAllSalesItems());
        model.addAttribute("Associate SalesItem",salesItemService.getAllSalesItems());
        return "salesItems";
    }

    @GetMapping("/{id}")
    public String viewSalesItem(@PathVariable Long id, Model model) {
        model.addAttribute("salesItems", java.util.Collections.singletonList(salesItemService.getSalesItem(id)));
        return "salesItems";
    }

    @PostMapping("/add")
    public String addSalesItem(@ModelAttribute SalesItem salesItem) {
        salesItemService.saveSalesItem(salesItem);
        return "redirect:/salesItem";
    }

    @PostMapping("/update")
    public String updateSalesItem(@ModelAttribute SalesItem salesItem) {
//        SalesItem existing = salesItemService.getSalesItem(salesItem.getSalesItemId());
//        if (existing != null) {
//            salesItem.setCreatedAt(existing.getCreatedAt());
//        }
        salesItemService.saveSalesItem(salesItem);
        return "redirect:/salesItem";
    }

    @PostMapping("/delete")
    public String deleteSalesItem(@RequestParam("id") Long id) {
        salesItemService.deleteSalesItem(id);
        return "redirect:/salesItem";
    }

//    @GetMapping("/api/recentitems")
//    @ResponseBody
//    public ResponseEntity<ApiResponse<List<SalesInvoice>>> viewSales() {
//        List<SalesInvoice> salesInvoices = salesInvoiceService.getAllSalesInvoices();
//        return ResponseEntity.ok(ApiResponse.success(salesInvoices,"Data fetched succesfully"));
//    }

    @GetMapping("/api/recentitems")
    @ResponseBody
    public ResponseEntity<ApiResponse<List<InvoiceDisplayProjection>>> viewProjectionSales() {
        List<InvoiceDisplayProjection> projectionSalesInvoices = salesInvoiceService.getAllProjectionSalesInvoices();
        return ResponseEntity.ok(ApiResponse.success(projectionSalesInvoices,"Data fetched succesfully"));
    }

}
