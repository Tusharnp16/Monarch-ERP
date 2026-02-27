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
//    AuthorizationManager<Message<?>> messageAuthorizationManager(
//            MessageMatcherDelegatingAuthorizationManager.Builder messages) {
//
//        messages
//                .simpTypeMatchers(
//                        SimpMessageType.CONNECT,
//                        SimpMessageType.DISCONNECT,
//                        SimpMessageType.OTHER
//                ).permitAll()
//
//                .nullDestMatcher().permitAll()
//
//                .simpSubscribeDestMatchers("/topic/admin-alerts")
//                .hasRole("ADMIN")
//
//                .simpSubscribeDestMatchers("/topic/variants")
//                .authenticated()
//
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