package com.monarch.monarcherp.service;

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
import java.util.HashMap;
import java.util.Map;

@Service
public class ProductImportService {

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private VariantRepository variantRepository;

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
                variant.setProduct(parentProduct); // The Mapping
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