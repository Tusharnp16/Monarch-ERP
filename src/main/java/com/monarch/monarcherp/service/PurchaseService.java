package com.monarch.monarcherp.service;

import com.monarch.monarcherp.model.Purchase;
import com.monarch.monarcherp.repository.PurchaseRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PurchaseService {


    private PurchaseRepository purchaseRepository;

    PurchaseService(PurchaseRepository purchaseRepository) {
        this.purchaseRepository = purchaseRepository;
    }

    public Purchase savePurchase(Purchase purchase) {
        return purchaseRepository.save(purchase);
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
        Purchase purchase= purchaseRepository.findById(id).orElseThrow(()-> new RuntimeException("Not found"));
        return  purchaseRepository.save(purchase);
    }



}
