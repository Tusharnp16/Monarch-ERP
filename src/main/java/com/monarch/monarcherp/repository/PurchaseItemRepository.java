package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.model.PurchaseItem;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PurchaseItemRepository extends JpaRepository<PurchaseItem, Long> {
    PurchaseItem getPurchaseItemBypurchaseItemId(Long purchaseItemId);

    List<PurchaseDetailProjection> findAllByPurchasePurchaseId(Long purchaseId);
}
