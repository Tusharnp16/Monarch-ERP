//package com.monarch.monarcherp.controller;
//
//import com.monarch.monarcherp.model.Contact;
//import com.monarch.monarcherp.service.ContactService;
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
//import org.springframework.web.bind.annotation.*;
//
//import static org.springframework.data.jpa.domain.AbstractPersistable_.id;
//
//@Controller
//@RequestMapping("/contact")
//class ContactController {
//
//    private final ContactService contactService;
//
//    public ContactController(ContactService contactService) {
//        this.contactService = contactService;
//    }
//
//    @GetMapping
//    public String viewContacts(Model model) {
//        model.addAttribute("contacts", contactService.getAllContacts());
//        model.addAttribute("activeCount",2);
//        return "contacts";
//    }
//
//    @GetMapping("/{id}")
//    public String viewContact(@PathVariable Long id, Model model) {
//        model.addAttribute("contacts", java.util.Collections.singletonList(contactService.getContact(id)));
//        return "contacts";
//    }
//
//    @PostMapping("/add")
//    public String addContact(@ModelAttribute Contact contact) {
//        contactService.saveContact(contact);
//        return "redirect:/contact";
//    }
//
//    @PostMapping("/update")
//    public String updateContact(@ModelAttribute Contact contact) {
/// /        Contact existing = contactService.getContact(contact.getContactId());
/// /        if (existing != null) {
/// /            contact.setCreatedAt(existing.getCreatedAt());
/// /        }
//        contactService.saveContact(contact);
//        return "redirect:/contact";
//    }
//
//    @PostMapping("/delete")
//    public String deleteContact(@RequestParam("id") Long id) {
//        contactService.deleteContact(id);
//        return "redirect:/contact";
//    }
//
//}

package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.dto.ApiResponse;
import com.monarch.monarcherp.model.Contact;
import com.monarch.monarcherp.service.ContactService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/contacts")
public class ContactController {

    private final ContactService contactService;

    public ContactController(ContactService contactService) {
        this.contactService = contactService;
    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<Contact>>> getAllContacts() {
        List<Contact> contacts = contactService.getAllContacts();
        return ResponseEntity.ok(
                ApiResponse.success(contacts,
                        contacts.isEmpty() ? "No contacts found" : "Contacts retrieved successfully")
        );
    }

    @GetMapping("/lookup")
    public ResponseEntity<ApiResponse<List<Contact>>> getPartialContacts() {
        List<Contact> contacts = contactService.getPartialContacts();
        return ResponseEntity.ok(
                ApiResponse.success(contacts,
                        contacts.isEmpty() ? "No contacts found" : "Contacts retrieved successfully")
        );
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Contact>> getContactById(@PathVariable Long id) {
        Contact contact = contactService.getContact(id);
        if (contact == null) {
            return ResponseEntity.status(404)
                    .body(ApiResponse.error("Contact not found"));
        }
        return ResponseEntity.ok(ApiResponse.success(contact, "Contact found"));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<Contact>> addContact(@RequestBody Contact contact) {
        Contact savedContact = contactService.saveContact(contact);
        return ResponseEntity.status(201)
                .body(ApiResponse.success(savedContact, "Contact created successfully"));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Contact>> updateContact(
            @PathVariable Long id,
            @RequestBody Contact contact) {

        contact.setContactId(id);
        Contact updatedContact = contactService.saveContact(contact);
        return ResponseEntity.ok(ApiResponse.success(updatedContact, "Contact updated successfully"));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteContact(@PathVariable Long id) {
        contactService.deleteContact(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Contact deleted successfully"));
    }
}
