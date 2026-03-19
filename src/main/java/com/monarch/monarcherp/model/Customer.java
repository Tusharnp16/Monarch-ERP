package com.monarch.monarcherp.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "customers", uniqueConstraints = {
        @UniqueConstraint(name = "uk_customer_email_per_shop",columnNames = {"user_id", "email"}),
        @UniqueConstraint(name = "uk_customer_mobile_per_shop",columnNames = {"user_id", "mobile"})
})
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class Customer extends AbstractStoreEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    private String mobile;

    private String email;

    @Column(nullable = true)
    private Integer gstIn;

    @Column(updatable = false)
    @CreationTimestamp
    @JsonIgnore
    private LocalDateTime createdDate;

}