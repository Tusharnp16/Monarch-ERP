package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.dto.PurchaseDTO;
import com.monarch.monarcherp.model.Purchase;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface PurchaseRepository extends JpaRepository<Purchase, Long> {
    Purchase findPurchaseByPurchaseId(Long purchaseId);


    @Query("SELECT new com.monarch.monarcherp.dto.PurchaseDTO(" +
            "p.purchaseId, " +
            "p.billNo, " +
            "p.supplier.name, " +
            "p.supplier.mobileno, " +
            "p.createdDate, " +
            "size(p.items), " +
            "p.totalAmount.price) " +
            "FROM Purchase p")
    List<PurchaseDTO> findAllPurchaseSummaries();


    @Query("SELECT COUNT(p) FROM Purchase p WHERE p.billNo LIKE :prefix%")
    long countByFinancialYearPrefix(@Param("prefix") String prefix);
}
