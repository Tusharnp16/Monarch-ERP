package com.monarch.monarcherp.service;

import com.monarch.monarcherp.model.Inventory;
import com.monarch.monarcherp.repository.InventoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class InventoryService {

    @Autowired
    InventoryRepository inventoryRepository;

    public List<Inventory> getInventory() {
        return inventoryRepository.findAll();
    }

    //findAllWithVariant

    public List<Inventory> getInventoryWithVariant() {
        return inventoryRepository.findAllWithVariant();
    }


    public Inventory updateInventory(Long id, int quantity, String type) {

        Inventory inventory = inventoryRepository.findById(id).orElseThrow(() -> new RuntimeException("Resource Not Found"));

        inventory.setVariant(inventory.getVariant());
        int newQunatity = inventory.getAvailableQuantity();

        if (type.equals("ADD")) {
            newQunatity += quantity;
        } else if (type.equals("SUBTRACT")) {
            newQunatity -= quantity;
        } else {
            newQunatity = quantity;
        }

        inventory.setQuantity(newQunatity);

        return inventoryRepository.save(inventory);
    }

    public List<Inventory> getInventoryHistory(Long id) {
        return inventoryRepository.findAllHistory(id);
    }

    public List<Inventory> getInventoryforSales(String name) {
        return inventoryRepository.searchByVariantName(name);
    }
}
