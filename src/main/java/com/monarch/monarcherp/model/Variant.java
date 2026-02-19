package com.monarch.monarcherp.model;

import com.fasterxml.jackson.annotation.JsonView;
import com.monarch.monarcherp.dto.VariantViews;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.SoftDelete;
import org.hibernate.annotations.UpdateTimestamp;
import java.time.LocalDateTime;

@Entity
@Table(name = "variants")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString(exclude = {"product", "batches"})
@SoftDelete(columnName = "deleted_variant")
public class Variant {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @JsonView(VariantViews.Compact.class)
    private Long variantId;

    @Column(name="variant_name")
    @JsonView({VariantViews.Compact.class,VariantViews.forInventory.class})
    private String variantName;

    @JsonView(VariantViews.Compact.class)
    private String colour;

    @JsonView(VariantViews.Compact.class)
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

    @CreationTimestamp
    @Column(updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime modifiedAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    @JsonView({VariantViews.Compact.class,VariantViews.forInventory.class})
    private Product product;
}
