package com.monarch.monarcherp.service;

import com.monarch.monarcherp.model.Product;
import com.monarch.monarcherp.repository.ProductRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

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

    public List<Product> getAllProducts() {
        return productRepository.findAll();
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

    public Product updateProductName(Long id, String newName) {
        Product product= productRepository.findById(id).orElseThrow(()-> new RuntimeException("Not found"));
        product.setProductName(newName);
        return  productRepository.save(product);
    }
}

