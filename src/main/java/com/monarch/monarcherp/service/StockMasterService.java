package com.monarch.monarcherp.service;

import com.monarch.monarcherp.model.StockMaster;
import com.monarch.monarcherp.repository.StockMasterRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.format.DateTimeFormatter;
import java.util.Formatter;

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
        String variant=stock.getVariant().getColour();

        DateTimeFormatter formatter=DateTimeFormatter.ofPattern("MMMYY");
        String expire=stock.getExpiryDate().format(formatter).toUpperCase();

        return prd + "-" + variant + "-" + expire;
    }


}
