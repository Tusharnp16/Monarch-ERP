package com.monarch.monarcherp.service;

import com.monarch.monarcherp.model.SalesInvoice;
import com.monarch.monarcherp.model.SalesItem;
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
    public CompletableFuture<Void> sendInvoiceEmail(SalesInvoice invoice){

        try{
            if (invoice.getCustomer().getEmail() == null || !invoice.getCustomer().getEmail() .contains("@")) {
                throw new RuntimeException("Invalid email address provided!");
            }

            SimpleMailMessage mailMessage=new SimpleMailMessage();
            mailMessage.setFrom(senderEmail);
            mailMessage.setTo(invoice.getCustomer().getEmail() );
            mailMessage.setSubject("Monarch-ERP: Sales Bill #" + invoice.getInvoiceNumber());

            StringBuilder body = new StringBuilder();
            body.append("Dear ").append(invoice.getCustomer().getName()).append(",\n\n");
            body.append("Thank you for choosing Monarch-ERP. Your order has been successfully processed.\n");
            body.append("-------------------------------------------\n");
            body.append("Invoice No: ").append(invoice.getInvoiceNumber()).append("\n");
            body.append("Date: ").append(java.time.LocalDate.now()).append("\n");
            body.append("-------------------------------------------\n\n");

            body.append(String.format("%-20s %-10s %-10s\n", "Item", "Qty", "Price"));
            body.append("-------------------------------------------\n");

            for (SalesItem item : invoice.getItems()) {
                body.append(String.format("%-20s %-10d ₹%-10.2f\n",
                        item.getVariant().getVariantName(),
                        item.getQuantity(),
                        item.getUnitPrice()));
            }

            body.append("-------------------------------------------\n");
            body.append("Discount : ₹").append(invoice.getDiscountAmount()).append("\n\n");
            body.append("Total Amount: ₹").append(invoice.getGrandTotal()).append("\n\n");
            body.append("Best Regards,\n");
            body.append("Monarch-ERP Team");

            mailMessage.setText(body.toString());


            mailSender.send(mailMessage);

            log.info("Email successfully sent to {}", invoice.getCustomer().getEmail());

            System.out.println("Email sent successfully to: " + invoice.getCustomer().getEmail());
            return CompletableFuture.completedFuture(null);
        }catch (Exception e){
            log.error("FAILED to send email for Invoice {}: {}", invoice.getInvoiceNumber(), e.getMessage());
            System.err.println("Async Error: Failed to send email for Invoice " +  invoice.getInvoiceNumber() + ". Reason: " + e.getMessage());
            return CompletableFuture.failedFuture(e);
        }


    }
}
