//package com.monarch.monarcherp.controller;
//
//import com.monarch.monarcherp.model.Customer;
//import com.monarch.monarcherp.repository.CustomerRepository;
//import com.monarch.monarcherp.service.CustomerService;
//import org.springframework.http.ResponseEntity;
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
//import org.springframework.web.bind.annotation.*;
//import org.springframework.web.servlet.mvc.support.RedirectAttributes;
//
//@Controller
//@RequestMapping("/customer")
//class CustomerController {
//
//    private final CustomerService customerService;
//    private final CustomerRepository customerRepository;
//
//    CustomerController(CustomerService customerService, CustomerRepository customerRepository) {
//        this.customerService = customerService;
//        this.customerRepository = customerRepository;
//    }
//
//    @GetMapping
//    public String viewCustomers(Model model) {
//        model.addAttribute("customers", customerService.getAllCustomers());
//       // model.addAttribute("AssociateCustomer",customerService.getAllCustomers());
//        return "customers";
//    }
//
//    @GetMapping("/{id}")
//    public String viewCustomer(@PathVariable Long id, Model model) {
//        model.addAttribute("customers", java.util.Collections.singletonList(customerService.getCustomer(id)));
//        return "customers";
//    }
//
//    @PostMapping("/add")
//    public String addCustomer(@ModelAttribute Customer customer, RedirectAttributes redirectAttributes) {
//        if(customerRepository.existsByMobile(customer.getMobile())){
//            redirectAttributes.addFlashAttribute("errorMessage","Mobile number already exists");
//            return "redirect:/customer";
//        }
//
//        if(customerRepository.existsByEmail(customer.getEmail())){
//            redirectAttributes.addFlashAttribute("errorMessage","Email already exists");
//            return "redirect:/customer";
//        }
//        customerService.saveCustomer(customer);
//        return "redirect:/customer";
//    }
//
//    @PostMapping("/update")
//    public String updateCustomer(@ModelAttribute Customer customer) {
////        Customer existing = customerService.getCustomer(customer.getCustomerId());
////        if (existing != null) {
////            customer.setCreatedAt(existing.getCreatedAt());
////        }
//        customerService.saveCustomer(customer);
//        return "redirect:/customer";
//    }
//
//    @PostMapping("/delete")
//    public String deleteCustomer(@RequestParam("id") Long id) {
//        customerService.deleteCustomer(id);
//        return "redirect:/customer";
//    }
//
//    @GetMapping("/api/search")
//    @ResponseBody
//    public ResponseEntity<Customer> findByMobile(@RequestParam String mobile) {
//        return customerRepository.findByMobile(mobile)
//                .map(customer -> ResponseEntity.ok(customer))
//                .orElse(ResponseEntity.noContent().build());
//    }
//
//}


package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.model.Customer;
import com.monarch.monarcherp.repository.CustomerRepository;
import com.monarch.monarcherp.service.CustomerService;
import com.monarch.monarcherp.dto.ApiResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/customers")
public class CustomerController {

    private final CustomerService customerService;
    private final CustomerRepository customerRepository;

    public CustomerController(CustomerService customerService, CustomerRepository customerRepository) {
        this.customerService = customerService;
        this.customerRepository = customerRepository;
    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<Customer>>> getAllCustomers() {
        List<Customer> customers = customerService.getAllCustomers();
        return ResponseEntity.ok(ApiResponse.success(customers, "Customers retrieved successfully"));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Customer>> getCustomerById(@PathVariable Long id) {
        Customer customer = customerService.getCustomer(id);
        return ResponseEntity.ok(ApiResponse.success(customer, "Customer found"));
    }

    @PostMapping("/add")
    public ResponseEntity<ApiResponse<Customer>> addCustomer(@RequestBody Customer customer) {
        if (customerRepository.existsByMobile(customer.getMobile())) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(ApiResponse.error("Mobile number already exists"));
        }

        if (customerRepository.existsByEmail(customer.getEmail())) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(ApiResponse.error("Email already exists"));
        }

        Customer savedCustomer = customerService.saveCustomer(customer);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(savedCustomer, "Customer created successfully"));
    }

    @PutMapping("/update") // Changed from PostMapping to PutMapping
    public ResponseEntity<ApiResponse<Customer>> updateCustomer(@RequestBody Customer customer) {
        if (customer.getId()== null) {
            return ResponseEntity.badRequest().body(ApiResponse.error("Customer ID is required for update"));
        }

        Customer updatedCustomer = customerService.saveCustomer(customer);
        return ResponseEntity.ok(ApiResponse.success(updatedCustomer, "Customer updated successfully"));
    }

    @DeleteMapping("/delete/{id}") // Changed to PathVariable for REST style
    public ResponseEntity<ApiResponse<Void>> deleteCustomer(@PathVariable Long id) {
        customerService.deleteCustomer(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Customer deleted successfully"));
    }

    @GetMapping("/search")
    public ResponseEntity<ApiResponse<Customer>> findByMobile(@RequestParam String mobile) {
        return customerRepository.findByMobile(mobile)
                .map(customer -> ResponseEntity.ok(ApiResponse.success(customer, "Customer found")))
                .orElse(ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(ApiResponse.error("No customer found with mobile: " + mobile)));
    }


}
