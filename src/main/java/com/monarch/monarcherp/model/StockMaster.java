package com.monarch.monarcherp.model;

import jakarta.persistence.*;
import lombok.*;
import org.springframework.cglib.core.Local;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "stock_master")
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class StockMaster {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="stock_master_id")
    private Long stockMasterId;

    @ManyToOne
    @JoinColumn(name = "inventory_id", nullable = false
    )
    private Inventory inventory;

    @Column(nullable = true)
    private int quantity;

    @Column(name="available_quantity")
    private int availableQuantity;

    @Embedded
    @AttributeOverrides({
            @AttributeOverride(name = "price", column = @Column(name = "purchase_price"))
    })
    private Money purchasePrice;

    @Embedded
    @AttributeOverrides({
            @AttributeOverride(name = "price", column = @Column(name = "landing_cost"))
    })
    private Money landingCost;

    @Embedded
    @AttributeOverrides({
            @AttributeOverride(name = "price", column = @Column(name = "mrp"))
    })
    private Money mrp;

    @Embedded
    @AttributeOverrides({
            @AttributeOverride(name = "price", column = @Column(name = "selling_price"))
    })
    private Money sellingPrice;

    @Column(name = "manufacture_date")
    private LocalDate manufactureDate;

    @Column(name = "batch_no")
    private String batchNo;

    @Column(name = "expiry_date")
    private LocalDate expiryDate;

    @Column(name = "created_date", nullable = false, updatable = false)
    private LocalDateTime createdDate;

    @Column(name = "modified_date")
    private LocalDateTime modifiedDate;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "variant_id")
    private Variant variant;

    @PrePersist
    protected void onCreate() {
        this.createdDate = LocalDateTime.now();
        this.modifiedDate = LocalDateTime.now();
        this.batchNo=getBatchNo();
    }

    @PreUpdate
    protected void onUpdate() {
        this.modifiedDate = LocalDateTime.now();
    }
}
