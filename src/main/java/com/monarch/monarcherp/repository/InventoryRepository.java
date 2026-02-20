package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.model.Inventory;
import com.monarch.monarcherp.model.Variant;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface InventoryRepository extends JpaRepository<Inventory, Long> {

   Optional<Inventory> findByVariant(Variant variant);

   Optional<Inventory> findByVariant_VariantId(Long variantId);



   @Query("SELECT i FROM Inventory i JOIN FETCH i.variant")
   List<Inventory> findAllWithVariant();

    @Query("SELECT i FROM Inventory i ORDER BY i.inventoryId DESC")
    List<Inventory> findAllHistory();

    @Query("SELECT i FROM Inventory i JOIN i.variant v " +
                "WHERE LOWER(v.variantName) LIKE LOWER(concat('%', :searchTerm, '%')) " +
                "OR LOWER(v.colour) LIKE LOWER(concat('%', :searchTerm, '%'))")
    List<Inventory> searchByVariantName(@Param("searchTerm") String searchTerm);

}
