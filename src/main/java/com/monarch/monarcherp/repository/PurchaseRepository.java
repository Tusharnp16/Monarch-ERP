package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.model.Purchase;
import org.springframework.data.jpa.repository.JpaRepository;

interface PurchaseRepository extends JpaRepository<Purchase, Long> {
}
