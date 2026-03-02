package com.monarch.monarcherp.config;

import com.monarch.monarcherp.model.OutboxEvent;
import com.monarch.monarcherp.repository.OutboxRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Component
@RequiredArgsConstructor
public class OutboxPublisher {

    private final OutboxRepository outboxRepository;
    private final KafkaTemplate<String, Object> kafkaTemplate;

    @Scheduled(fixedRate = 20000)
    @Transactional
    public void publish() {

        List<OutboxEvent> events = outboxRepository.findByProcessedFalse();
        if (events.isEmpty()) return;

        List<Long> processedIds = new ArrayList<>();

        for (OutboxEvent event : events) {
            kafkaTemplate.send("variant-topic", event.getAggregateId(), event.getPayload());
            processedIds.add(event.getId());
        }

        outboxRepository.markAsProcessed(processedIds);
    }
}