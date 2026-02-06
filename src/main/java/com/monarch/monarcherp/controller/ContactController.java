package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.model.Contact;
import com.monarch.monarcherp.service.ContactService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import static org.springframework.data.jpa.domain.AbstractPersistable_.id;

@Controller
@RequestMapping("/contact")
class ContactController {

    private final ContactService contactService;

    public ContactController(ContactService contactService) {
        this.contactService = contactService;
    }

    @GetMapping
    public String viewContacts(Model model) {
        model.addAttribute("contacts", contactService.getAllContacts());
        model.addAttribute("activeCount",2);
        return "contacts";
    }

    @GetMapping("/{id}")
    public String viewContact(@PathVariable Long id, Model model) {
        model.addAttribute("contacts", java.util.Collections.singletonList(contactService.getContact(id)));
        return "contacts";
    }

    @PostMapping("/add")
    public String addContact(@ModelAttribute Contact contact) {
        contactService.saveContact(contact);
        return "redirect:/contact";
    }

    @PostMapping("/update")
    public String updateContact(@ModelAttribute Contact contact) {
//        Contact existing = contactService.getContact(contact.getContactId());
//        if (existing != null) {
//            contact.setCreatedAt(existing.getCreatedAt());
//        }
        contactService.saveContact(contact);
        return "redirect:/contact";
    }

    @PostMapping("/delete")
    public String deleteContact(@RequestParam("id") Long id) {
        contactService.deleteContact(id);
        return "redirect:/contact";
    }

}
//
//
//package com.monarch.monarcherp.controller;
//
//import com.monarch.monarcherp.model.Contact;
//import com.monarch.monarcherp.service.ContactService;
//import com.monarch.monarcherp.dto.ApiResponse;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.*;
//
//import java.util.List;
//
//@RestController
//@RequestMapping("/api/contacts")
//public class ContactController {
//
//    private final ContactService contactService;
//
//    public ContactController(ContactService contactService) {
//        this.contactService = contactService;
//    }
//
//    @GetMapping
//    public ResponseEntity<ApiResponse<List<Contact>>> getAllContacts() {
//        List<Contact> contacts = contactService.getAllContacts();
//        return ResponseEntity.ok(ApiResponse.success(contacts, "Contacts retrieved successfully"));
//    }
//
//    @GetMapping("/{id}")
//    public ResponseEntity<ApiResponse<Contact>> getContactById(@PathVariable Long id) {
//        Contact contact = contactService.getContact(id);
//        return ResponseEntity.ok(ApiResponse.success(contact, "Contact found"));
//    }
//
//    @PostMapping("/add")
//    public ResponseEntity<ApiResponse<Contact>> addContact(@RequestBody Contact contact) {
//        Contact savedContact = contactService.saveContact(contact);
//        return ResponseEntity.ok(ApiResponse.success(savedContact, "Contact created successfully"));
//    }
//
//    @PutMapping("/update") // Use PutMapping for updates
//    public ResponseEntity<ApiResponse<Contact>> updateContact(@RequestBody Contact contact) {
//        Contact updatedContact = contactService.saveContact(contact);
//        return ResponseEntity.ok(ApiResponse.success(updatedContact, "Contact updated successfully"));
//    }
//
//    @DeleteMapping("/delete/{id}")
//    public ResponseEntity<ApiResponse<Void>> deleteContact(@PathVariable Long id) {
//        contactService.deleteContact(id);
//        return ResponseEntity.ok(ApiResponse.success(null, "Contact deleted successfully"));
//    }
//}
