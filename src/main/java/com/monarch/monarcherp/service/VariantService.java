package com.monarch.monarcherp.service;

import com.monarch.monarcherp.model.Variant;
import com.monarch.monarcherp.model.Variant;
import com.monarch.monarcherp.repository.VariantRepository;
import com.monarch.monarcherp.repository.VariantRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class VariantService {

    @Autowired
    private VariantRepository variantRepository;

    public Variant saveVariant(Variant variant) {
        return variantRepository.save(variant);
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
}
