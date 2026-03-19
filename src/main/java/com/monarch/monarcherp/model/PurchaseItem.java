package com.monarch.monarcherp.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Entity
@Table(name = "purchase_item")
@Getter
@Setter
public class PurchaseItem extends AbstractStoreEntity{

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long purchaseItemId;

    @ManyToOne
    @JoinColumn(name = "purchase_id")
    @JsonIgnore
    private Purchase purchase;

    @ManyToOne
    private Variant variant;

    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "stock_master_id", nullable = false)
    @JsonIgnore
    private StockMaster stockMaster;

    @Embedded
    @AttributeOverrides({
            @AttributeOverride(name = "price", column = @Column(name = "price"))
    })
    private Money price;

    @Embedded
    @AttributeOverrides({
            @AttributeOverride(name = "price", column = @Column(name = "tax_rate"))
    })
    private Money taxRate;

    @Embedded
    @AttributeOverrides({
            @AttributeOverride(name = "price", column = @Column(name = "tax_amount"))
    })
    private Money taxAmount;
    private Integer qty;
    private LocalDate expireDate;

    @Embedded
    @AttributeOverrides({
            @AttributeOverride(name = "price", column = @Column(name = "landing_cost"))
    })
    private Money landingCost;

    @Embedded
    @AttributeOverrides({
            @AttributeOverride(name = "price", column = @Column(name = "net_amount"))
    })
    private Money netAmount;
}