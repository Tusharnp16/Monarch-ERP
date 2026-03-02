package com.monarch.monarcherp.service;

import com.monarch.monarcherp.model.Contact;
import com.monarch.monarcherp.repository.ContactRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ContactService {


    private ContactRepository contactRepository;

    ContactService(ContactRepository contactRepository) {
        this.contactRepository = contactRepository;
    }

    public Contact saveContact(Contact contact) {
        return contactRepository.save(contact);
    }

    public Contact getContact(Long id) {
        return contactRepository.findByContactId(id);
    }

    public List<Contact> getAllContacts() {
        return contactRepository.findAll();
    }

    public void deleteContact(Long id) {
        contactRepository.deleteById(id);
    }

    public long getTotalContacts() {
        return contactRepository.count();
    }

    public boolean contactExists(Long id) {
        return contactRepository.existsById(id);
    }

    public Contact updateContactName(Long id, String newName) {
        Contact contact = contactRepository.findById(id).orElseThrow(() -> new RuntimeException("Not found"));
        contact.setName(newName);
        return contactRepository.save(contact);
    }

    public List<Contact> getPartialContacts() {
        List<Object[]> rawData = contactRepository.findPartialContactRaw();

        return rawData.stream().map(result -> {
            Contact contact = new Contact();
            contact.setContactId(((Number) result[0]).longValue());
            contact.setName((String) result[1]);
            contact.setGstIn((Integer) result[2]);
            return contact;
        }).collect(Collectors.toList());
    }
}
