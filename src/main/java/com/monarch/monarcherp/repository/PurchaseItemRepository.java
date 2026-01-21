package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.model.PurchaseItem;
import org.springframework.data.jpa.repository.JpaRepository;

interface PurchaseItemRepository extends JpaRepository<PurchaseItem, Long> {
}
