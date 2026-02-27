//package com.monarch.monarcherp.config;
//
//import org.springframework.context.annotation.Bean;
//import org.springframework.context.annotation.Configuration;
//import org.springframework.messaging.Message;
//import org.springframework.messaging.simp.SimpMessageType; // IMPORTANT IMPORT
//import org.springframework.security.authorization.AuthorizationManager;
//import org.springframework.security.config.annotation.web.socket.EnableWebSocketSecurity;
//import org.springframework.security.messaging.access.intercept.MessageMatcherDelegatingAuthorizationManager;
//
//@Configuration
//@EnableWebSocketSecurity
//public class WebSocketSecurityConfig {
//
//    @Bean
//    AuthorizationManager<Message<?>> messageAuthorizationManager(MessageMatcherDelegatingAuthorizationManager.Builder messages) {
//        messages
//                // 1. ALLOW the "door" to open (CONNECT) and close (DISCONNECT)
//                // Without this, you get the "Failed to send message" ERROR
//                .simpTypeMatchers(SimpMessageType.CONNECT, SimpMessageType.DISCONNECT, SimpMessageType.OTHER).permitAll()
//
//                // 2. Allow messages that don't have a specific destination
//                .nullDestMatcher().permitAll()
//
//                // 3. Your specific business rules for Monarch ERP
//                .simpSubscribeDestMatchers("/topic/admin-alerts").hasRole("ADMIN")
//                .simpSubscribeDestMatchers("/topic/variants").authenticated()
//
//                // 4. Fallback for safety
//                .anyMessage().authenticated();
//
//        return messages.build();
//    }
//
//    @Bean
//    public boolean sameOriginDisabled() {
//        return true;
//    }
//}