package com.monarch.monarcherp.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "sales_items")
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class SalesItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "invoice_id")
    @JsonIgnore
    private SalesInvoice salesInvoice;

    @ManyToOne
    @JoinColumn(name = "variant_id")
    private Variant variant;

    private Integer quantity;
    private Double unitPrice;

    private Double discountAmount = 0.0;
    private Double lineTotal;
}