package com.monarch.monarcherp.service;

import com.monarch.monarcherp.model.Contact;
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

}
