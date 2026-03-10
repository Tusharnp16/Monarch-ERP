package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.dto.ApiResponse;
import com.monarch.monarcherp.model.StockMaster;
import com.monarch.monarcherp.service.StockMasterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.context.request.async.DeferredResult;

import java.util.List;
import java.util.concurrent.ForkJoinPool;

//@Controller
//@RequestMapping("/stockmaster")
//class StockMasterController {
//
//
//    @Autowired
//    private StockMasterService stockMasterService;
//
//    @Autowired
//    private ProductService productService;
//
//    @Autowired
//    private ReportService reportService;
//
//    @GetMapping
//    public String viewStockMaster(Model model) {
//        model.addAttribute("stocks", stockMasterService.getAllStockMasters());
/// /        model.addAttribute("parentProducts",productService.getAllAllProducts());
//        return "stock-master";
//    }
//
//    @GetMapping("/{id}")
//    public String viewStockMaster(@PathVariable Long id, Model model) {
//        model.addAttribute("stocks", java.util.Collections.singletonList(stockMasterService.getStockMaster(id)));
//        return "stock-master";
//    }
//
//    @PostMapping("/add")
//    public String addStockMaster(@ModelAttribute StockMaster stockMaster) {

/// /        Product managedProduct = productService.getProduct(productId);
/// /        stockMaster.setProduct(managedProduct);
//        stockMasterService.saveStockMaster(stockMaster);
//        return "redirect:/stockmaster";
//    }
//
//    @PostMapping("/update")
//    public String updateStockMasterName(@RequestParam Long stockMasterId, Double sellingPrice,Double mrp) {
//        //  StockMaster existing = stockMasterService.getStockMaster(stockMaster.getStockMasterId());
//        stockMasterService.updateStockMaster(stockMasterId,sellingPrice,mrp);
//        // return "redirect:/stockmaster/" + master.getStockMasterId();
//        return "redirect:/stockmaster";
//    }
//
//    @PostMapping("/delete")
//    public String deleteStockMaster(@RequestParam Long id) {
//        stockMasterService.deleteStockMaster(id);
//        return "redirect:/stockmaster";
//    }
//
//    @GetMapping("/search")
//    public String searchStock(@RequestParam("term") String term,Model model){
//        model.addAttribute("stocks",stockMasterService.searchByBatchNo(term));
//        return "stock-table-fragment";
//    }
//}


@RestController
@RequestMapping("/api/stockmaster")
public class StockMasterController {

    private static final Long POLLING_TIMEOUT = 300000L;
    @Autowired
    private StockMasterService stockMasterService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<StockMaster>>> getAllStocks() {
        List<StockMaster> stocks = stockMasterService.getAllStockMasters();
        return ResponseEntity.ok(ApiResponse.success(stocks, "All stocks retrieved"));
    }

    @GetMapping("/poll")
    public DeferredResult<ResponseEntity<ApiResponse<List<StockMaster>>>> pollStocks() {

        DeferredResult<ResponseEntity<ApiResponse<List<StockMaster>>>> output =
                new DeferredResult<>(POLLING_TIMEOUT);

        ForkJoinPool.commonPool().submit(() -> {

            try {

                List<StockMaster> oldData = stockMasterService.getAllStockMasters();

                long start = System.currentTimeMillis();

                while (System.currentTimeMillis() - start < POLLING_TIMEOUT) {

                    Thread.sleep(10000);

                    List<StockMaster> newData = stockMasterService.getAllStockMasters();

                    if (!newData.equals(oldData)) {

                        output.setResult(
                                ResponseEntity.ok(
                                        ApiResponse.success(newData, "Stocks updated")
                                )
                        );

                        return;
                    }
                }

            } catch (Exception e) {

                output.setErrorResult(
                        ResponseEntity.status(500)
                                .body(ApiResponse.error("Polling failed"))
                );
            }
        });

        output.onTimeout(() -> {
            output.setResult(ResponseEntity.status(204).build());
        });

        return output;
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<StockMaster>> getStockById(@PathVariable Long id) {
        StockMaster stock = stockMasterService.getStockMaster(id);
        if (stock == null) {
            return ResponseEntity.ok(ApiResponse.error("Stock not found with ID: " + id));
        }
        return ResponseEntity.ok(ApiResponse.success(stock, "Stock data retrieved"));
    }

    @PostMapping("/add")
    public ResponseEntity<ApiResponse<StockMaster>> addStock(@RequestBody StockMaster stockMaster) {
        StockMaster saved = stockMasterService.saveStockMaster(stockMaster);
        return ResponseEntity.ok(ApiResponse.success(saved, "Stock created successfully"));
    }

    @PostMapping("/update")
    public ResponseEntity<ApiResponse<Void>> updateStock(
            @RequestParam Long stockMasterId,
            @RequestParam Double sellingPrice,
            @RequestParam Double mrp) {

        stockMasterService.updateStockMaster(stockMasterId, sellingPrice, mrp);
        return ResponseEntity.ok(ApiResponse.success(null, "Stock updated successfully"));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteStock(@PathVariable Long id) {
        stockMasterService.deleteStockMaster(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Stock deleted successfully"));
    }

    @GetMapping("/search")
    public ResponseEntity<ApiResponse<List<StockMaster>>> searchStock(@RequestParam("term") String term) {
        List<StockMaster> results = stockMasterService.searchByBatchNo(term);
        return ResponseEntity.ok(ApiResponse.success(results, "Search results for: " + term));
    }
}