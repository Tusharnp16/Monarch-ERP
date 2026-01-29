package com.monarch.monarcherp.model;


import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "purchase")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Purchase {

        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        private Long purchaseId;

        private String billNo;

        @ManyToOne
        @JoinColumn(name = "contact_id")
        private Contact supplier;

        @Embedded
        @AttributeOverrides({
            @AttributeOverride(name= "price", column = @Column(name="total_amount"))
        })
        @Column(nullable = true)
        private Money totalAmount;

        @OneToMany(mappedBy = "purchase", cascade = CascadeType.REMOVE, orphanRemoval = true , fetch = FetchType.LAZY)
        private List<PurchaseItem> items = new ArrayList<>();

        @CreationTimestamp
        private LocalDateTime createdDate;

        @UpdateTimestamp
        private LocalDateTime modifiedDate;

}
