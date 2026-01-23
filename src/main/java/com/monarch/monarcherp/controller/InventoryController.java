package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.model.Inventory;
import com.monarch.monarcherp.service.InventoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

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

}
