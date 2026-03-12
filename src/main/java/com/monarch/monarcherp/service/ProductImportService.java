package com.monarch.monarcherp.service;

import com.monarch.monarcherp.dto.ImportResponse;
import com.monarch.monarcherp.model.Money;
import com.monarch.monarcherp.model.Product;
import com.monarch.monarcherp.model.Variant;
import com.monarch.monarcherp.repository.ProductRepository;
import com.monarch.monarcherp.repository.VariantRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.apache.poi.ss.usermodel.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;


@Service
public class ProductImportService {

    private record ExcelRowData(int rowNum, String key, Row row) {}

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private VariantRepository variantRepository;

    @PersistenceContext
    private EntityManager entityManager;

    public ImportResponse.ValidationResponse validateExcel(MultipartFile file) throws IOException {
        List<ImportResponse.RowError> errors = new ArrayList<>();
        Set<String> keysInFile = new LinkedHashSet<>();
        List<ExcelRowData> rowDataList = new ArrayList<>();

        try (Workbook workbook = WorkbookFactory.create(file.getInputStream())) {
            Sheet sheet = workbook.getSheetAt(0);

            for (Row row : sheet) {
                if (row.getRowNum() == 0) continue;

                String pName = getCellValueAsString(row.getCell(0));
                String vName = getCellValueAsString(row.getCell(1));
                String colour = getCellValueAsString(row.getCell(2));
                String size = getCellValueAsString(row.getCell(3));

                if (!pName.isBlank() && !vName.isBlank() && !colour.isBlank() && !size.isBlank()) {
                    String key = (pName + "|" + vName + "-" + colour + "-" + size).toLowerCase();
                    keysInFile.add(key);
                    rowDataList.add(new ExcelRowData(row.getRowNum() + 1, key, row));
                } else {
                    errors.add(new ImportResponse.RowError(row.getRowNum() + 1, "Required fields are missing"));
                }
            }

            Set<String> existingInDb = variantRepository.findExistingVariantKeys(keysInFile);

            Set<String> duplicatesInFileCheck = new HashSet<>();
            for (ExcelRowData data : rowDataList) {

                if (duplicatesInFileCheck.contains(data.key())) {
                    errors.add(new ImportResponse.RowError(data.rowNum(), "Duplicate SKU found within this Excel file"));
                    continue;
                }
                duplicatesInFileCheck.add(data.key());

                if (existingInDb.contains(data.key())) {
                    errors.add(new ImportResponse.RowError(data.rowNum(), "This combination already exists in the database"));
                }

                Cell mrpCell = data.row().getCell(4);
                Cell sellingCell = data.row().getCell(5);

                if (mrpCell == null || mrpCell.getCellType() != CellType.NUMERIC ||
                        sellingCell == null || sellingCell.getCellType() != CellType.NUMERIC) {
                    errors.add(new ImportResponse.RowError(data.rowNum(), "MRP or Selling Price is missing or invalid"));
                } else if (mrpCell.getNumericCellValue() <= sellingCell.getNumericCellValue()) {
                    errors.add(new ImportResponse.RowError(data.rowNum(), "MRP must be greater than Selling Price"));
                }
            }
        }
        return new ImportResponse.ValidationResponse(errors.isEmpty(), errors);
}

//
//    @Transactional
//    public void importExcelData(MultipartFile file) throws IOException {
//
//        try (Workbook workbook = WorkbookFactory.create(file.getInputStream())) {
//            Sheet sheet = workbook.getSheetAt(0);
//
//            Map<String, Product> productCache = new HashMap<>();
//
//            for (Row row : sheet) {
//                if (row.getRowNum() == 0) continue;
//
//                String parentProductName = getCellValueAsString(row.getCell(0));
//
//                Product parentProduct = productCache.computeIfAbsent(parentProductName, name ->
//                        productRepository.findByProductName(name)
//                                .orElseGet(() -> {
//                                    Product newP = new Product();
//                                    newP.setProductName(name);
//                                    return productRepository.save(newP);
//                                })
//                );
//
//                double mrpFromExcel = row.getCell(4).getNumericCellValue();
//                double sellingPriceFromExcel = row.getCell(5).getNumericCellValue();
//
//                Variant variant = new Variant();
//                variant.setProduct(parentProduct);
//                variant.setVariantName(getCellValueAsString(row.getCell(1)));
//                variant.setColour(getCellValueAsString(row.getCell(2)));
//                variant.setSize(getCellValueAsString(row.getCell(3)));
//                variant.setMrp(new Money(mrpFromExcel));
//                variant.setSellingPrice(new Money(sellingPriceFromExcel));
//
//                variantRepository.save(variant);
//            }
//        }
//    }

    // identity error

    @Transactional
    public void importExcelData(MultipartFile file) throws IOException {
        try (Workbook workbook = WorkbookFactory.create(file.getInputStream())) {
            Sheet sheet = workbook.getSheetAt(0);

            Set<String> excelProductNames = new HashSet<>();
            for (Row row : sheet) {
                if (row.getRowNum() == 0) continue;
                excelProductNames.add(getCellValueAsString(row.getCell(0)));
            }

            List<Product> existingProducts = productRepository.findByProductNameIn(excelProductNames);
            Map<String, Product> productCache = existingProducts.stream()
                    .collect(Collectors.toMap(Product::getProductName, p -> p));

            List<Variant> batchList = new ArrayList<>();
            int batchSize = 50;

            for (Row row : sheet) {
                if (row.getRowNum() == 0) continue;

                String pName = getCellValueAsString(row.getCell(0));

                Product parentProduct = productCache.computeIfAbsent(pName, name -> {
                    Product newP = new Product();
                    newP.setProductName(name);
                    entityManager.persist(newP);
                    return newP;
                });

                Variant variant = new Variant();
                variant.setProduct(parentProduct);
                variant.setVariantName(getCellValueAsString(row.getCell(1)));
                variant.setColour(getCellValueAsString(row.getCell(2)));
                variant.setSize(getCellValueAsString(row.getCell(3)));
                variant.setMrp(new Money(row.getCell(4).getNumericCellValue()));
                variant.setSellingPrice(new Money(row.getCell(5).getNumericCellValue()));
                variant.setImageUrl(null);

                batchList.add(variant);

                if (batchList.size() >= batchSize) {
                    processBatch(batchList);
                }
            }

            if (!batchList.isEmpty()) {
                processBatch(batchList);
            }
        }
    }
//
//    private void processBatch(List<Variant> batchList) {
//        variantRepository.saveAll(batchList);
//        entityManager.flush();
//        entityManager.clear();
//        batchList.clear();
//    }


    @Transactional
    public void processBatch(List<Variant> batchList) {
        for (Variant v : batchList) {
            entityManager.persist(v);
        }
        entityManager.flush();
        entityManager.clear();
        batchList.clear();
    }

//    private void processBatch(List<Variant> batchList) {
//        int i = 0;
//        for (Variant v : batchList) {
//            entityManager.persist(v);
//            if (i % 50 == 0) {
//                entityManager.flush();
//                entityManager.clear();
//            }
//            i++;
//        }
//        batchList.clear();
//    }

    private String getCellValueAsString(Cell cell) {
        if (cell == null) return "";
        return switch (cell.getCellType()) {
            case STRING -> cell.getStringCellValue();
            case NUMERIC -> String.valueOf((int) cell.getNumericCellValue());
            default -> "";
        };
    }
}