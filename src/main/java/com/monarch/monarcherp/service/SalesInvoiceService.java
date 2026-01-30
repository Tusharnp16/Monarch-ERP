package com.monarch.monarcherp.service;

import com.monarch.monarcherp.model.SalesInvoice;
import com.monarch.monarcherp.repository.SalesInvoiceRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SalesInvoiceService {


    private SalesInvoiceRepository salesInvoiceRepository;

    SalesInvoiceService(SalesInvoiceRepository salesInvoiceRepository) {
        this.salesInvoiceRepository = salesInvoiceRepository;
    }

    public SalesInvoice saveSalesInvoice(SalesInvoice salesInvoice) {
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
