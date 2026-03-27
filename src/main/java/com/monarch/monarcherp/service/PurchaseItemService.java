package com.monarch.monarcherp.service;

import com.monarch.monarcherp.model.*;
import com.monarch.monarcherp.model.enums.TransactionType;
import com.monarch.monarcherp.repository.*;
import com.monarch.monarcherp.service.tax.TaxStrategy;
import jakarta.persistence.EntityManager;
import jakarta.transaction.Transactional;
import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Service
public class PurchaseItemService {

    @Autowired
    TaxFactoryService taxFactoryService;
    @Autowired
    private PurchaseItemRepository purchaseItemRepository;
    @Autowired
    private InventoryRepository inventoryRepository;

    @Autowired
    private StockMasterRepository stockMasterRepository;
    @Autowired
    private StockMasterService stockMasterService;

    @Autowired
    private VariantRepository variantRepository;
    @Autowired
    private PurchaseRepository purchaseRepository;

    @Autowired
    private EntityManager entityManager;

    @Autowired
    UserRepository userRepository;

    @Autowired
    StockMasterTransactionService stockMasterTransactionService;

    @Autowired
    UserService userService;

    @Transactional
    public void savePurchaseItems(PurchaseItem request, int gstIn,String refId) {

        User currentUser = userService.getAuthnicatedUser();

        Boolean isInterState = gstIn == 24 ? false : true;

        System.out.println("DEBUG: Received Price: " + request.getPrice().getPrice());
        System.out.println("DEBUG: Received Qty: " + request.getQty());

        TaxStrategy strategy = taxFactoryService.getStrategy(isInterState);

        Money taxAmount = strategy.calculateGST(request.getPrice());
        request.setTaxAmount(taxAmount);
        BigDecimal unitLanding = request.getPrice().toBigDecimal().add(taxAmount.toBigDecimal());
        request.setLandingCost(new Money(unitLanding));

        BigDecimal totalNet = unitLanding.multiply(new BigDecimal(request.getQty()));
        request.setNetAmount(new Money(totalNet));

        Purchase purchase = purchaseRepository.findPurchaseByPurchaseId(request.getPurchase().getPurchaseId());

        purchase.setTotalAmount(new Money(totalNet));

        System.out.println("final Debug : " + purchase.getTotalAmount());
        purchaseRepository.save(purchase);

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
        inventory.setUser(currentUser);

        inventory = inventoryRepository.save(inventory);

        Optional<StockMaster> existingStock = stockMasterRepository
                .findByVariantAndPurchasePriceAndExpiryDate(
                        fullVariant,
                        request.getPrice(),
                        request.getExpireDate()
                );

        StockMaster stockToUpdate;

        if (existingStock.isPresent()) {
            stockToUpdate = existingStock.get();
            int newQty = stockToUpdate.getQuantity() + request.getQty();
            stockToUpdate.setQuantity(newQty);
        } else {
            stockToUpdate = new StockMaster();
            stockToUpdate.setVariant(fullVariant);
            stockToUpdate.setPurchasePrice(request.getPrice());
            stockToUpdate.setExpiryDate(request.getExpireDate());
            stockToUpdate.setQuantity(request.getQty());
            stockToUpdate.setLandingCost(request.getLandingCost());
            stockToUpdate.setInventory(inventory);
            stockToUpdate.setMrp(fullVariant.getMrp());
            stockToUpdate.setSellingPrice(fullVariant.getSellingPrice());

            stockToUpdate = stockMasterRepository.save(stockToUpdate);
            stockToUpdate.setBatchNo(stockMasterService.generateBatch(stockToUpdate));
        }

        stockToUpdate = stockMasterRepository.save(stockToUpdate);

        request.setStockMaster(stockToUpdate);

//        stockMasterTransactionService.recordTransaction(
//                request.getQty(), 0, TransactionType.PURCHASE, "PUR-", refId, currentUser, inventory
//        );
//
//        purchaseItemRepository.save(request);

//        StockMaster newStock = new StockMaster();
//        newStock.setExpiryDate(request.getExpireDate());
//        newStock.setVariant(fullVariant);
//        newStock.setQuantity(request.getQty());
//        newStock.setPurchasePrice(request.getPrice());
//        newStock.setLandingCost(request.getLandingCost());
//        newStock.setInventory(inventory);
//        newStock.setMrp(fullVariant.getMrp());
//        newStock.setSellingPrice(fullVariant.getSellingPrice());
//
//        newStock = stockMasterRepository.save(newStock);
//
//        newStock.setBatchNo(stockMasterService.generateBatch(newStock));
//        newStock = stockMasterRepository.save(newStock);

//        request.setStockMaster(newStock);

//        stockMasterTransactionService.recordTransaction(request.getQty(),0, TransactionType.PURCHASE,"PUR-",refId,currentUser,inventory);

        purchaseItemRepository.save(request);
    }

    public PurchaseItem getPurchaseItem(Long id) {
        return purchaseItemRepository.getPurchaseItemBypurchaseItemId(id);
    }

    public List<PurchaseItem> getAllPurchaseItems() {
        Session session = entityManager.unwrap(Session.class);
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
        purchaseItemRepository.findById(id).orElseThrow(() -> new RuntimeException("Not found"));
        return purchaseItemRepository.save(updatedData);
    }

    public List<PurchaseDetailProjection> getPurchaseItems(Long purchaseId) {
        return purchaseItemRepository.findAllByPurchasePurchaseId(purchaseId);
    }

}
