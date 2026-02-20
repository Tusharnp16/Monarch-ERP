package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.config.DiscountConfig;
import com.monarch.monarcherp.dto.ApiResponse;
import com.monarch.monarcherp.model.Inventory;
import com.monarch.monarcherp.model.UserLoginLog;
import com.monarch.monarcherp.repository.UserLoginLogRepository;
import com.monarch.monarcherp.service.CustomerService;
import com.monarch.monarcherp.service.InventoryService;
import com.monarch.monarcherp.service.SalesItemService;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import tools.jackson.core.util.RecyclerPool;

import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping
class TestingController {

    @Autowired
    UserLoginLogRepository userLoginLogRepository;

    @Autowired
    private CustomerService customerService;

    @Autowired
    private InventoryService inventoryService;

    @Autowired
    private SalesItemService salesItemService;

    @Autowired
    private DiscountConfig discountConfig;

    @GetMapping("/")
    public String getDefaultPage(){
        return "403";
    }

    @GetMapping("userlogs")
    public String getServerLog(ServletRequest servletRequest){
        return "serverlog";
    }

    @GetMapping("/api/userlogs")
    @ResponseBody
    public ResponseEntity<ApiResponse<List<UserLoginLog>>> showUserLogs(HttpServletRequest request, Model model) {
        String currentUsername = SecurityContextHolder
                .getContext().getAuthentication().getName();

        System.out.println("DEBUG : " + currentUsername);

        List<UserLoginLog> userLog=userLoginLogRepository.findByUsernameOrderByLoginTimeDesc(currentUsername);

        return ResponseEntity.ok(ApiResponse.success(userLog,"User Log Fetched"));
    }

    @GetMapping("/contacts")
    public String contact() {
        return "contacts";
    }

    @GetMapping("/products")
    public String product() {
        return "products";
    }

    @GetMapping("/variants")
    public String varinat() {
        return "variants";
    }

    @GetMapping("/inventory")
    public String viewInventory(){
        return "inventory";
    }

    @GetMapping("/stockmaster")
    public String viewStockMaster(){
        return "stock-master";
    }

    @GetMapping("/salesitem/recentitems")
    public String viewRecentItem(){
        return "recentsalesitems";
    }

    @GetMapping("/customers")
    public String customer() {
        return "customers";
    }

    @GetMapping("/purchase")
    public String purchase() {
        return "purchases";
    }

    @GetMapping("/salesinvoice")
    public String salesInvoice() {
        return "sales";
    }
}
