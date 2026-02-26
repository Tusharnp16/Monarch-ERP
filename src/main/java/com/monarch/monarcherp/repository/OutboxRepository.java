package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.model.OutboxEvent;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface OutboxRepository extends JpaRepository<OutboxEvent,Long>
{
    List<OutboxEvent> findByProcessedFalse();

    @Modifying
    @Query("UPDATE OutboxEvent e SET e.processed = true WHERE e.id IN :ids")
    void markAsProcessed(@Param("ids") List<Long> ids);
}
