package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.model.StockMaster;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface StockMasterRepository extends JpaRepository<StockMaster,Long> {
    StockMaster getStockMasterByStockMasterId(Long stockMasterId);

    @Modifying
    @Transactional
    @Query("UPDATE StockMaster s set s.sellingPrice=:sellingPrice WHERE s.stockMasterId=:id")
    void updateSellingPriceByStockMasterId(@Param("id") Long id,@Param("sellingPrice") Double sellingPrice);

    StockMaster findByStockMasterId(Long stockMasterId);
}
