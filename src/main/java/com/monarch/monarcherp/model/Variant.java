package com.monarch.monarcherp.model;


import jakarta.persistence.*;
import lombok.*;

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
    private int variantId;

    private String colour;
    private String size;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;

}
