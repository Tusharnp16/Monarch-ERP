package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.model.Customer;
import com.monarch.monarcherp.repository.CustomerRepository;
import com.monarch.monarcherp.service.CustomerService;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/customer")
class CustomerController {

    private final CustomerService customerService;
    private final CustomerRepository customerRepository;

    CustomerController(CustomerService customerService, CustomerRepository customerRepository) {
        this.customerService = customerService;
        this.customerRepository = customerRepository;
    }

    @GetMapping
    public String viewCustomers(Model model) {
        model.addAttribute("customers", customerService.getAllCustomers());
       // model.addAttribute("AssociateCustomer",customerService.getAllCustomers());
        return "customers";
    }

    @GetMapping("/{id}")
    public String viewCustomer(@PathVariable Long id, Model model) {
        model.addAttribute("customers", java.util.Collections.singletonList(customerService.getCustomer(id)));
        return "customers";
    }

    @PostMapping("/add")
    public String addCustomer(@ModelAttribute Customer customer, RedirectAttributes redirectAttributes) {
        if(customerRepository.existsByMobile(customer.getMobile())){
            redirectAttributes.addFlashAttribute("errorMessage","Mobile number already exists");
            return "redirect:/customer";
        }

        if(customerRepository.existsByEmail(customer.getEmail())){
            redirectAttributes.addFlashAttribute("errorMessage","Email already exists");
            return "redirect:/customer";
        }
        customerService.saveCustomer(customer);
        return "redirect:/customer";
    }

    @PostMapping("/update")
    public String updateCustomer(@ModelAttribute Customer customer) {
//        Customer existing = customerService.getCustomer(customer.getCustomerId());
//        if (existing != null) {
//            customer.setCreatedAt(existing.getCreatedAt());
//        }
        customerService.saveCustomer(customer);
        return "redirect:/customer";
    }

    @PostMapping("/delete")
    public String deleteCustomer(@RequestParam("id") Long id) {
        customerService.deleteCustomer(id);
        return "redirect:/customer";
    }

    @GetMapping("/api/search")
    @ResponseBody
    public ResponseEntity<Customer> findByMobile(@RequestParam String mobile) {
        return customerRepository.findByMobile(mobile)
                .map(customer -> ResponseEntity.ok(customer))
                .orElse(ResponseEntity.noContent().build());
    }

}
