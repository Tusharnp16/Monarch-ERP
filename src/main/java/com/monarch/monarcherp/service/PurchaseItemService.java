package com.monarch.monarcherp.service;

import com.monarch.monarcherp.model.*;
import com.monarch.monarcherp.repository.InventoryRepository;
import com.monarch.monarcherp.repository.PurchaseItemRepository;
import com.monarch.monarcherp.repository.StockMasterRepository;
import com.monarch.monarcherp.repository.VariantRepository;
import com.monarch.monarcherp.service.tax.TaxStrategy;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

@Service
public class PurchaseItemService {

    @Autowired
    private PurchaseItemRepository purchaseItemRepository;

    @Autowired
    TaxFactoryService taxFactoryService;

    @Autowired
    private InventoryRepository inventoryRepository;

    @Autowired
    private StockMasterRepository stockMasterRepository;
    @Autowired
    private StockMasterService stockMasterService;

    @Autowired
    private VariantRepository variantRepository;

    @Transactional
    public void savePurchaseItems(PurchaseItem request,boolean isInterState) {

        System.out.println("DEBUG: Received Price: " + request.getPrice().getPrice());
        System.out.println("DEBUG: Received Qty: " + request.getQty());

        TaxStrategy strategy = taxFactoryService.getStrategy(isInterState);

        Money taxAmount = strategy.calculateGST(request.getPrice());
        request.setTaxAmount(taxAmount);
        BigDecimal unitLanding = request.getPrice().toBigDecimal().add(taxAmount.toBigDecimal());
        request.setLandingCost(new Money(unitLanding));

        BigDecimal totalNet = unitLanding.multiply(new BigDecimal(request.getQty()));
        request.setNetAmount(new Money(totalNet));

        Variant fullVariant = variantRepository.findById(request.getVariant().getVariantId())
                .orElseThrow(() -> new RuntimeException("Variant not found"));

        request.setVariant(fullVariant);

        Inventory inventory = inventoryRepository.findByVariant(fullVariant)
                .orElse(new Inventory());

        int currentQty = (inventory.getQuantity() != 0) ? inventory.getQuantity() : 0;
        inventory.setQuantity(currentQty + request.getQty());
        inventory.setAvailableQuantity(inventory.getQuantity());
        inventory.setAverageCost(request.getLandingCost());
        inventory.setVariant(fullVariant);

        inventory = inventoryRepository.save(inventory);

        StockMaster newStock = new StockMaster();
        newStock.setExpiryDate(request.getExpireDate());
        newStock.setVariant(fullVariant);
        newStock.setQuantity(request.getQty());
        newStock.setPurchasePrice(request.getPrice());
        newStock.setLandingCost(request.getLandingCost());
        newStock.setInventory(inventory);

        newStock = stockMasterRepository.save(newStock);

        newStock.setBatchNo(stockMasterService.generateBatch(newStock));
        newStock = stockMasterRepository.save(newStock);

        request.setStockMaster(newStock);
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
