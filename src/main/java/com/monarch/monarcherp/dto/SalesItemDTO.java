package com.monarch.monarcherp.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Getter
public class SalesItemDTO {
    private String productName;
    private String variantInfo;
    private Integer quantity;
    private Double unitPrice;
    private Double lineTotal;

}