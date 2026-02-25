package com.monarch.monarcherp.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
public class OutboxEvent {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String aggregateId;

    private String type;

    @Column(columnDefinition = "TEXT")
    private String payload;

    private boolean processed = false;
}