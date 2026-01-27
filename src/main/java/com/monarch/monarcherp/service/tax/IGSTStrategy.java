package com.monarch.monarcherp.service.tax;

import com.monarch.monarcherp.model.Money;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;

@Component("IGST")
public class IGSTStrategy implements TaxStrategy {
    private static final BigDecimal RATE = new BigDecimal("0.18");

    @Override
    public Money calculateGST(Money amount) {
        return new Money(amount.toBigDecimal().multiply(RATE));
    }

    @Override
    public String getGST() {
        return "IGST";
    }
}
