package com.monarch.monarcherp.service;

import com.monarch.monarcherp.dto.PurchaseDTO;
import com.monarch.monarcherp.model.Purchase;
import com.monarch.monarcherp.model.PurchaseItem;
import com.monarch.monarcherp.repository.PurchaseItemRepository;
import com.monarch.monarcherp.repository.PurchaseRepository;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class PurchaseService {


    private final PurchaseItemService purchaseItemService;
    private PurchaseRepository purchaseRepository;

    PurchaseService(PurchaseRepository purchaseRepository, PurchaseItemRepository purchaseItemRepository, PurchaseItemService purchaseItemService) {
        this.purchaseRepository = purchaseRepository;
        this.purchaseItemService = purchaseItemService;
    }

    @Transactional
    public Purchase savePurchase(Purchase purchase, int gstIn) {

        System.out.println("DEBUG : " + purchase.getTotalAmount());
        System.out.println("DEBUG : " + purchase.getBillNo());
        System.out.println("DEBUG : " + gstIn);

        purchase.setTotalAmount(purchase.getItems().get(0).getNetAmount());

        System.out.println("DEBUG : " + purchase.getItems().get(0).getNetAmount());

        Purchase savedPurchase = purchaseRepository.save(purchase);

        if (purchase.getItems() != null) {
            for (PurchaseItem item : purchase.getItems()) {
                item.setPurchase(savedPurchase);
                purchaseItemService.savePurchaseItems(item, gstIn);
            }
        }
        return savedPurchase;
    }

    public Purchase getPurchase(Long id) {
        return purchaseRepository.findPurchaseByPurchaseId(id);
    }

    public List<Purchase> getAllPurchases() {
        return purchaseRepository.findAll();
    }

    public void deletePurchase(Long id) {
        purchaseRepository.deleteById(id);
    }

    public long getTotalPurchases() {
        return purchaseRepository.count();
    }

    public boolean purchaseExists(Long id) {
        return purchaseRepository.existsById(id);
    }

    public Purchase updatePurchaseName(Long id, String newName) {
        Purchase purchase = purchaseRepository.findById(id).orElseThrow(() -> new RuntimeException("Not found"));
        return purchaseRepository.save(purchase);
    }


    public String getFinancialYear() {
        LocalDate today = LocalDate.now();
        int year = today.getYear();
        int month = today.getMonthValue();

        if (month >= 4) {
            return year + "-" + String.valueOf(year + 1).substring(2);
        } else {
            return (year - 1) + "-" + String.valueOf(year).substring(2);
        }
    }

    public List<PurchaseDTO> purchaseSummary() {
        return purchaseRepository.findAllPurchaseSummaries();
    }


}
