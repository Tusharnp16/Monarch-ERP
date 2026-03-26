package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.model.StockTransaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface StockTransactionRepository extends JpaRepository<StockTransaction,Long> {
}
