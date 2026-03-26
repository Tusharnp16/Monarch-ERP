package com.monarch.monarcherp.dto;

import lombok.Data;
import java.time.LocalDateTime;


import com.monarch.monarcherp.model.enums.TransactionType;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class StockLedgerDTO {
    private String variantName;
    private String productName;
    private String itemCode;
    private TransactionType type;
    private int inQuantity;
    private int outQuantity;
    private int totalQuantity;
    private String referenceId;
    private LocalDateTime transactionDate;
    private Long userId;
}