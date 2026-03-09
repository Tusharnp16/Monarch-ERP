package com.monarch.monarcherp.service;

import com.monarch.monarcherp.dto.ImportResponse;
import com.monarch.monarcherp.model.Money;
import com.monarch.monarcherp.model.Product;
import com.monarch.monarcherp.model.Variant;
import com.monarch.monarcherp.repository.ProductRepository;
import com.monarch.monarcherp.repository.VariantRepository;
import org.apache.poi.ss.usermodel.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.util.*;

@Service
public class ProductImportService {

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private VariantRepository variantRepository;

    public ImportResponse.ValidationResponse validateExcel(MultipartFile file) throws IOException {
        List<ImportResponse.RowError> errors = new ArrayList<>();
        Set<String> seenVariants = new HashSet<>();

        try (Workbook workbook = WorkbookFactory.create(file.getInputStream())) {
            Sheet sheet = workbook.getSheetAt(0);
            for (Row row : sheet) {
                if (row.getRowNum() == 0) continue;
                int rowNum = row.getRowNum() + 1;

                // 1. Null/Empty Checks
                String pName = getCellValueAsString(row.getCell(0));
                String vName = getCellValueAsString(row.getCell(1));
                String colour = getCellValueAsString(row.getCell(2));
                String size = getCellValueAsString(row.getCell(3));

                if (pName.isBlank() || vName.isBlank() || colour.isBlank() || size.isBlank()) {
                    errors.add(new ImportResponse.RowError(rowNum, "Missing required fields (Product, Variant, Color, or Size)"));
                    continue;
                }

                // 2. Price Validation (MRP > Selling Price)
                try {
                    double mrp = row.getCell(4).getNumericCellValue();
                    double selling = row.getCell(5).getNumericCellValue();
                    if (mrp <= selling) {
                        errors.add(new ImportResponse.RowError(rowNum, "MRP (" + mrp + ") must be greater than Selling Price (" + selling + ")"));
                    }
                } catch (Exception e) {
                    errors.add(new ImportResponse.RowError(rowNum, "Invalid numeric format in Price columns"));
                }

                // 3. Duplicate Variant Check (Same Name + Colour + Size)
                String uniqueKey = (vName + "-" + colour + "-" + size).toLowerCase();
                if (seenVariants.contains(uniqueKey)) {
                    errors.add(new ImportResponse.RowError(rowNum, "Duplicate variant entry (Same Name, Colour, and Size) found in file"));
                } else {
                    seenVariants.add(uniqueKey);
                }
            }
        }
        return new ImportResponse.ValidationResponse(errors.isEmpty(), errors);
    }


    @Transactional
    public void importExcelData(MultipartFile file) throws IOException {

        try (Workbook workbook = WorkbookFactory.create(file.getInputStream())) {
            Sheet sheet = workbook.getSheetAt(0);

            Map<String, Product> productCache = new HashMap<>();

            for (Row row : sheet) {
                if (row.getRowNum() == 0) continue;

                String parentProductName = getCellValueAsString(row.getCell(0));

                Product parentProduct = productCache.computeIfAbsent(parentProductName, name ->
                        productRepository.findByProductName(name)
                                .orElseGet(() -> {
                                    Product newP = new Product();
                                    newP.setProductName(name);
                                    return productRepository.save(newP);
                                })
                );

                double mrpFromExcel = row.getCell(4).getNumericCellValue();
                double sellingPriceFromExcel = row.getCell(5).getNumericCellValue();

                Variant variant = new Variant();
                variant.setProduct(parentProduct);
                variant.setVariantName(getCellValueAsString(row.getCell(1)));
                variant.setColour(getCellValueAsString(row.getCell(2)));
                variant.setSize(getCellValueAsString(row.getCell(3)));
                variant.setMrp(new Money(mrpFromExcel));
                variant.setSellingPrice(new Money(sellingPriceFromExcel));

                variantRepository.save(variant);
            }
        }
    }

    private String getCellValueAsString(Cell cell) {
        if (cell == null) return "";
        return switch (cell.getCellType()) {
            case STRING -> cell.getStringCellValue();
            case NUMERIC -> String.valueOf((int) cell.getNumericCellValue());
            default -> "";
        };
    }
}