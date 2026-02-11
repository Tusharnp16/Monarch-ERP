package com.monarch.monarcherp.model;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "customers")
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class Customer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(unique = true)
    private String mobile;

    @Column(unique = true)
    private String email;

    @Column(nullable = true)
    private Integer gstIn;

    @Column(updatable = false)
    @CreationTimestamp
    private LocalDateTime createdDate;

}