package com.monarch.monarcherp.config;

import com.monarch.monarcherp.repository.BlacklistRepository;
import com.monarch.monarcherp.service.CustomUserDetailsService;
import com.monarch.monarcherp.service.RedisBlacklistService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
public class JwtFilter extends OncePerRequestFilter {

    @Autowired JwtUtils jwtUtils;
    @Autowired CustomUserDetailsService userDetailsService;
    @Autowired BlacklistRepository blacklistRepository;
    @Autowired
    RedisBlacklistService redisBlacklistService;
    private static final Logger log = LoggerFactory.getLogger(JwtFilter.class);

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain)
            throws ServletException, IOException {

        String token = null;
        String username = null;

        String header = request.getHeader("Authorization");
        if (header != null && header.startsWith("Bearer ")) {
            token = header.substring(7);
        }

        else if (request.getCookies() != null) {
            for (Cookie cookie : request.getCookies()) {
                if ("accessToken".equals(cookie.getName())) {
                    token = cookie.getValue();
                    break;
                }
            }
        }

//        if (blacklistRepository.existsByToken(token)) { response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); return; }
//

//
//        if (token != null) {
//            if (blacklistRepository.existsByToken(token)) {
////                filterChain.doFilter(request, response);
//                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
//                response.getWriter().write("Token is blacklisted");
//                return;
//            }
//
//            if (jwtUtils.isValid(token)) {
//                username = jwtUtils.extractUsername(token);
//            }
//        }

        if (token != null) {
            if (redisBlacklistService.isBlackListed(token)) {
//                filterChain.doFilter(request, response);
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("Token is blacklisted");
                return;
            }


            if (jwtUtils.isValid(token)) {
                username = jwtUtils.extractUsername(token);
            }
        }

        if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
            UserDetails userDetails = userDetailsService.loadUserByUsername(username);

            UsernamePasswordAuthenticationToken auth =
                    new UsernamePasswordAuthenticationToken(
                            userDetails, null, userDetails.getAuthorities());

            auth.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
            SecurityContextHolder.getContext().setAuthentication(auth);
        }

        log.info("JWT Limiting Filter Working");

        filterChain.doFilter(request, response);
    }
}