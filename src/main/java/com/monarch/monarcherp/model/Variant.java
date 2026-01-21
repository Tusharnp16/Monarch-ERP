package com.monarch.monarcherp.model;


import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "variants")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString(exclude = {"product", "batches"})
public class Variant {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long variantId;

    private String colour;
    private String size;

    @Embedded
    @AttributeOverrides({
            @AttributeOverride(name = "price", column = @Column(name = "mrp"))
    })
    private Money mrp;

    @Embedded
    @AttributeOverrides({
            @AttributeOverride(name= "price", column = @Column(name="selling_price"))
    })
    private Money sellingPrice;

    private LocalDateTime createdAt;
    private LocalDateTime modifiedAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;

    @PrePersist
    public void onCreate(){
        this.createdAt=LocalDateTime.now();
        this.modifiedAt=LocalDateTime.now();
    }

    @PreUpdate
    public void onUpdate(){
        this.modifiedAt=LocalDateTime.now();
    }
}
