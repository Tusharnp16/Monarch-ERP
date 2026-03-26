package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.dto.ApiResponse;
import com.monarch.monarcherp.dto.StockLedgerDTO;
import com.monarch.monarcherp.model.Contact;
import com.monarch.monarcherp.model.StockTransaction;
import com.monarch.monarcherp.service.StockMasterTransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/ledger")
public class StockMasterTransactionController {

    @Autowired
    StockMasterTransactionService stockMasterTransactionService;


    @GetMapping
    public ResponseEntity<ApiResponse<List<StockLedgerDTO>>> getAllStockTransaction() {
        List<StockLedgerDTO> stockTransaction = stockMasterTransactionService.getAllStockTransactions();
        return ResponseEntity.ok(
                ApiResponse.success(stockTransaction,
                        stockTransaction.isEmpty() ? "No Transaction found" : "Ledger retrieved successfully")
        );
    }
}
