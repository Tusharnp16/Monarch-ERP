package com.monarch.monarcherp.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "purchase_item")
@Getter
@Setter
public class PurchaseItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long purchaseItemId;

    @ManyToOne
    @JoinColumn(name = "purchase_id")
    private Purchase purchase;

    @ManyToOne
    private Variant variant;

    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "stock_master_id")
    private StockMaster stockMaster;

    @Embedded
    @AttributeOverrides({
            @AttributeOverride(name= "price", column = @Column(name="price"))
    })
    private Money price;

    @Embedded
    @AttributeOverrides({
            @AttributeOverride(name= "price", column = @Column(name="tax_rate"))
    })
    private Money taxRate;

    @Embedded
    @AttributeOverrides({
            @AttributeOverride(name= "price", column = @Column(name="tax_amount"))
    })
    private Money taxAmount;
    private Integer qty;

    @Embedded
    @AttributeOverrides({
            @AttributeOverride(name= "price", column = @Column(name="landing_cost"))
    })
    private Money landingCost;

    @Embedded
    @AttributeOverrides({
            @AttributeOverride(name= "price", column = @Column(name="net_amount"))
    })
    private Money netAmount;
}