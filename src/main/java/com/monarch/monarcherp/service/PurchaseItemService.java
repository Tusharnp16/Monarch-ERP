package com.monarch.monarcherp.service;

import com.monarch.monarcherp.model.PurchaseItem;
import com.monarch.monarcherp.model.StockMaster;
import com.monarch.monarcherp.repository.PurchaseItemRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PurchaseItemService {

    @Autowired
    private PurchaseItemRepository purchaseItemRepository;

    @Transactional
    public void savePurchase(PurchaseItem request) {

        StockMaster newStock = new StockMaster();
        newStock.setExpiryDate(request.getExpireDate());
        newStock.setVariant(request.getVariant());
        newStock.setQuantity(request.getQty());
        newStock.setPurchasePrice(request.getPrice());
        newStock.setLandingCost(request.getLandingCost());

//        PurchaseItem pItem = new PurchaseItem();
//        pItem.setQty(request.getQty());
//        pItem.setPrice(request.getPrice());
//        pItem.setVariant(request.getVariant());

//        pItem.setStockMaster(newStock);

        purchaseItemRepository.save(request);
    }

    public PurchaseItem getPurchaseItem(Long id) {
        return purchaseItemRepository.getPurchaseItemBypurchaseItemId(id);
    }

    public List<PurchaseItem> getAllPurchaseItems() {
        return purchaseItemRepository.findAll();
    }

    public void deletePurchaseItem(Long id) {
        purchaseItemRepository.deleteById(id);
    }

    public long getTotalPurchaseItems() {
        return purchaseItemRepository.count();
    }

    public boolean purchaseItemExists(Long id) {
        return purchaseItemRepository.existsById(id);
    }

    public PurchaseItem updatePurchaseItem(Long id, PurchaseItem updatedData) {
        purchaseItemRepository.findById(id).orElseThrow(()-> new RuntimeException("Not found"));
        return purchaseItemRepository.save(updatedData);
    }

}
