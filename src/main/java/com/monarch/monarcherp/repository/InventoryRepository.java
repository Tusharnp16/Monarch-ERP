package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.model.Inventory;
import com.monarch.monarcherp.model.Variant;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface InventoryRepository extends JpaRepository<Inventory, Long> {

   Optional<Inventory> findByVariant(Variant variant);

   Optional<Inventory> findByVariant_VariantId(Long variantId);



   @Query("SELECT i FROM Inventory i JOIN FETCH i.variant")
   List<Inventory> findAllWithVariant();


}
