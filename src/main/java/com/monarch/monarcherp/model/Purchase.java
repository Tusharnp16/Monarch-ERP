package com.monarch.monarcherp.model;


import jakarta.persistence.*;
import lombok.*;

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

        @OneToMany(mappedBy = "purchase", cascade = CascadeType.ALL)
        private List<PurchaseItem> items = new ArrayList<>();

        private LocalDateTime createdDate;
        private LocalDateTime modifiedDate;

}
