package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.model.SalesInvoice;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface SalesInvoiceRepository extends JpaRepository<SalesInvoice, Long> {

    @Query("SELECT COUNT(s) FROM SalesInvoice s WHERE s.invoiceNumber LIKE :prefix%")
    long countByFinancialYearPrefix(@Param("prefix") String prefix);

    @EntityGraph(attributePaths = {
            "customer",
            "items",
            "items.variant",
            "items.variant.product"
    })
    List<InvoiceDisplayProjection> findAllProjectedBy();
}
