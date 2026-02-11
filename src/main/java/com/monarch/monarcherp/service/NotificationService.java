package com.monarch.monarcherp.service;

import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.concurrent.CompletableFuture;

@Service
public class NotificationService {

    @Async
    public CompletableFuture<Void> sendInvoiceEmail(String email,Long invoiceId){

        try{
            if (email == null || !email.contains("@")) {
                throw new RuntimeException("Invalid email address provided!");
            }

            System.out.println("Email sent successfully to: " + email);
            return CompletableFuture.completedFuture(null);
        }catch (Exception e){
            System.err.println("Async Error: Failed to send email for Invoice " + invoiceId + ". Reason: " + e.getMessage());
            return CompletableFuture.failedFuture(e);
        }


    }
}
