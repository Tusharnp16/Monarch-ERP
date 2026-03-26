package com.monarch.monarcherp.service;

import com.monarch.monarcherp.model.Contact;
import com.monarch.monarcherp.model.Inventory;
import com.monarch.monarcherp.model.StockTransaction;
import com.monarch.monarcherp.model.User;
import com.monarch.monarcherp.model.enums.TransactionType;
import com.monarch.monarcherp.repository.StockTransactionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;


@Service
public class StockMasterTransactionService {

    @Autowired
    StockTransactionRepository stockTransactionRepository;

    @Transactional(propagation = Propagation.REQUIRED)
    public void recordTransaction(int inqty, int outqty, TransactionType type, String refPrefix, String refId, User user, Inventory inventory) {

        StockTransaction transaction = new StockTransaction();
        transaction.setType(type);
        transaction.setUser(user);
        transaction.setInventory(inventory);
        transaction.setTotalQuantity(inventory.getAvailableQuantity());

        if (type == TransactionType.PURCHASE || type == TransactionType.RETURN) {
            transaction.setInQuantity(inqty);
            transaction.setOutQuantity(0);

        } else {
            transaction.setInQuantity(0);
            transaction.setOutQuantity(outqty);
        }

        transaction.setReferenceId(refPrefix + "-" + refId);

//        String variantName = stockMaster.getVariant() != null ? stockMaster.getVariant().getVariantName() : "Unknown";
//        transaction.setRemarks(type + " of " + variantName + " | Batch: " + stockMaster.getBatchNo());

        stockTransactionRepository.save(transaction);
    }

    public List<StockTransaction> getAllStockTransactions() {
        return stockTransactionRepository.findAllByOrderByStockTransactionIdDesc();
    }
}
