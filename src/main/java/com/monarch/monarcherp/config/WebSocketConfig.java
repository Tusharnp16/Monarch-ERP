package com.monarch.monarcherp.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.ChannelRegistration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
//@CrossOrigin(origins = "http://localhost:5173")
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {
//
//    @Autowired
//    private JwtChannelInterceptor jwtChannelInterceptor;
//
//    public WebSocketConfig(JwtChannelInterceptor jwtChannelInterceptor) {
//        this.jwtChannelInterceptor = jwtChannelInterceptor;
//    }
//
//    @Override
//    public void configureClientInboundChannel(ChannelRegistration registration) {
//        registration.interceptors(jwtChannelInterceptor);
//    }

    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        config.enableSimpleBroker("/topic");
        config.setApplicationDestinationPrefixes("/app");
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/ws-monarch")
//                .setAllowedOrigins("*")
                .setAllowedOriginPatterns("http://localhost:5173")
                .withSockJS();
    }
}
