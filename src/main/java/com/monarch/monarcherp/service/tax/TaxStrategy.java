package com.monarch.monarcherp.service.tax;

import com.monarch.monarcherp.model.Money;


public interface TaxStrategy {
    Money calculateGST(Money amount);

    String getGST();
}
