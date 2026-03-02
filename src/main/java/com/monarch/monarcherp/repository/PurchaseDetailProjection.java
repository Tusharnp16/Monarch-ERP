package com.monarch.monarcherp.repository;

import org.springframework.beans.factory.annotation.Value;

import java.time.LocalDate;

public interface PurchaseDetailProjection {

    Long getPurchaseItemId();

    Integer getQty();

    @Value("#{target.price.price}")
    Double getUnitPrice();

    @Value("#{target.taxAmount.price}")
    Double getTaxAmount();

    @Value("#{target.landingCost.price}")
    Double getLandingCost();

    @Value("#{target.netAmount.price}")
    Double getNetAmount();

    LocalDate getExpireDate();

    @Value("#{'[' + target.variant.product.itemCode + ']' + ' ' + target.variant.product.productName}")
    String getProductDisplay();

    @Value("#{target.variant.variantName + ' (' + target.variant.colour + ' / ' + target.variant.size + ')'}")
    String getVariantDisplay();
}