package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.model.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProductRepository extends JpaRepository<Product,Long> {
    Product findByProductId(Long productId);

    Page<Product> findByProductNameContainingIgnoreCaseOrItemCodeContainingIgnoreCase(
            String name, String code, Pageable pageable);

}
