package com.monarch.monarcherp.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.concurrent.CompletableFuture;

@Service
public class NotificationService {

    private static final Logger log = LoggerFactory.getLogger(NotificationService.class);
    private final JavaMailSender mailSender;

    @Value("${MY_APP_MAIL_USER}")
    private String senderEmail;

    public NotificationService(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    @Async
    public CompletableFuture<Void> sendInvoiceEmail(String email,Long invoiceId){

        try{
            if (email == null || !email.contains("@")) {
                throw new RuntimeException("Invalid email address provided!");
            }

            SimpleMailMessage mailMessage=new SimpleMailMessage();
            mailMessage.setFrom(senderEmail);
            mailMessage.setTo(email);
            mailMessage.setSubject("Invoice Confirmation - #" + invoiceId);
            mailMessage.setText("Thank you for your purchase. Your invoice #" + invoiceId + " has been processed.");

            mailSender.send(mailMessage);

            log.info("Email successfully sent to {}", email);

            System.out.println("Email sent successfully to: " + email);
            return CompletableFuture.completedFuture(null);
        }catch (Exception e){
            log.error("FAILED to send email for Invoice {}: {}", invoiceId, e.getMessage());
            System.err.println("Async Error: Failed to send email for Invoice " + invoiceId + ". Reason: " + e.getMessage());
            return CompletableFuture.failedFuture(e);
        }


    }
}
