package com.monarch.monarcherp.service;

import com.monarch.monarcherp.model.SalesInvoice;
import com.monarch.monarcherp.model.SalesItem;
import jakarta.mail.internet.MimeMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.concurrent.CompletableFuture;

@Service
public class NotificationService {

    private static final Logger log = LoggerFactory.getLogger(NotificationService.class);
    private final JavaMailSender mailSender;

    private final JasperReportService jasperReportService;

    @Value("${MY_APP_MAIL_USER}")
    private String senderEmail;

    public NotificationService(JavaMailSender mailSender, JasperReportService jasperReportService) {
        this.mailSender = mailSender;
        this.jasperReportService = jasperReportService;
    }

    @Async("mailExecutor")
    public CompletableFuture<Void> sendInvoiceEmail(SalesInvoice invoice){

        try{
            if (invoice.getCustomer().getEmail() == null || !invoice.getCustomer().getEmail() .contains("@")) {
                throw new RuntimeException("Invalid email address provided!");
            }

//            SimpleMailMessage mailMessage=new SimpleMailMessage();
//            mailMessage.setFrom("Monarch-ERP Billing <" + senderEmail + ">");
//            mailMessage.setTo(invoice.getCustomer().getEmail() );
//            mailMessage.setSubject("Monarch-ERP: Sales Bill #" + invoice.getInvoiceNumber());
//
//            StringBuilder body = new StringBuilder();
//            body.append("Dear ").append(invoice.getCustomer().getName()).append(",\n\n");
//            body.append("Thank you for choosing Monarch-ERP. Your order has been successfully processed.\n");
//            body.append("-------------------------------------------\n");
//            body.append("Invoice No: ").append(invoice.getInvoiceNumber()).append("\n");
//            body.append("Date: ").append(java.time.LocalDate.now()).append("\n");
//            body.append("-------------------------------------------\n\n");
//
//            body.append(String.format("%-20s %-10s %-10s\n", "Item", "Qty", "Price"));
//            body.append("-------------------------------------------\n");
//
//            for (SalesItem item : invoice.getItems()) {
//                body.append(String.format("%-20s %-10d ₹%-10.2f\n",
//                        item.getVariant().getVariantName(),
//                        item.getQuantity(),
//                        item.getUnitPrice()));
//            }
//
//            body.append("-------------------------------------------\n");
//            body.append("Discount : ₹").append(invoice.getDiscountAmount()).append("\n\n");
//            body.append("Total Amount: ₹").append(invoice.getGrandTotal()).append("\n\n");
//            body.append("Best Regards,\n");
//            body.append("Monarch-ERP Team");
//            body.append("\n\n*** This is an automated message. Please do not reply to this email. ***");
//
//            mailMessage.setText(body.toString());
//
//            mailSender.send(mailMessage);
//
//
//
//            System.out.println("Email sent successfully to: " + invoice.getCustomer().getEmail());
//            return CompletableFuture.completedFuture(null);


            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true);

            helper.setFrom("Monarch-ERP Billing <" + senderEmail + ">");
            helper.setTo(invoice.getCustomer().getEmail());
            helper.setSubject("Monarch-ERP: Sales Bill #" + invoice.getInvoiceNumber());

            StringBuilder body = new StringBuilder();
            body.append("Dear ").append(invoice.getCustomer().getName()).append(",\n\n");
            body.append("Please find your attached invoice for order #").append(invoice.getInvoiceNumber()).append(".\n\n");
            body.append("Best Regards,\nMonarch-ERP Team");

            helper.setText(body.toString());

            byte[] pdfBytes = jasperReportService.generateInvoice(invoice.getId());

            helper.addAttachment("Invoice_" + invoice.getInvoiceNumber() + ".pdf",
                    new ByteArrayResource(pdfBytes));

            mailSender.send(message);
            log.debug("Email successfully sent to {}", invoice.getCustomer().getEmail());
            return CompletableFuture.completedFuture(null);
        }catch (Exception e){
            log.error("FAILED to send email for Invoice {}: {}", invoice.getInvoiceNumber(), e.getMessage());
            return CompletableFuture.failedFuture(e);
        }


    }
}
