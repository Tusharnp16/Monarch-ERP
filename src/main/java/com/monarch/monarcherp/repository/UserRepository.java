package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByUserName(String userName);

    //The Goal: Find products that have more than 5 variants AND where at least one of those variants is priced above 1000.
    //
    //Output: Show the product_name and the total count of variants.
    //
    //Hint: You'll need to combine WHERE (for the 1000+ price) and HAVING (for the count of 5+).


    /*
    select p.product_name,v.variant_name,count(v.variant_name) as total_Count
    from product p left join variant v on p.product_id=v.product_id WHERE total_count > 5 AND v.mrp >1000;
     */




}
