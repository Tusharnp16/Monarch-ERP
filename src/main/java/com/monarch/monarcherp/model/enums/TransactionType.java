package com.monarch.monarcherp.model.enums;

import lombok.Getter;

@Getter
public enum TransactionType {
    PURCHASE("Stock In"),
    SALE("Stock Out"),
    RETURN("Stock In"),
    ADJUSTMENT("Manual Correction"),
    WASTAGE("Stock Out");

    private final String description;

    TransactionType(String description) {
        this.description = description;
    }
}
