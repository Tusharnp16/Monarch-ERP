package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.model.SalesInvoice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface SalesInvoiceRepository extends JpaRepository<SalesInvoice, Long> {

    @Query("SELECT COUNT(s) FROM SalesInvoice s WHERE s.invoiceNumber LIKE :prefix%")
    long countByFinancialYearPrefix(@Param("prefix") String prefix);
}
