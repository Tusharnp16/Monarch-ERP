package com.monarch.monarcherp.service;

import com.monarch.monarcherp.model.Customer;
import com.monarch.monarcherp.repository.CustomerRepository;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CustomerService {

    private CustomerRepository customerRepository;

    CustomerService(CustomerRepository customerRepository) {
        this.customerRepository = customerRepository;
    }

//    @CachePut(value = "customers",key = "'all'")

    @CacheEvict(value = "customers", key = "'all'")
    public Customer saveCustomer(Customer customer) {
        return customerRepository.save(customer);
    }

    public Customer getCustomer(Long id) {
        return customerRepository.findById(id).orElse(null);
    }

    @Cacheable(value = "customers", key = "'all'")
    public List<Customer> getAllCustomers() {
        return customerRepository.findAll();
    }

    @CacheEvict(value = "customers", key = "'all'")
    public void deleteCustomer(Long id) {
        customerRepository.deleteById(id);
    }

    public long getTotalCustomers() {
        return customerRepository.count();
    }

    public boolean customerExists(Long id) {
        return customerRepository.existsById(id);
    }

    public Customer updateCustomerName(Long id, String newName) {
        Customer customer = customerRepository.findById(id).orElseThrow(() -> new RuntimeException("Not found"));
        customer.setName(newName);
        return customerRepository.save(customer);
    }

}
