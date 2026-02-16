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
        // 1. Load the JRXML file from the resources folder
        InputStream reportStream = getClass().getResourceAsStream("/reports/MonarchERP.jrxml");

        if (reportStream == null) {
            throw new RuntimeException("Report file not found in /resources/reports/MonarchERP.jrxml");
        }

        // 2. Compile the report template
        JasperReport jasperReport = JasperCompileManager.compileReport(reportStream);

        // 3. Setup parameters for the SQL query
        Map<String, Object> parameters = new HashMap<>();
        parameters.put("INVOICE_ID", invoiceId);

        // 4. Fill the report using your PostgreSQL connection
        try (Connection connection = dataSource.getConnection()) {
            JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, connection);

            // 5. Convert the filled report to a PDF byte array
            return JasperExportManager.exportReportToPdf(jasperPrint);
        }
    }
}