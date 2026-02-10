package com.monarch.monarcherp.config;

import com.monarch.monarcherp.dto.ApiResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Repository;
import tools.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class RateLimiterFilter implements Filter {


    private final ObjectMapper objectMapper;
    private final ConcurrentHashMap<String, TokenBucket> limiters = new ConcurrentHashMap<>();

    public RateLimiterFilter(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        String ipAddr = httpRequest.getRemoteAddr();

        TokenBucket bucket = limiters.computeIfAbsent(ipAddr, k -> new TokenBucket());

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