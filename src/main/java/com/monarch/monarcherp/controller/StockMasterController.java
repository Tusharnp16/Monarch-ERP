package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.model.Product;
import com.monarch.monarcherp.model.StockMaster;
import com.monarch.monarcherp.service.ProductService;
import com.monarch.monarcherp.service.StockMasterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/stockmaster")
class StockMasterController {


    @Autowired
    private StockMasterService stockMasterService;
    @Autowired
    private ProductService productService;

    @GetMapping
    public String viewStockMaster(Model model) {
        model.addAttribute("stockMasters", stockMasterService.getAllStockMasters());
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
        return "redirect:/stock-master";
    }

    @PostMapping("/update")
    public String updateStockMasterName(@ModelAttribute StockMaster stockMaster) {
      //  StockMaster existing = stockMasterService.getStockMaster(stockMaster.getStockMasterId());
        stockMasterService.saveStockMaster(stockMaster);
        return "redirect:/stock-master/" + stockMaster.getStockMasterId();
    }

    @PostMapping("/delete")
    public String deleteStockMaster(@RequestParam Long id) {
        stockMasterService.deleteStockMaster(id);
        return "redirect:/stock-master";
    }

}
