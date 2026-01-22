package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.model.StockMaster;
import org.springframework.data.jpa.repository.JpaRepository;

public interface StockMasterRepository extends JpaRepository<StockMaster,Long> {
    StockMaster getStockMasterByStockMasterId(Long stockMasterId);
}
