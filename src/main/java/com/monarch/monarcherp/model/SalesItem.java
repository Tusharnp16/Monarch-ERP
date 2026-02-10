package com.monarch.monarcherp.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import jakarta.servlet.jsp.tagext.VariableInfo;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "sales_items")
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
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

    private Double discountAmount=0.0;
    private Double lineTotal;
}