package com.monarch.monarcherp.service;

import com.monarch.monarcherp.model.Product;
import com.monarch.monarcherp.repository.ProductRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

@Service
class ProductAPIService {

    private ProductRepository productRepository;

    ProductAPIService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    public Product saveProduct(Product product) {
        return productRepository.save(product);
    }

    public Product getProduct(Long id) {
        return productRepository.findByProductId(id).orElse(null);
    }

    public Page<Product> getAllProducts(int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("productId").descending());
        return productRepository.findAll(pageable);
    }

    public Page<Product> searchProducts(String search, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("productId").descending());
        return productRepository
                .findByProductNameContainingIgnoreCaseOrItemCodeContainingIgnoreCase(
                        search, search, pageable);
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
