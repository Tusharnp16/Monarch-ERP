package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.model.Product;
import com.monarch.monarcherp.model.PurchaseItem;
import com.monarch.monarcherp.model.StockMaster;
import com.monarch.monarcherp.service.ProductService;
import com.monarch.monarcherp.service.ReportService;
import com.monarch.monarcherp.service.StockMasterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/stockmaster")
class StockMasterController {


    @Autowired
    private StockMasterService stockMasterService;

    @Autowired
    private ProductService productService;

    @Autowired
    private ReportService reportService;

    @GetMapping
    public String viewStockMaster(Model model) {
        model.addAttribute("stocks", stockMasterService.getAllStockMasters());
        model.addAttribute("parentProducts",productService.getAllProducts());
        return "stock-master";
    }

    @GetMapping("/{id}")
    public String viewStockMaster(@PathVariable Long id, Model model) {
        model.addAttribute("stockMasters", java.util.Collections.singletonList(stockMasterService.getStockMaster(id)));
        return "stock-master";
    }

    @PostMapping("/add")
    public String addStockMaster(@ModelAttribute StockMaster stockMaster) {
//        Product managedProduct = productService.getProduct(productId);
//        stockMaster.setProduct(managedProduct);
        stockMasterService.saveStockMaster(stockMaster);
        return "redirect:/stockmaster";
    }

    @PostMapping("/update")
    public String updateStockMasterName(@RequestParam Long stockMasterId, Double sellingPrice,Double mrp) {
      //  StockMaster existing = stockMasterService.getStockMaster(stockMaster.getStockMasterId());
        stockMasterService.updateStockMaster(stockMasterId,sellingPrice,mrp);
       // return "redirect:/stockmaster/" + master.getStockMasterId();
        return "redirect:/stockmaster";
    }

    @PostMapping("/delete")
    public String deleteStockMaster(@RequestParam Long id) {
        stockMasterService.deleteStockMaster(id);
        return "redirect:/stockmaster";
    }


}
