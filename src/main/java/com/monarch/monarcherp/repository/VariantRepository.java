package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.model.Variant;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface VariantRepository extends JpaRepository<Variant, Long> {
    Variant getVariantByVariantId(Long variantId);

    List<Variant> findByProduct_ProductId(Long id);
//
//    Window<Variant> findTop10VariantByVariantId(Long variantId, Sort sort);

    @EntityGraph(attributePaths = {"product"})
    List<Variant> findTop10ByVariantIdLessThanOrderByVariantIdDesc(Long lastId);

    @EntityGraph(attributePaths = {"product"})
    List<Variant> findTop10ByOrderByVariantIdDesc();


    @Query("SELECT v FROM Variant v JOIN FETCH v.product")
    List<Variant> findAllWithProduct();


    @EntityGraph(attributePaths = {"product"})
    @Query("SELECT v FROM Variant v WHERE v.variantId = :id")
    Variant getVariantWithProductGraph(@Param("id") Long id);

}
