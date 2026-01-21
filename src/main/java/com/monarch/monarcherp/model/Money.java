package com.monarch.monarcherp.model;

import jakarta.persistence.Embeddable;
import lombok.AccessLevel;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.math.BigDecimal;
import java.math.RoundingMode;

@Embeddable
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@ToString
public class Money {

    private BigDecimal price;

    public Money(double prices) {
        this.price = BigDecimal.valueOf(prices).setScale(2, RoundingMode.HALF_UP);
    }

    public Money(BigDecimal prices) {
        this.price = prices.setScale(2, RoundingMode.HALF_UP);
    }

    public BigDecimal toBigDecimal() {
        return price;
    }

    public Money add(Money amount) {
        return new Money(this.price.add(amount.price));
    }

    public Money subtract(Money amount) {
        return new Money(this.price.subtract(amount.price));
    }

    public Money multiply(int qty) {
        return new Money(this.price.multiply(BigDecimal.valueOf(qty)));
    }

    public Double getPrice() {
        return price.doubleValue();
    }

}
