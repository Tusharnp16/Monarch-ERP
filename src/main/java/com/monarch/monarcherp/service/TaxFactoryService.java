package com.monarch.monarcherp.service;

import com.monarch.monarcherp.service.tax.TaxStrategy;
import org.springframework.stereotype.Service;

import java.util.Map;


@Service
public class TaxFactoryService {

    private final Map<String, TaxStrategy> strategies;

    public TaxFactoryService(Map<String, TaxStrategy> strategies) {
        this.strategies = strategies;
    }

    public TaxStrategy getStrategy(boolean isInterState) {
        if (isInterState) {
            return strategies.get("IGST");
        }
        return strategies.get("CGST_SGST");
    }
}