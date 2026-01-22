package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.model.PurchaseItem;
import org.springframework.data.domain.Limit;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PurchaseItemRepository extends JpaRepository<PurchaseItem, Long> {
    PurchaseItem getPurchaseItemBypurchaseItemId(Long purchaseItemId);
}
