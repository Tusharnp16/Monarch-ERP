package com.monarch.monarcherp.service;

import net.sf.jasperreports.engine.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.io.InputStream;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;

@Service
public class JasperReportService {

    @Autowired
    private DataSource dataSource;

    public byte[] generateInvoice(Long invoiceId) throws Exception {

        InputStream reportStream = getClass().getResourceAsStream("/reports/MonarchBill.jrxml");

        if (reportStream == null) {
            throw new RuntimeException("Report file not found in /resources/reports/MonarchERP.jrxml");
        }

        JasperReport jasperReport = JasperCompileManager.compileReport(reportStream);

        Map<String, Object> parameters = new HashMap<>();
        parameters.put("INVOICE_ID", invoiceId);
        parameters.put("logo", "static/logo.png");

        try (Connection connection = dataSource.getConnection()) {
            JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, connection);

            return JasperExportManager.exportReportToPdf(jasperPrint);

        }
    }
}