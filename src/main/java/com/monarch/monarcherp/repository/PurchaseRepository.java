package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.model.Purchase;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface PurchaseRepository extends JpaRepository<Purchase, Long> {
    Purchase findPurchaseByPurchaseId(Long purchaseId);


}
