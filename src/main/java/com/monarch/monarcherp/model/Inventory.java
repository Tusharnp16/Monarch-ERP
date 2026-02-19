package com.monarch.monarcherp.model;

import com.fasterxml.jackson.annotation.JsonView;
import com.monarch.monarcherp.dto.VariantViews;
import jakarta.persistence.*;
import lombok.*;


@Entity
@Table(name = "inventory")
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Builder
@Getter
@Setter
public class Inventory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "inventory_id")
    private Long inventoryId;

    @OneToOne
    @JsonView(VariantViews.forInventory.class)
    private Variant variant;

    @JsonView(VariantViews.forInventory.class)
    private int quantity;

    @Version
    private Integer version;

    @Column(name="available_quantity")
    @JsonView(VariantViews.forInventory.class)
    private int availableQuantity;

    @Embedded
    @AttributeOverrides({
            @AttributeOverride(name= "price", column = @Column(name="average_cost"))
    })
    private  Money averageCost;

}
