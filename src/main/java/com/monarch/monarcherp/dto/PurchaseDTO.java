package com.monarch.monarcherp.dto;
import com.monarch.monarcherp.model.Money;
import lombok.*;

import java.time.LocalDateTime;

@NoArgsConstructor
@Getter
@Setter
public class PurchaseDTO {
    private Long purchaseId;
    private String billNo;
    private String supplierName;
    private String supplierNumber;
    private LocalDateTime date;
    private Integer itemCount;
    private Double totalAmount;

    public PurchaseDTO(Long purchaseId, String billNo, String supplierName,String supplierNumber, LocalDateTime date, Integer itemCount, Object totalAmount) {
        this.purchaseId = purchaseId;
        this.billNo = billNo;
        this.supplierName = supplierName;
        this.supplierNumber = supplierNumber;
        this.date = date;
        this.itemCount = itemCount;

        if (totalAmount instanceof Number) {
            this.totalAmount = ((Number) totalAmount).doubleValue();
        } else {
            this.totalAmount = 0.0;
        }
    }
}