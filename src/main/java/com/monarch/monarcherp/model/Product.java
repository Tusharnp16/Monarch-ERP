package com.monarch.monarcherp.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonView;
import com.monarch.monarcherp.dto.VariantViews;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.SQLDelete;
import org.hibernate.annotations.SQLRestriction;
import org.hibernate.annotations.SoftDelete;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;


@Entity
@Table(name = "products")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString(exclude = "variants")
@SoftDelete(columnName = "deleted_prod")
public class Product implements Serializable {

//    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @JsonView(VariantViews.forProducts.class)
    private Long productId;

    @Column(nullable = false)
    @JsonView({VariantViews.Compact.class,VariantViews.forProducts.class})
    private String productName;

    @Column(unique = true, nullable = false)
    @JsonView({VariantViews.forInventory.class})
    private String itemCode;

    @Version
    private Integer version;

    private LocalDateTime createdAt;
    private LocalDateTime modifiedAt;

    @OneToMany(mappedBy = "product", cascade = CascadeType.ALL,fetch = FetchType.LAZY)
    @JsonIgnore
    private List<Variant> variants = new ArrayList<>();

    @PrePersist
    public void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.modifiedAt = LocalDateTime.now();
        this.itemCode = generateItemCode();
    }

    @PreUpdate
    public void onUpdate() {
        this.modifiedAt = LocalDateTime.now();
    }

    private String generateItemCode() {
        return "IT-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }

}
