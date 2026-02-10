package com.monarch.monarcherp.service;

import com.monarch.monarcherp.model.Contact;
import com.monarch.monarcherp.model.Inventory;
import com.monarch.monarcherp.repository.InventoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class InventoryService {

    @Autowired
    InventoryRepository inventoryRepository;

    public List<Inventory> getInventory() {
        return inventoryRepository.findAll();
    }


    public Inventory updateInventory(Long id,int quantity,String type){

        Inventory inventory=inventoryRepository.findById(id).orElseThrow(()->new RuntimeException("Resource Not Found"));

        inventory.setVariant(inventory.getVariant());
        int newQunatity = inventory.getQuantity();

        if(type.equals("ADD")){
            newQunatity+=quantity;
        } else if (type.equals("SUBTRACT")) {
            newQunatity-=quantity;
        }else{
            newQunatity=quantity;
        }

        inventory.setQuantity(newQunatity);

        return inventoryRepository.save(inventory);
    }
}
