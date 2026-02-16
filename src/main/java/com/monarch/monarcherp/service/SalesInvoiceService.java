package com.monarch.monarcherp.service;

import com.monarch.monarcherp.dto.SalesItemDTO;
import com.monarch.monarcherp.model.*;
import com.monarch.monarcherp.repository.*;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class SalesInvoiceService {


    private final CustomerRepository customerRepository;
    private SalesInvoiceRepository salesInvoiceRepository;

    @Autowired
    private VariantRepository variantRepository;

    @Autowired
    private InventoryRepository inventoryRepository;

    @Autowired
    private SalesItemRepository salesItemRepository;

    @Autowired NotificationService notificationService;


    SalesInvoiceService(SalesInvoiceRepository salesInvoiceRepository, CustomerRepository customerRepository) {
        this.salesInvoiceRepository = salesInvoiceRepository;
        this.customerRepository = customerRepository;

    }

//    @Transactional
//    public SalesInvoice saveSalesInvoice(SalesInvoice salesInvoice) {
//
//        Optional<Customer> existingCustomer = customerRepository.findByMobile(salesInvoice.getCustomer().getMobile());
//
//        if(existingCustomer.isPresent()){
//            salesInvoice.setCustomer(existingCustomer.get());
//        }else{
//            salesInvoice.getCustomer().setId(null);
//        }
//        double subtotal=0;
//
//        String financialYear = getFinancialYear();
//        String prefix = "INV/" + financialYear + "/";
//
//        long count = salesInvoiceRepository.countByFinancialYearPrefix(prefix) + 1;
//
//        String invoiceNo = prefix + String.format("%04d", count);
//
//        salesInvoice.setInvoiceNumber(invoiceNo);
//
//        for(SalesItem item : salesInvoice.getItems()){
//            long variantId = item.getVariant().getVariantId();
//            Variant variant = variantRepository.findById(variantId)
//                    .orElseThrow(() -> new RuntimeException("Variant not found"));
//
//            item.setVariant(variant);
//            item.setSalesInvoice(salesInvoice);
//
//            double lineTotal = item.getQuantity() * item.getUnitPrice();
//            item.setLineTotal(lineTotal);
//            subtotal += lineTotal;
//
//            // inventory -
//
//            Inventory inventory = inventoryRepository.findByVariant_VariantId(variantId)
//                    .orElseThrow(() -> new RuntimeException("Inventory not found"));
//
//            if (inventory.getAvailableQuantity() < item.getQuantity()) {
//                throw new RuntimeException("Not enough stock for " + variant.getVariantName());
//            }
//
//            inventory.setAvailableQuantity(
//                    inventory.getAvailableQuantity() - item.getQuantity()
//            );
//
//            inventoryRepository.save(inventory);
//
//        }
//        salesInvoice.setTotalAmount(subtotal);
//
//        double discount = salesInvoice.getDiscountAmount() != null
//                ? salesInvoice.getDiscountAmount()
//                : 0;
//
//        salesInvoice.setGrandTotal(subtotal - discount);
//
//        return salesInvoiceRepository.save(salesInvoice);
//    }

    @Transactional
    public SalesInvoice saveSalesInvoice(SalesInvoice salesInvoice) {
        // 1. Efficient Customer Check
        Optional<Customer> existingCustomer = customerRepository.findByMobile(salesInvoice.getCustomer().getMobile());
        if (existingCustomer.isPresent()) {
            salesInvoice.setCustomer(existingCustomer.get());
        } else {
            salesInvoice.getCustomer().setId(null);
        }

        // 2. Prepare Invoice Numbering
        String financialYear = getFinancialYear();
        String prefix = "INV/" + financialYear + "/";
        long count = salesInvoiceRepository.countByFinancialYearPrefix(prefix) + 1;
        salesInvoice.setInvoiceNumber(prefix + String.format("%04d", count));

        double subtotal = 0;

        // Create a list to batch update inventory at the end
        List<Inventory> inventoriesToUpdate = new ArrayList<>();

        for (SalesItem item : salesInvoice.getItems()) {
            long variantId = item.getVariant().getVariantId();

            // FETCH: Get Variant and Inventory
            Variant variant = variantRepository.findById(variantId)
                    .orElseThrow(() -> new RuntimeException("Variant not found"));

            Inventory inventory = inventoryRepository.findByVariant_VariantId(variantId)
                    .orElseThrow(() -> new RuntimeException("Inventory not found"));

            // VALIDATE: Check Stock
            if (inventory.getAvailableQuantity() < item.getQuantity()) {
                throw new RuntimeException("Not enough stock for " + variant.getVariantName());
            }

            // CALCULATE: Line Totals
            item.setVariant(variant);
            item.setSalesInvoice(salesInvoice);
            double lineTotal = item.getQuantity() * item.getUnitPrice();
            item.setLineTotal(lineTotal);
            subtotal += lineTotal;

            // UPDATE: Reduce quantity in memory
            inventory.setAvailableQuantity(inventory.getAvailableQuantity() - item.getQuantity());

            // COLLECT: Add to list for batch saving later
            inventoriesToUpdate.add(inventory);
        }

        // 3. Batch Save Inventory (Faster than saving inside the loop)
        inventoryRepository.saveAll(inventoriesToUpdate);

        // 4. Final Totals
        salesInvoice.setTotalAmount(subtotal);
        double discount = (salesInvoice.getDiscountAmount() != null) ? salesInvoice.getDiscountAmount() : 0;
        salesInvoice.setGrandTotal(subtotal - discount);

        // 5. Save the final Invoice
        return salesInvoiceRepository.save(salesInvoice);
    }

    public SalesInvoice getSalesInvoice(Long id) {
        return salesInvoiceRepository.findById(id).orElse(null);
    }

    public List<SalesInvoice> getAllSalesInvoices() {
        return salesInvoiceRepository.findAll();
    }

   public List<InvoiceDisplayProjection> getAllProjectionSalesInvoices() {
        return salesInvoiceRepository.findAllProjectedBy();
    }

    // salesInvoiceService

    public List<SalesItemDTO> getSaleItemById(Long id){
        return salesItemRepository.salesItems(id);
    }

    public void deleteSalesInvoice(Long id) {
        salesInvoiceRepository.deleteById(id);
    }

    public long getTotalSalesInvoices() {
        return salesInvoiceRepository.count();
    }

    public String getFinancialYear() {
        LocalDate today = LocalDate.now();
        int year = today.getYear();
        int month = today.getMonthValue();

        if (month >= 4) {
            return year + "-" + String.valueOf(year + 1).substring(2);
        } else {
            return (year - 1) + "-" + String.valueOf(year).substring(2);
        }
    }

    public SalesInvoice getById(long id){
        SalesInvoice sl= salesInvoiceRepository.findById(id).orElse(null);
        return sl;
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
