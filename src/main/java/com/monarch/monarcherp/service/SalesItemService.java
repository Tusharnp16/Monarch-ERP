package com.monarch.monarcherp.service;

import com.monarch.monarcherp.model.SalesItem;
import com.monarch.monarcherp.repository.SalesItemRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class SalesItemService {

    private final SalesItemRepository salesItemRepository;
    private final UserService userService;

    SalesItemService(SalesItemRepository salesItemRepository, UserService userService) {
        this.salesItemRepository = salesItemRepository;
        this.userService = userService;
    }

    public SalesItem saveSalesItem(SalesItem salesItem) {
        return salesItemRepository.save(salesItem);
    }

    public SalesItem getSalesItem(Long id) {
        return salesItemRepository.findById(id).orElse(null);
    }

    public List<SalesItem> getAllSalesItems() {
        return salesItemRepository.findAll();
    }

    public void deleteSalesItem(Long id) {
        salesItemRepository.deleteById(id);
    }

    public long getTotalSalesItems() {
        return salesItemRepository.count();
    }

    public List<Object[]> getWeeklySales() {
        LocalDate date = LocalDate.now().minusDays(7);
        return salesItemRepository.findTopSellingProducts(date, userService.getAuthnicatedUserId());
    }

    public boolean salesItemExists(Long id) {
        return salesItemRepository.existsById(id);
    }

//    public SalesItem updateSalesItemName(Long id, String newName) {
//        SalesItem salesItem= salesItemRepository.findById(id).orElseThrow(()-> new RuntimeException("Not found"));
//        salesItem.setName(newName);
//        return  salesItemRepository.save(salesItem);
//    }

}
