package com.monarch.monarcherp.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConfigurationProperties(prefix = "monarch.sales")
public class DiscountConfig {

    private String maxDiscount;

    public String getMaxDiscount() {
        return maxDiscount;
    }

    public void setMaxDiscount(String maxDiscount) {
        this.maxDiscount = maxDiscount;
    }

    public double getMaxDiscountValue(){
        return Double.parseDouble(maxDiscount.replace("%",""))/100.0;

    }
}
