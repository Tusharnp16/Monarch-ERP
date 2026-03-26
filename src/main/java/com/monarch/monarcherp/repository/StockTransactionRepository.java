package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.dto.StockLedgerDTO;
import com.monarch.monarcherp.model.StockTransaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface StockTransactionRepository extends JpaRepository<StockTransaction,Long> {

    @Query("SELECT new com.monarch.monarcherp.dto.StockLedgerDTO(" +
            "st.inventory.variant.variantName, " +
            "st.inventory.variant.product.productName, " +
            "st.inventory.variant.product.itemCode, " +
            "st.type, " +
            "st.inQuantity, " +
            "st.outQuantity, " +
            "st.totalQuantity, " +
            "st.referenceId, " +
            "st.transactionDate, " +
            "st.user.userId) " +
            "FROM StockTransaction st ORDER BY st.stockTransactionId DESC")
    List<StockLedgerDTO> findAllStockLedger();
}
