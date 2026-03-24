package com.monarch.monarcherp.service;

import com.monarch.monarcherp.model.Customer;
import com.monarch.monarcherp.repository.CustomerRepository;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.CachePut;
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

//    @CacheEvict(value = "customers", key = "#customer.userId")
//    public Customer saveCustomer(Customer customer) {
//        return customerRepository.save(customer);
//    }


    @CacheEvict(value = "customers", key = "#customer.user.userId")
    public Customer saveCustomer(Customer customer) {
        if (customerRepository.existsByEmailAndUserUserId(customer.getEmail(), customer.getUser().getUserId())) {
            throw new RuntimeException("Customer with this email already exists in your shop");
        }
        return customerRepository.save(customer);
    }

    @CacheEvict(value = "customers", key = "#customer.user.userId" , allEntries = true)
    public Customer updateCustomer(Customer customer) {
        if (!customerRepository.existsByEmailAndUserUserId(customer.getEmail(), customer.getUser().getUserId())) {
            throw new RuntimeException("Customer with this email not exists in your shop");
        }
        return customerRepository.save(customer);
    }

    public Customer getCustomer(Long id) {
        return customerRepository.findById(id).orElse(null);
    }

    @Cacheable(
            value = "customers",
            key = "#userId",
            condition = "#userId > 5"
    )
    public List<Customer> getAllCustomers(Long userId) {
        return customerRepository.findAllByOrderByIdDesc();
    }

    @CacheEvict(value = "customers", key = "#userId",allEntries = true)
    public void deleteCustomer(Long id,Long userId) {
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
