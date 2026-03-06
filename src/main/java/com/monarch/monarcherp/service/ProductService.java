package com.monarch.monarcherp.service;

import com.monarch.monarcherp.model.Product;
import com.monarch.monarcherp.repository.ProductRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.orm.ObjectOptimisticLockingFailureException;
import org.springframework.retry.annotation.Backoff;
import org.springframework.retry.annotation.Recover;
import org.springframework.retry.annotation.Retryable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

@Service
public class ProductService {

    private ProductRepository productRepository;

    ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    //    @CacheEvict(value = "product_page",allEntries = true)
    public Product saveProduct(Product product) {
        return productRepository.save(product);
    }


    //    @Cacheable(value = "products",key = "#id")
    public Product getProduct(Long id) {
        return productRepository.findByProductId(id).orElse(null);
    }

    @Transactional(readOnly = true)
    public Page<Product> getAllProducts(int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("product_id").descending());
        // return productRepository.findAll(pageable);
        return productRepository.nativeProductSearch(null, null, null, pageable);
    }

    //    @Cacheable(value="product_page", key = "{#page,#size}")
    public Page<Product> searchProducts(String search, int page, int size, LocalDate startDate, LocalDate endDate) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("product_id").descending());


//        return productRepository
//                .findByProductNameContainingIgnoreCaseOrItemCodeContainingIgnoreCase(
//                        search, search, pageable);

        System.out.println("DEBUG: Service Layer STARTDATE: " + startDate);
        System.out.println("DEBUG: Service Layer ENDDATE: " + endDate);

        Page<Product> pgprd = productRepository.nativeProductSearch(search, startDate, endDate, pageable);
        // System.out.println("Service Layer: "+pgprd.getTotalElements());

        return pgprd;
    }

    //    @Caching(evict = {
//            @CacheEvict(value = "products", key = "#id"),
//            @CacheEvict(value = "product_page", allEntries = true)
//    })
    public void deleteProduct(Long id) {
        productRepository.deleteById(id);
    }

    public long getTotalProducts() {
        return productRepository.count();
    }

    public boolean productExists(Long id) {
        return productRepository.existsById(id);
    }



    @Retryable(retryFor = {ObjectOptimisticLockingFailureException.class}, maxAttempts = 5, backoff = @Backoff(delay = 1000))
//     @CachePut(value = "products", key = "#id")
    @Transactional
    public Product updateProductName(Long id, String newName) {
        System.out.println("Retry attempt running...");
        Product product = productRepository.findById(id).orElseThrow(() -> new RuntimeException("Not found"));
        product.setProductName(newName);
        return productRepository.save(product);
    }

    //SQLException
    @Recover
    public Product recover(ObjectOptimisticLockingFailureException e, Long id, String newName) {
        System.err.println("Database down");
        throw new RuntimeException("Cant updatted right now server is down");
    }

    public List<Product> getAllCompactProducts(String name) {
        return productRepository.findByProductNameContainingIgnoreCase(name);
    }
}
