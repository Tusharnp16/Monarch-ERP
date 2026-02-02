package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.model.Money;
import com.monarch.monarcherp.model.StockMaster;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.*;

public interface StockMasterRepository extends JpaRepository<StockMaster,Long> {
    StockMaster getStockMasterByStockMasterId(Long stockMasterId);

    @Modifying
    @Transactional
    @Query("UPDATE StockMaster s set s.sellingPrice=:sellingPrice, s.mrp =:mrp WHERE s.stockMasterId=:id")
    void updateSellingPriceByStockMasterId(@Param("id") Long id,@Param("sellingPrice") Money sellingPrice,Money mrp);

    StockMaster findByStockMasterId(Long stockMasterId);

//    @Query("SELECT s FROM StockMaster s WHERE LOWER(s.batchNo) LIKE LOWER(CONCAT('%', :term, '%'))")
//    List<StockMaster> findByBatchNoContainingIgnoreCase(@Param("term") String term);

    List<StockMaster> findByBatchNoContainingIgnoreCase(String term);

    List<StockMaster> findAllByOrderByStockMasterIdDesc();

}
