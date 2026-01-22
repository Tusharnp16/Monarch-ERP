package com.monarch.monarcherp.service;

import com.monarch.monarcherp.model.StockMaster;
import com.monarch.monarcherp.model.StockMaster;
import com.monarch.monarcherp.repository.StockMasterRepository;
import com.monarch.monarcherp.repository.StockMasterRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.format.DateTimeFormatter;
import java.util.Formatter;
import java.util.List;

@Service
public class StockMasterService {

    @Autowired
    StockMasterRepository stockMasterRepository;

    public void saveStock(StockMaster stock){
        String batch=generateBatch(stock);
        stock.setBatchNo(batch);
        stockMasterRepository.save(stock);

    }

    private String generateBatch(StockMaster stock){
        String prd=stock.getVariant().getProduct().getProductName().substring(0,2).toUpperCase();
        String stockMaster=stock.getVariant().getColour();

        DateTimeFormatter formatter=DateTimeFormatter.ofPattern("MMMYY");
        String expire=stock.getExpiryDate().format(formatter).toUpperCase();

        return prd + "-" + stockMaster + "-" + expire;
    }


    public StockMaster saveStockMaster(StockMaster stockMaster) {
        return stockMasterRepository.save(stockMaster);
    }

    public StockMaster getStockMaster(Long id) {
        return stockMasterRepository.getStockMasterByStockMasterId(id);
    }

    public List<StockMaster> getAllStockMasters() {
        return stockMasterRepository.findAll();
    }

    public void deleteStockMaster(Long id) {
        stockMasterRepository.deleteById(id);
    }

    public long getTotalStockMasters() {
        return stockMasterRepository.count();
    }

    public boolean stockMasterExists(Long id) {
        return stockMasterRepository.existsById(id);
    }

    public StockMaster updateStockMaster(Long id, StockMaster updatedData) {
        stockMasterRepository.findById(id).orElseThrow(()-> new RuntimeException("Not found"));
        return  stockMasterRepository.save(updatedData);
    }


}
