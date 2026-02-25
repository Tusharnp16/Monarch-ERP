package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.model.OutboxEvent;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface OutboxRepository extends JpaRepository<OutboxEvent,Long>
{
    List<OutboxEvent> findByProcessedFalse();
}
