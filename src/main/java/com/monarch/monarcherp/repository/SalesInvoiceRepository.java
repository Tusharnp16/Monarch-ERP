package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.model.SalesInvoice;
import jakarta.persistence.QueryHint;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.QueryHints;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.stream.Stream;

public interface SalesInvoiceRepository extends JpaRepository<SalesInvoice, Long> {

    @Query("SELECT COUNT(s) FROM SalesInvoice s WHERE s.invoiceNumber LIKE :prefix%")
    long countByFinancialYearPrefix(@Param("prefix") String prefix);

    @EntityGraph(attributePaths = {
            "customer",
            "items",
            "items.variant",
            "items.variant.product"
    })
    List<InvoiceDisplayProjection> findAllProjectedByOrderByIdDesc();

    @QueryHints(value = {
            @QueryHint(name = "org.hibernate.fetchSize", value = "100"),
            @QueryHint(name = "org.hibernate.readOnly", value = "true")
    })
    @Query("SELECT s FROM SalesInvoice s WHERE MONTH(s.invoiceDate) = :m AND YEAR(s.invoiceDate) = :y")
    Stream<SalesInvoice> streamByMonthAndYear(@Param("m") int month, @Param("y") int year);
}
