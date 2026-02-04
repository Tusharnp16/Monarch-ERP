package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.model.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;

public interface ProductRepository extends JpaRepository<Product, Long> {
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


    //   @Query(value = "SELECT * FROM products p WHERE " +
    //            "(:search IS NULL OR :search = '' OR " +
    //            "p.product_name ILIKE CONCAT('%', :search, '%') OR " +
    //            "p.item_code ILIKE CONCAT('%', :search, '%'))",
    //            countQuery = "SELECT count(*) FROM products p WHERE " +
    //                    "(:search IS NULL OR :search = '' OR " +
    //                    "p.product_name ILIKE CONCAT('%', :search, '%') OR " +
    //                    "p.item_code ILIKE CONCAT('%', :search, '%'))",
    //            nativeQuery = true)


    //    @Query(value = """
//        SELECT * FROM products p
//        WHERE
//            (:search IS NULL OR :search = '' OR
//             p.product_name ILIKE CONCAT('%', :search, '%') OR
//             p.item_code ILIKE CONCAT('%', :search, '%'))
//        AND (:startDate IS NULL OR p.created_at >= :startDate)
//        AND (:endDate IS NULL OR p.created_at <= :endDate)
//        """,
//        countQuery = """
//        SELECT count(*) FROM products p
//        WHERE
//            (:search IS NULL OR :search = '' OR
//             p.product_name ILIKE CONCAT('%', :search, '%') OR
//             p.item_code ILIKE CONCAT('%', :search, '%'))
//        AND (:startDate IS NULL OR p.created_at >= :startDate)
//        AND (:endDate IS NULL OR p.created_at <= :endDate)
//        """,
//        nativeQuery = true)



    @Query(value = "SELECT * FROM products p WHERE " +
            "(:search IS NULL OR :search = '' OR p.product_name ILIKE CONCAT('%', :search, '%') OR p.item_code ILIKE CONCAT('%', :search, '%')) " +
            "AND (CAST(:startDate AS timestamp) IS NULL OR p.created_at >= CAST(:startDate AS timestamp)) " +
            "AND (CAST(:endDate AS timestamp) IS NULL OR p.created_at <= CAST(:endDate AS timestamp))",
            countQuery = "SELECT count(*) FROM products p WHERE " +
                    "(:search IS NULL OR :search = '' OR p.product_name ILIKE CONCAT('%', :search, '%') OR p.item_code ILIKE CONCAT('%', :search, '%')) " +
                    "AND (CAST(:startDate AS timestamp) IS NULL OR p.created_at >= CAST(:startDate AS timestamp)) " +
                    "AND (CAST(:endDate AS timestamp) IS NULL OR p.created_at <= CAST(:endDate AS timestamp))",
            nativeQuery = true)
    Page<Product> nativeProductSearch(
            @Param("search") String search,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate,
            Pageable pageable
    );
}
