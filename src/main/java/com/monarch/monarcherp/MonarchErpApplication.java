package com.monarch.monarcherp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.jdbc.autoconfigure.DataSourceAutoConfiguration;
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@EnableAsync
public class MonarchErpApplication {

	public static void main(String[] args) {
		SpringApplication.run(MonarchErpApplication.class, args);
		System.out.println("Hello World");
	}

}
