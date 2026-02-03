package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.model.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface ProductRepository extends JpaRepository<Product,Long> {
    Product findByProductId(Long productId);


    Page<Product> findByProductNameContainingIgnoreCaseOrItemCodeContainingIgnoreCase(
            String name, String code, Pageable pageable);





//    @Query(value = "SELECT * FROM products p WHERE " +
//            "(:search IS NULL OR :search = '' OR " +
//            "p.product_name ILIKE CONCAT('%', :search, '%') OR " +
//            "p.item_code ILIKE CONCAT('%', :search, '%'))",
//            countQuery = "SELECT count(*) FROM  products p WHERE " +
//                    "(:search IS NULL OR :search= '' OR " +
//                    "p.product_name ILIKE CONCAT('%', :search, '%') OR " +
//                    "p.item_code ILIKE CONCAT('%', :search, '%'))",
//                    nativeQuery = true)

    @Query(value = "SELECT * FROM products p WHERE " +
            "(:search IS NULL OR :search = '' OR " +
            "p.product_name ILIKE CONCAT('%', :search, '%') OR " +
            "p.item_code ILIKE CONCAT('%', :search, '%'))",
            countQuery = "SELECT count(*) FROM products p WHERE " +
                    "(:search IS NULL OR :search = '' OR " +
                    "p.product_name ILIKE CONCAT('%', :search, '%') OR " +
                    "p.item_code ILIKE CONCAT('%', :search, '%'))",
            nativeQuery = true)
    Page<Product> nativeProductSearch(String search,Pageable pageable );

}
