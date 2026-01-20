package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.model.Product;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProductRepository extends JpaRepository<Product,Long> {
    Product findByProductId(Long productId);

}
