package com.monarch.monarcherp.service;

import com.monarch.monarcherp.model.Customer;
import com.monarch.monarcherp.model.SalesInvoice;
import com.monarch.monarcherp.repository.CustomerRepository;
import com.monarch.monarcherp.repository.SalesInvoiceRepository;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class SalesInvoiceService {


    private final CustomerRepository customerRepository;
    private SalesInvoiceRepository salesInvoiceRepository;

    SalesInvoiceService(SalesInvoiceRepository salesInvoiceRepository, CustomerRepository customerRepository) {
        this.salesInvoiceRepository = salesInvoiceRepository;
        this.customerRepository = customerRepository;
    }

    @Transactional
    public SalesInvoice saveSalesInvoice(SalesInvoice salesInvoice) {

        Optional<Customer> existingCustomer = customerRepository.findByMobile(salesInvoice.getCustomer().getMobile());;

        if(existingCustomer.isPresent()){
            salesInvoice.setCustomer(existingCustomer.get());
        }else{
            salesInvoice.getCustomer().setId(null);
        }



        return salesInvoiceRepository.save(salesInvoice);
    }

    public SalesInvoice getSalesInvoice(Long id) {
        return salesInvoiceRepository.findById(id).orElse(null);
    }

    public List<SalesInvoice> getAllSalesInvoices() {
        return salesInvoiceRepository.findAll();
    }

    public void deleteSalesInvoice(Long id) {
        salesInvoiceRepository.deleteById(id);
    }

    public long getTotalSalesInvoices() {
        return salesInvoiceRepository.count();
    }

    public boolean salesInvoiceExists(Long id) {
        return salesInvoiceRepository.existsById(id);
    }
//
//    public SalesInvoice updateSalesInvoiceName(Long id, String newName) {
//        SalesInvoice salesInvoice= salesInvoiceRepository.findById(id).orElseThrow(()-> new RuntimeException("Not found"));
//        salesInvoice.setName(newName);
//        return  salesInvoiceRepository.save(salesInvoice);
//    }

}
