package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.dto.ApiResponse;
import com.monarch.monarcherp.dto.SalesItemDTO;
import com.monarch.monarcherp.model.SalesItem;
import com.monarch.monarcherp.repository.InvoiceDisplayProjection;
import com.monarch.monarcherp.service.JasperReportService;
import com.monarch.monarcherp.service.SalesInvoiceService;
import com.monarch.monarcherp.service.SalesItemService;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

@Controller
@RequestMapping("/api/salesitem")
class SalesItemController {

    private final SalesItemService salesItemService;
    private final JasperReportService jasperReportService;

    @Autowired
    private SalesInvoiceService salesInvoiceService;

    public SalesItemController(SalesItemService salesItemService, JasperReportService jasperReportService) {
        this.salesItemService = salesItemService;
        this.jasperReportService = jasperReportService;
    }

    @GetMapping
    public String viewSalesItems(Model model) {
        model.addAttribute("salesItems", salesItemService.getAllSalesItems());
        model.addAttribute("Associate SalesItem", salesItemService.getAllSalesItems());
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

    @GetMapping("/recentitems")
    @ResponseBody
    public ResponseEntity<ApiResponse<List<InvoiceDisplayProjection>>> viewProjectionSales() {
        List<InvoiceDisplayProjection> projectionSalesInvoices = salesInvoiceService.getAllProjectionSalesInvoices();
        return ResponseEntity.ok(ApiResponse.success(projectionSalesInvoices, "Data fetched succesfully"));
    }

    @GetMapping("/invoice-items/{invoiceId}")
    @ResponseBody
    public ResponseEntity<ApiResponse<List<SalesItemDTO>>> getInvoiceItems(@PathVariable Long invoiceId) {
        List<SalesItemDTO> items = salesInvoiceService.getSaleItemById(invoiceId);
        return ResponseEntity.ok(ApiResponse.success(items, "Items fetched"));
    }

    @GetMapping("/invoice/print/{id}")
    public ResponseEntity<byte[]> printInvoice(@PathVariable Long id) {
        try {
            byte[] pdfContent = jasperReportService.generateInvoice(id);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_PDF);
            headers.setContentDisposition(ContentDisposition.inline().filename("Invoice_" + id + ".pdf").build());

            return new ResponseEntity<>(pdfContent, headers, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.EARLY_HINTS);
        }
    }

    @GetMapping("/export/monthly")
    public void exportSales(@RequestParam int month, @RequestParam int year, HttpServletResponse response) throws IOException {

        try {
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            String fileName = String.format("Sales_Export_%d_%d.xlsx", month, year);
            response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
            salesInvoiceService.exportMonthlySalesToStream(month, year, response.getOutputStream());
            response.flushBuffer();
        } catch (IOException e) {
            response.sendError(500, "Internet Issues");
        }
    }
}
