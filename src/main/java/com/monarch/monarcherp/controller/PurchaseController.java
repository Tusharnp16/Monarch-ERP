package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.dto.ApiResponse;
import com.monarch.monarcherp.dto.PurchaseDTO;
import com.monarch.monarcherp.model.Purchase;
import com.monarch.monarcherp.model.PurchaseItem;
import com.monarch.monarcherp.repository.PurchaseRepository;
import com.monarch.monarcherp.service.PurchaseService;
import com.monarch.monarcherp.service.ReportService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/purchase")
public class PurchaseController {

    private final PurchaseService purchaseService;
    private final ReportService reportService;
    private final PurchaseRepository purchaseRepository;
    private long count;

    public PurchaseController(PurchaseService purchaseService, ReportService reportService, PurchaseRepository purchaseRepository) {
        this.purchaseService = purchaseService;
        this.reportService = reportService;
        this.purchaseRepository = purchaseRepository;
    }

    @GetMapping("/pr")
    public ResponseEntity<ApiResponse<List<Purchase>>> getAllPurchases() {
        List<Purchase> purchases = purchaseService.getAllPurchases();
        return ResponseEntity.ok(ApiResponse.success(purchases, "Purchases retrieved successfully"));
    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<PurchaseDTO>>> getAllPurchasesDTO() {
        List<PurchaseDTO> purchases = purchaseService.purchaseSummary();
        return ResponseEntity.ok(ApiResponse.success(purchases, "Purchases retrieved successfully"));
    }

    @GetMapping("/items/{id}")
    public ResponseEntity<ApiResponse<Purchase>> getPurchaseById(@PathVariable Long id) {
        Purchase purchase = purchaseService.getPurchase(id);
        if (purchase == null) {
            return ResponseEntity.status(404).body(ApiResponse.error("Purchase not found"));
        }
        return ResponseEntity.ok(ApiResponse.success(purchase, "Purchase found"));
    }

    @PostMapping("/add")
    public ResponseEntity<ApiResponse<Purchase>> addPurchase(@RequestBody Purchase purchase, @RequestParam("gstIn") int gstIn) {
        Purchase savedPurchase = purchaseService.savePurchase(purchase, gstIn);
        return ResponseEntity.ok(ApiResponse.success(savedPurchase, "Purchase created successfully"));
    }

    @PutMapping("/update")
    public ResponseEntity<ApiResponse<Purchase>> updatePurchase(@RequestBody Purchase purchase, @RequestParam("gstIn") int gstIn) {
        Purchase updatedPurchase = purchaseService.savePurchase(purchase, gstIn);
        return ResponseEntity.ok(ApiResponse.success(updatedPurchase, "Purchase updated successfully"));
    }

    public ResponseEntity<ApiResponse<Void>> deletePurchase(@PathVariable Long id) {
        purchaseService.deletePurchase(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Purchase deleted successfully"));
    }

    public ResponseEntity<ApiResponse<Map<String, List<PurchaseItem>>>> getExpiryReport() {
        Map<String, List<PurchaseItem>> report = reportService.getPurchaseItemByExpire();
        return ResponseEntity.ok(ApiResponse.success(report, "Expiry report generated"));
    }


    @GetMapping("/next-number")
    @ResponseBody
    public String getNextInvoiceNumber() {
        String financialYear = purchaseService.getFinancialYear();
        String prefix = "BILL/" + financialYear + "/";

        long count = purchaseRepository.countByFinancialYearPrefix(prefix) + 1;
        return prefix + String.format("%04d", count);
    }
}
