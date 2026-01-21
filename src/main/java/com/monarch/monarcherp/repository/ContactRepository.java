package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.model.Contact;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ContactRepository extends JpaRepository<Contact,Long> {
}

