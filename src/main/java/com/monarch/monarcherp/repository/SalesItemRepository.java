package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.model.SalesItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.List;

public interface SalesItemRepository extends JpaRepository<SalesItem, Long> {

    @Query("SELECT v.product.productName, v.variantName,v.size,v.colour, SUM(si.quantity) as totalSales, SUM(si.lineTotal) as lineTotal " +
            "FROM SalesItem si " +
            "JOIN si.variant v " +
            "JOIN si.salesInvoice s " +
            "WHERE s.invoiceDate >= :startDate " +
            "GROUP BY v.product.productName,v.variantName,v.colour,v.size " +
            "ORDER BY totalSales DESC")
    List<Object[]> findTopSellingProducts(@Param("startDate")LocalDate date);
}
