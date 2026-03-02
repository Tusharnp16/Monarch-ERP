package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.model.Customer;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface CustomerRepository extends JpaRepository<Customer, Long> {

    boolean existsByEmail(String mobile);

    boolean existsByMobile(String email);

    Optional<Customer> findByMobile(String mobile);
}
