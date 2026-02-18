package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.model.Contact;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface ContactRepository extends JpaRepository<Contact,Long> {
    Contact findByContactId(Long contactId);

    @Query(value = "SELECT contact_id, name, gst_in FROM contact", nativeQuery = true)
    List<Object[]> findPartialContactRaw();
}

