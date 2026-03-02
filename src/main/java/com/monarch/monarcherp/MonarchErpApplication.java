package com.monarch.monarcherp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.web.bind.annotation.CrossOrigin;

@SpringBootApplication
@EnableAsync
@EnableCaching
@EnableScheduling
@CrossOrigin(origins = "http://localhost:5173")
public class MonarchErpApplication {

    public static void main(String[] args) {
        SpringApplication.run(MonarchErpApplication.class, args);
        System.out.println("Hello World");
    }

}
