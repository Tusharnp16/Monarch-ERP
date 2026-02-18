package com.monarch.monarcherp.model;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "sales_invoices")
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
@Builder
public class SalesInvoice {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;

    private String invoiceNumber;

    @CreationTimestamp
    @Column(updatable = false)
    private LocalDate invoiceDate;

    @ManyToOne(cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinColumn(name = "customer_id")
    private Customer customer;

    private Double totalAmount;
    private Double taxAmount = 0.0;

    private Double discountAmount;
    private Double grandTotal;

    @OneToMany(mappedBy = "salesInvoice", cascade = CascadeType.ALL)
    private List<SalesItem> items;

}