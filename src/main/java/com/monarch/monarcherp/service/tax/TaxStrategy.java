package com.monarch.monarcherp.service.tax;

import com.monarch.monarcherp.model.Money;
import org.springframework.stereotype.Component;


public interface TaxStrategy {
    Money calculateGST(Money amount);
    String getGST();
}
