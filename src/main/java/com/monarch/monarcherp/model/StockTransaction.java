package com.monarch.monarcherp.model;

import com.monarch.monarcherp.model.enums.TransactionType;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "stock_transactions")
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class StockTransaction extends AbstractStoreEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "stock_transaction_id")
    private Long stockTransactionId;

//    @ManyToOne(fetch = FetchType.LAZY)
//    @JoinColumn(name = "stock_master_id", nullable = false)
//    private StockMaster stockMaster;

    @Enumerated(EnumType.STRING)
    @Column(name = "transaction_type", nullable = false)
    private TransactionType type;

    @Column(nullable = false)
    private int inQuantity;

    @Column(nullable = false)
    private int outQuantity;

    @Column(name = "reference_id")
    private String referenceId;

    @CreationTimestamp
    @Column(name = "transaction_date", nullable = false, updatable = false)
    private LocalDateTime transactionDate;

//    @Column(columnDefinition = "TEXT")
//    private String remarks;

}
