package com.monarch.monarcherp.config;

import com.monarch.monarcherp.dto.ApiResponse;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import tools.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class RateLimiterFilter extends OncePerRequestFilter {


    private static final Logger log = LoggerFactory.getLogger(RateLimiterFilter.class);
    private final ObjectMapper objectMapper;
    private final ConcurrentHashMap<String, TokenBucket> limiters = new ConcurrentHashMap<>();

    public RateLimiterFilter(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
    }

    @Override
    public void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        String ipAddr = httpRequest.getRemoteAddr();


        String key;
        if (SecurityContextHolder.getContext().getAuthentication() != null &&
                SecurityContextHolder.getContext().getAuthentication().isAuthenticated() &&
                !"anonymousUser".equals(SecurityContextHolder.getContext().getAuthentication().getName())) {
            key = SecurityContextHolder.getContext().getAuthentication().getName();
        } else {
            key = ipAddr;
        }

        TokenBucket bucket = limiters.computeIfAbsent(key, k -> new TokenBucket());

        System.out.println(limiters);
        log.info("Rate Limiting Filter Working");

        if (bucket.allowRequest()) {
            chain.doFilter(request, response);
        } else {
            HttpServletResponse httpResponse = (HttpServletResponse) response;
            httpResponse.setStatus(429);

            Object errorBody = ApiResponse.error("Too many requests. Please slow down.");
            String jsonResponse = objectMapper.writeValueAsString(errorBody);

            httpResponse.getWriter().write(jsonResponse);
        }
    }

}