package com.monarch.monarcherp.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.monarch.monarcherp.model.OutboxEvent;
import com.monarch.monarcherp.model.Variant;
import com.monarch.monarcherp.model.Variant;
import com.monarch.monarcherp.repository.OutboxRepository;
import com.monarch.monarcherp.repository.VariantRepository;
import com.monarch.monarcherp.repository.VariantRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.support.KafkaHeaders;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tools.jackson.databind.ObjectMapper;

import java.sql.SQLOutput;
import java.util.List;

@Service
public class VariantService {

    @Autowired
    private VariantRepository variantRepository;

    @Autowired
    private OutboxRepository outboxRepository;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    public Variant saveVariant(Variant variant) {

        Variant savedVariant =  variantRepository.save(variant);

        try {
            String payload = objectMapper.writeValueAsString(savedVariant);
            OutboxEvent event = new OutboxEvent();
            event.setAggregateId(savedVariant.getVariantId().toString());
            event.setType("VARIANT_CREATED");
            event.setPayload(payload);

            outboxRepository.save(event);
        } catch (Exception e) {
            throw new RuntimeException("Failed to serialize variant", e);
        }


        return variant;
    }

    public Variant getVariant(Long id) {
        return variantRepository.getVariantByVariantId(id);
    }

    @KafkaListener(topics = "variant-topic",groupId = "variant_info")
    public void getNewVariantFromKafka(String payload,@Header(KafkaHeaders.RECEIVED_PARTITION) int partition) throws Exception{
        String timestamp = java.time.LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS"));
        String threadName = Thread.currentThread().getName();
        System.out.println(timestamp+threadName+"Kafka-Variant new variant received from " + partition + " : " + payload);
        processAndBroadcast(payload, partition, "Listener-1");

//        try {
//            Variant incoming = objectMapper.readValue(payload, Variant.class);
//
//            // CRITICAL CHANGE: Use the repository method that has @EntityGraph
//            // Do not use a standard findById or getVariantByVariantId if they don't have the graph
//            Variant fullVariant = variantRepository.getVariantWithProductGraph(incoming.getVariantId());
//
//            if (fullVariant != null) {
//                System.out.println("Broadcasting to WebSocket: " + fullVariant.getVariantName());
//                messagingTemplate.convertAndSend("/topic/variants", fullVariant);
//            }
//
//    } catch (Exception e) {
//        System.err.println("Error processing WebSocket broadcast: " + e.getMessage());
//    }
    }

    @KafkaListener(topics = "variant-topic",groupId = "variant_info")
    public void getNewVariantFromKafkaParition(String payload,@Header(KafkaHeaders.RECEIVED_PARTITION) int partition) throws Exception{
        String timestamp = java.time.LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS"));
        String threadName = Thread.currentThread().getName();
        System.out.println(timestamp+threadName+"Kafka-Variant new variant received from " + partition + " : " + payload);


        if (payload.contains("FAIL_TRIGGER")) {
            System.err.println("!!! Simulating a Failure for DLQ Testing !!!");
            throw new RuntimeException("Manual Failure Triggered for Variant: " + payload);
        }
//        messagingTemplate.convertAndSend("/topic/variants",payload);
        processAndBroadcast(payload, partition, "Listener-1");
    }
//
//    @KafkaListener(topics = "variant-topic", groupId = "admin_alerts")
//    public void sendAdminAlerts(String payload) {
//        try {
//            Variant incoming = objectMapper.readValue(payload, Variant.class);
//            Variant fullVariant = variantRepository.getVariantWithProductGraph(incoming.getVariantId());
//
//            if (fullVariant != null) {
//                String alertMsg = "Admin Notice: " + fullVariant.getVariantName() + " has been added/updated.";
//
//                messagingTemplate.convertAndSend("/topic/admin-alerts", alertMsg);
//            }
//        } catch (Exception e) {
//            System.err.println("Admin Alert Failure: " + e.getMessage());
//        }
//    }


    private void processAndBroadcast(String payload, int partition, String listenerName) throws Exception {

            Variant incoming = objectMapper.readValue(payload, Variant.class);

        if ("admin".equalsIgnoreCase(incoming.getVariantName())) {
            System.err.println("!!! DETECTED ADMIN VARIANT - TRIGGERING FAILURE !!!");
            throw new RuntimeException("CRITICAL: Variant validation failed for " + incoming.getVariantName());
        }

        Variant fullVariant = variantRepository.getVariantWithProductGraph(incoming.getVariantId());
        if (fullVariant != null) {
            System.out.println(listenerName + " on Partition " + partition + " broadcasting: " + fullVariant.getVariantName());
            messagingTemplate.convertAndSend("/topic/variants", fullVariant);
        }
    }

    @KafkaListener(topics = "variant-topic",groupId = "inventory_info")
    public void getNewVariantFromKafkaInventory(String payload) {
        String timestamp = java.time.LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS"));
        String threadName = Thread.currentThread().getName();
        System.out.println(timestamp+threadName+"Kafka-inventory new variant received : " + payload);
    }

    public List<Variant> getVariantByProductId(Long id){
        return variantRepository.findByProduct_ProductId(id);
    }

    public void deleteVariant(Long id) {
        variantRepository.deleteById(id);
    }


    @Transactional(readOnly = true)
    public List<Variant> getPaginatedVariant(Long lastId){

        if(lastId==0 ||  lastId==null){
            return variantRepository.findTop10ByOrderByVariantIdDesc();
        }
        return variantRepository.findTop10ByVariantIdLessThanOrderByVariantIdDesc(lastId);
    }

    public long getTotalVariants() {
        return variantRepository.count();
    }

    public boolean variantExists(Long id) {
        return variantRepository.existsById(id);
    }

    public Variant updateVariant(Long id, Variant updatedData) {
        variantRepository.findById(id).orElseThrow(()-> new RuntimeException("Not found"));
        return  variantRepository.save(updatedData);
    }

    public List<Variant> getPrVariant() {
        return variantRepository.findAllWithProduct();
    }
}
