//package com.monarch.monarcherp.config;
//
//import com.monarch.monarcherp.service.CustomUserDetailsService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.messaging.Message;
//import org.springframework.messaging.MessageChannel;
//import org.springframework.messaging.simp.stomp.StompCommand;
//import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
//import org.springframework.messaging.support.ChannelInterceptor;
//import org.springframework.messaging.support.MessageHeaderAccessor;
//import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
//import org.springframework.security.core.userdetails.UserDetails;
//import org.springframework.stereotype.Component;
//
//@Component
//public class JwtChannelInterceptor implements ChannelInterceptor {
//
//    private final JwtUtils jwtUtils;
//    private final CustomUserDetailsService userDetailsService;
//
//    @Autowired
//    public JwtChannelInterceptor(JwtUtils jwtUtils,
//                                 CustomUserDetailsService userDetailsService) {
//        this.jwtUtils = jwtUtils;
//        this.userDetailsService = userDetailsService;
//    }
//
//    @Override
//    public Message<?> preSend(Message<?> message, MessageChannel channel) {
//
//        StompHeaderAccessor accessor =
//                MessageHeaderAccessor.getAccessor(message, StompHeaderAccessor.class);
//
//        if (accessor != null && StompCommand.CONNECT.equals(accessor.getCommand())) {
//
//            String authHeader = accessor.getFirstNativeHeader("Authorization");
//
//            if (authHeader != null && authHeader.startsWith("Bearer ")) {
//
//                String token = authHeader.substring(7);
//
//                if (jwtUtils.isValid(token)) {
//
//                    String username = jwtUtils.extractUsername(token);
//
//                    UserDetails userDetails =
//                            userDetailsService.loadUserByUsername(username);
//
//                    UsernamePasswordAuthenticationToken authentication =
//                            new UsernamePasswordAuthenticationToken(
//                                    userDetails,
//                                    null,
//                                    userDetails.getAuthorities()
//                            );
//
//                    accessor.setUser(authentication);
//                }
//            }
//        }
//
//        return message;
//    }
//}