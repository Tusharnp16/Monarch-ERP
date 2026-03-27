package com.monarch.monarcherp.service;

import com.monarch.monarcherp.dto.SalesItemDTO;
import com.monarch.monarcherp.model.*;
import com.monarch.monarcherp.model.enums.TransactionType;
import com.monarch.monarcherp.repository.*;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.jspecify.annotations.NonNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.io.OutputStream;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Stream;

@Service
public class SalesInvoiceService {


    private final CustomerRepository customerRepository;
    private final NotificationService notificationService;
    private final SalesInvoiceRepository salesInvoiceRepository;
    private final VariantRepository variantRepository;
    private final InventoryRepository inventoryRepository;
    private final SalesItemRepository salesItemRepository;
    private final CustomerService customerService;
    private final StockMasterTransactionService stockMasterTransactionService;
    private final UserRepository userRepository;
    private final UserService userService;
    private final StockMasterRepository stockMasterRepository;


    SalesInvoiceService(SalesInvoiceRepository salesInvoiceRepository, CustomerRepository customerRepository, NotificationService notificationService, VariantRepository variantRepository, InventoryRepository inventoryRepository, SalesItemRepository salesItemRepository, CustomerService customerService, StockMasterTransactionService stockMasterTransactionService, UserRepository userRepository, UserService userService, StockMasterRepository stockMasterRepository) {
        this.salesInvoiceRepository = salesInvoiceRepository;
        this.customerRepository = customerRepository;
        this.notificationService = notificationService;
        this.variantRepository = variantRepository;
        this.inventoryRepository = inventoryRepository;
        this.salesItemRepository = salesItemRepository;
        this.customerService = customerService;
        this.stockMasterTransactionService = stockMasterTransactionService;
        this.userRepository = userRepository;
        this.userService = userService;
        this.stockMasterRepository = stockMasterRepository;
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
    public SalesInvoice saveSalesInvoice(@NonNull SalesInvoice salesInvoice) {

        Long userId=userService.getAuthnicatedUserId();

        Optional<Customer> existingCustomer = customerRepository.findByMobileAndUserUserId(salesInvoice.getCustomer().getMobile(),userId);
        if (existingCustomer.isPresent()) {
            salesInvoice.setCustomer(existingCustomer.get());
        } else {
            Customer savedCustomer = customerService.saveCustomer(salesInvoice.getCustomer());
            salesInvoice.setCustomer(savedCustomer);
        }

        String financialYear = getFinancialYear();
        String prefix = "INV/" + financialYear + "/";
        long count = salesInvoiceRepository.countByFinancialYearPrefix(prefix) + 1;
        salesInvoice.setInvoiceNumber(prefix + String.format("%04d", count));

        double subtotal = 0;

        List<StockMaster> stockUpdates = new ArrayList<>();


        List<Inventory> inventoriesToUpdate = new ArrayList<>();

        for (SalesItem item : salesInvoice.getItems()) {

            long variantId = item.getVariant().getVariantId();

            int remainingToDeduct = item.getQuantity();

            System.out.println("Variant ID ffor batches: " + variantId);

            List<StockMaster> batches = stockMasterRepository.findAvailableBatchesFEFO(variantId);
            System.out.println("Avialble Bches : " + batches);

            int totalAvailable = (int) batches.stream().mapToDouble(StockMaster::getQuantity).sum();

            if (totalAvailable < remainingToDeduct) {
                throw new RuntimeException("Insufficient stock for variant ID: " + variantId);
            }

            for (StockMaster batch : batches) {
                if (remainingToDeduct <= 0) break;

                int batchQty = batch.getQuantity();
                int takeAmount;

                if (batchQty >= remainingToDeduct) {
                    takeAmount = remainingToDeduct;
                    batch.setQuantity(batchQty - remainingToDeduct);
                    remainingToDeduct = 0;
                } else {
                    takeAmount = batchQty;
                    batch.setQuantity(0);
                    remainingToDeduct -= batchQty;
                }

                stockUpdates.add(batch);
            }

            Variant variant = variantRepository.findById(variantId)
                    .orElseThrow(() -> new RuntimeException("Variant not found"));
//
//            Inventory inventory = inventoryRepository.findByVariant_VariantId(variantId)
//                    .orElseThrow(() -> new RuntimeException("Inventory not found"));
//
//            // VALIDATE: Check Stock
//            if (inventory.getAvailableQuantity() < item.getQuantity()) {
//                throw new RuntimeException("Not enough stock for " + variant.getVariantName());
//            }

            Inventory inventory = inventoryRepository.findByVariant_VariantId(variantId)
                    .orElseThrow(() -> new RuntimeException("Inventory summary not found"));

            inventory.setAvailableQuantity(inventory.getAvailableQuantity() - item.getQuantity());
            inventory.setQuantity(inventory.getQuantity() - item.getQuantity());
            inventoriesToUpdate.add(inventory);

            item.setVariant(variant);
            item.setSalesInvoice(salesInvoice);
            double lineTotal = item.getQuantity() * item.getUnitPrice();
            item.setLineTotal(lineTotal);
            subtotal += lineTotal;

            inventoriesToUpdate.add(inventory);
        }

        inventoryRepository.saveAll(inventoriesToUpdate);
        stockMasterRepository.saveAll(stockUpdates);

        salesInvoice.setTotalAmount(subtotal);
        double discount = (salesInvoice.getDiscountAmount() != null) ? salesInvoice.getDiscountAmount() : 0;
        salesInvoice.setGrandTotal(subtotal - discount);

        return salesInvoiceRepository.save(salesInvoice);
    }

    public SalesInvoice getSalesInvoice(Long id) {
        return salesInvoiceRepository.findById(id).orElse(null);
    }

    public List<SalesInvoice> getAllSalesInvoices() {
        return salesInvoiceRepository.findAll();
    }

    public List<InvoiceDisplayProjection> getAllProjectionSalesInvoices() {
        return salesInvoiceRepository.findAllProjectedByOrderByIdDesc();
    }

    // salesInvoiceService

    public List<SalesItemDTO> getSaleItemById(Long id) {
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

    public SalesInvoice getById(long id) {
        SalesInvoice sl = salesInvoiceRepository.findById(id).orElse(null);
        return sl;
    }


    public boolean salesInvoiceExists(Long id) {
        return salesInvoiceRepository.existsById(id);
    }

    @Transactional(readOnly = true)
    public void exportMonthlySalesToStream(int month, int year, OutputStream outputStream) throws IOException {

        try (SXSSFWorkbook workbook = new SXSSFWorkbook(100)) {
            SXSSFSheet sheet = workbook.createSheet("Monthly Sales");

            createHeader(sheet);

            try (Stream<SalesInvoice> salesStream = salesInvoiceRepository.streamByMonthAndYear(month, year)) {
                AtomicInteger rowIdx = new AtomicInteger(1);

                salesStream.forEach(invoice -> {
                    Row row = sheet.createRow(rowIdx.getAndIncrement());
                    row.createCell(0).setCellValue(invoice.getInvoiceDate().toString());
                    row.createCell(1).setCellValue(invoice.getInvoiceNumber());
                    row.createCell(2).setCellValue(invoice.getCustomer().getName());
                    row.createCell(3).setCellValue(invoice.getGrandTotal());
                });
            }
            workbook.write(outputStream);

            System.out.println("Temp files are at: " + System.getProperty("java.io.tmpdir"));
            workbook.dispose();
        }
    }

    private void createHeader(SXSSFSheet sheet) {
        Row header = sheet.createRow(0);
        String[] columns = {"Date", "Invoice #", "Customer", "Amount"};
        for (int i = 0; i < columns.length; i++) {
            header.createCell(i).setCellValue(columns[i]);
        }
    }

//
//    public SalesInvoice updateSalesInvoiceName(Long id, String newName) {
//        SalesInvoice salesInvoice= salesInvoiceRepository.findById(id).orElseThrow(()-> new RuntimeException("Not found"));
//        salesInvoice.setName(newName);
//        return  salesInvoiceRepository.save(salesInvoice);
//    }

    //            User currentUser=userService.getAuthnicatedUser();

//            stockMasterTransactionService.recordTransaction(0,
//                    item.getQuantity(),TransactionType.SALE, "SALE-",salesInvoice.getInvoiceNumber(),currentUser,inventory);

}
