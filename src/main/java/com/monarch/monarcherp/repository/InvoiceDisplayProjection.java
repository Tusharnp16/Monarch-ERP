package com.monarch.monarcherp.repository;

import org.springframework.beans.factory.annotation.Value;

import java.time.LocalDate;
import java.util.List;

public interface InvoiceDisplayProjection {

    Long getId();
    String getInvoiceNumber();
    LocalDate getInvoiceDate();
    Double getTotalAmount();
    Double getDiscountAmount();

    @Value("#{target.customer.name}")
    String getCustomerName();

    @Value("#{target.customer.mobile}")
    String getCustomerNumber();

    Double getGrandTotal();

//    List<ItemView> getItems();

//    interface ItemView {
//        @Value("#{target.variant.variantName}")
//        String getProductName();
//
//        @Value("#{target.variant.colour + ' / ' + target.variant.size}")
//        String getVariantInfo();
//
//        Integer getQuantity();
//        Double getUnitPrice();
//        Double getLineTotal();
//    }
}