package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.model.Variant;
import org.springframework.data.jpa.repository.JpaRepository;

public interface VariantRepository extends JpaRepository<Variant,Long> {
    Variant getVariantByVariantId(Long variantId);
}
