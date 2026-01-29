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
