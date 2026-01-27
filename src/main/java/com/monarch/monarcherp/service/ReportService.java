package com.monarch.monarcherp.service;

import com.monarch.monarcherp.model.PurchaseItem;
import com.monarch.monarcherp.repository.PurchaseItemRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.stream.Collector;
import java.util.stream.Collectors;

@Service
public class ReportService {

    private final PurchaseItemRepository purchaseItemRepository;

    ReportService(PurchaseItemRepository purchaseItemRepository){
        this.purchaseItemRepository=purchaseItemRepository;
    }

    public Map<String, List<PurchaseItem>> getPurchaseItemByExpire(){
        LocalDate date=LocalDate.now();
        LocalDate expireDate=date.plusDays(30);

        List<PurchaseItem> expiringItem = purchaseItemRepository.findAll();

        return expiringItem.stream()
                .filter(item -> item.getExpireDate()!=null)
                .filter(item -> !item.getExpireDate().isBefore(date) && !item.getExpireDate().isAfter(expireDate))
                .collect(Collectors.groupingBy(item -> item.getPurchase().getSupplier().getName()));
    }

}
