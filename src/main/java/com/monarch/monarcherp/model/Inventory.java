package com.monarch.monarcherp.model;

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
    private Variant variant;

    private int quantity;

    @Column(name="available_quantity")
    private int availableQuantity;

    @Embedded
    @AttributeOverrides({
            @AttributeOverride(name= "price", column = @Column(name="average_cost"))
    })
    private  Money averageCost;

}
