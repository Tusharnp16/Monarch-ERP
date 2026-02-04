package com.monarch.monarcherp.service;

import com.monarch.monarcherp.model.Product;
import com.monarch.monarcherp.repository.ProductRepository;
import jakarta.transaction.Transactional;
import org.springframework.cglib.core.Local;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.retry.annotation.Backoff;
import org.springframework.retry.annotation.Recover;
import org.springframework.retry.annotation.Retryable;
import org.springframework.stereotype.Service;

import org.springframework.data.domain.Pageable;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

@Service
public class ProductService {

    private ProductRepository productRepository;

    ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }


    public Product saveProduct(Product product) {
        return productRepository.save(product);
    }

    public Product getProduct(Long id) {
        return productRepository.findByProductId(id);
    }

    public Page<Product> getAllProducts(int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("product_id").descending());
//        return productRepository.findAll(pageable);
        return productRepository.nativeProductSearch(null,null,null,pageable);

    }

    public Page<Product> searchProducts(String search, int page, int size, LocalDate startDate, LocalDate endDate) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("product_id").descending());


//        return productRepository
//                .findByProductNameContainingIgnoreCaseOrItemCodeContainingIgnoreCase(
//                        search, search, pageable);

        System.out.println("DEBUG: Service Layer STARTDATE: "+startDate);
        System.out.println("DEBUG: Service Layer ENDDATE: "+endDate);

        Page<Product> pgprd= productRepository.nativeProductSearch(search,startDate,endDate,pageable);
        System.out.println("Service Layer: "+pgprd.getTotalElements());

        return pgprd;


    }

    public void deleteProduct(Long id) {
        productRepository.deleteById(id);
    }

    public long getTotalProducts() {
        return productRepository.count();
    }

    public boolean productExists(Long id) {
        return productRepository.existsById(id);
    }

    @Transactional
    @Retryable(retryFor = {SQLException.class}, maxAttempts = 5,backoff = @Backoff(delay = 5000))
    public Product updateProductName(Long id, String newName) {
        Product product= productRepository.findById(id).orElseThrow(()-> new RuntimeException("Not found"));
        product.setProductName(newName);
        return productRepository.save(product);
    }

    @Recover
    public Product recover(SQLException e,Long id,String newName){
        System.err.println("Database down");
        throw new RuntimeException("Cant updatted right now server is down");
    }
}

