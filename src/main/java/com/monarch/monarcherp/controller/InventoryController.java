package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.dto.ApiResponse;
import com.monarch.monarcherp.model.Inventory;
import com.monarch.monarcherp.service.InventoryService;
import jakarta.websocket.server.PathParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/inventory")
class InventoryController {

    @Autowired
    InventoryService inventoryService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<Inventory>>> viewInventory(){
        List<Inventory> inventory=inventoryService.getInventory();
        return ResponseEntity.ok(ApiResponse.success(inventory,"Inventory fetched"));
    }

//    @GetMapping("/history")
//    public String inventoryHistory(){
//        return "workingpage";
//    }

    @PostMapping("/update")
    public ResponseEntity<ApiResponse<Inventory>> updateInventory(
            @RequestParam("inventoryId") Long id,
            @RequestParam("quantity") int qty,
            @RequestParam("adjustmentType") String type) {

        System.out.println( "DEBUG : "+type);

        Inventory inventory = inventoryService.updateInventory(id, qty,type);
        return ResponseEntity.ok(ApiResponse.success(inventory, "Inventory Updated"));
    }
}
