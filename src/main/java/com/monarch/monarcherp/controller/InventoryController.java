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

@Controller
@RequestMapping("/inventory")
class InventoryController {

    @Autowired
    InventoryService inventoryService;

    @GetMapping
    public String viewInventory(Model model){
        model.addAttribute("inventoryList",inventoryService.getInventory());
        return "inventory";
    }

    @GetMapping("history")
    public String inventoryHistory(){
        return "workingpage";
    }

    @ResponseBody
    @PatchMapping("/api/update/{id}/{qty}")
    public ResponseEntity<ApiResponse<Inventory>> updateInventory(
            @PathVariable("id") Long id,
            @PathVariable("qty") int qty) {

        Inventory inventory = inventoryService.updateInventory(id, qty);
        return ResponseEntity.ok(ApiResponse.success(inventory, "Inventory Updated"));
    }
}
