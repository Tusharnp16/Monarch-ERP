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
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tools.jackson.databind.ObjectMapper;

import java.util.List;

@Service
public class VariantService {

    @Autowired
    private VariantRepository variantRepository;

    @Autowired
    private OutboxRepository outboxRepository;

    @Autowired
    private ObjectMapper objectMapper;

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

    public List<Variant> getAllVariants() {
        return variantRepository.findAll();
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
            return variantRepository.findTop10ByOrderByVariantIdAsc();
        }
        return variantRepository.findTop10ByVariantIdGreaterThanOrderByVariantIdAsc(lastId);
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
