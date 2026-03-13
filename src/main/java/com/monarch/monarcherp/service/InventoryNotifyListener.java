package com.monarch.monarcherp.service;

import org.postgresql.*;
import org.postgresql.PGNotification;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import jakarta.annotation.PostConstruct;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.Statement;

@Service
public class InventoryNotifyListener {

    private final DataSource dataSource;
    private final SimpMessagingTemplate messagingTemplate;

    public InventoryNotifyListener(DataSource dataSource, SimpMessagingTemplate messagingTemplate) {
        this.dataSource = dataSource;
        this.messagingTemplate = messagingTemplate;
    }

    @PostConstruct
    public void startListening() {
        Thread listenerThread = new Thread(() -> {
            try (Connection conn = dataSource.getConnection()) {
                Statement stmt = conn.createStatement();
                stmt.execute("LISTEN inventory_low");

                PGConnection pgConn = conn.unwrap(PGConnection.class);

                while (!Thread.currentThread().isInterrupted()) {
                    PGNotification[] notifications = pgConn.getNotifications(500);
                    if (notifications != null) {
                        for (PGNotification n : notifications) {
                            System.out.println("Notification : " + n.getParameter());
                            messagingTemplate.convertAndSend("/topic/inventory", n.getParameter());
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
        listenerThread.setDaemon(true);
        listenerThread.start();
    }
}