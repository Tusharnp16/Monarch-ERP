package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.dto.SalesItemDTO;
import com.monarch.monarcherp.model.SalesItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.List;

public interface SalesItemRepository extends JpaRepository<SalesItem, Long> {

//    @Query("SELECT v.product.productName, v.variantName,v.size,v.colour, SUM(si.quantity) as totalSales, SUM(si.lineTotal) as lineTotal " +
//            "FROM SalesItem si " +
//            "JOIN si.variant v " +
//            "JOIN si.salesInvoice s " +
//            "WHERE s.invoiceDate >= :startDate " +
//            "GROUP BY v.product.productName,v.variantName,v.colour,v.size " +
//            "ORDER BY totalSales DESC")
//    List<Object[]> findTopSellingProducts(@Param("startDate") LocalDate date);

    @Query("SELECT v.product.productName, v.variantName, v.size, v.colour, " +
            "SUM(si.quantity) as totalSales, SUM(si.lineTotal) as lineTotal " +
            "FROM SalesItem si " +
            "JOIN si.variant v " +
            "JOIN si.salesInvoice s " +
            "WHERE s.invoiceDate >= :startDate " +
            "AND s.user.userId = :userId " +
            "GROUP BY v.product.productName, v.variantName, v.colour, v.size " +
            "ORDER BY totalSales DESC")
    List<Object[]> findTopSellingProducts(
            @Param("startDate") LocalDate date,
            @Param("userId") Long userId
    );


//    @Query(value = "SELECT \n" +
//            "    p.product_name,\n" +
//            "    v.variant_name,\n" +
//            "    CONCAT(v.colour, ' / ', v.size) AS colour_size,\n" +
//            "    si.quantity,\n" +
//            "    si.unit_price,\n" +
//            "    si.line_total\n" +
//            "FROM sales_items si\n" +
//            "JOIN variants v ON si.variant_id = v.variant_id\n" +
//            "JOIN products p ON v.product_id = p.product_id\n" +
//            "WHERE si.id = :id " ,nativeQuery = true)


    @Query("SELECT new com.monarch.monarcherp.dto.SalesItemDTO(" +
            "p.productName," +
            "v.variantName, " +
            "CONCAT(v.colour, ' / ', v.size), " +
            "si.quantity, " +
            "si.unitPrice, " +
            "si.lineTotal) " +
            "FROM SalesItem si " +
            "JOIN si.variant v " +
            "JOIN v.product p " +
            "WHERE si.salesInvoice.id = :id")
    List<SalesItemDTO> salesItems(@Param("id") Long id);


}
