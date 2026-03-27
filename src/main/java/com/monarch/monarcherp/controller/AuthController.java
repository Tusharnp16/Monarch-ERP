package com.monarch.monarcherp.controller;

import com.monarch.monarcherp.config.JwtUtils;
import com.monarch.monarcherp.dto.LoginRequest;
import com.monarch.monarcherp.model.RefreshToken;
import com.monarch.monarcherp.model.User;
import com.monarch.monarcherp.model.UserLoginLog;
import com.monarch.monarcherp.repository.BlacklistRepository;
import com.monarch.monarcherp.repository.RefreshTokenRepository;
import com.monarch.monarcherp.repository.UserLoginLogRepository;
import com.monarch.monarcherp.service.CustomUserDetailsService;
import com.monarch.monarcherp.service.RedisBlacklistService;
import com.monarch.monarcherp.service.TokenService;
import com.monarch.monarcherp.service.UserService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Controller
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    AuthenticationManager authenticationManager;

    @Autowired
    JwtUtils jwtUtils;

    @Autowired
    TokenService tokenService;

    @Autowired
    BlacklistRepository blacklistRepo;

    @Autowired
    RefreshTokenRepository refreshRepo;

    @Autowired
    CustomUserDetailsService userDetailsService;

    @Autowired
    UserService userService;

    @Autowired
    UserLoginLogRepository userLoginLogRepository;

    @Autowired
    RedisBlacklistService redisBlacklistService;

    @GetMapping("/login")
    public String getLoginPage() {
        return "login";
    }

    @GetMapping("/register")
    public String getRegisterPage() {
        return "register";
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody User user) {
        if (!userService.userExists(user.getUserName()).isEmpty()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Username already taken");
        }
        userService.saveUser(user);
        return ResponseEntity.ok("User registered successfully");
    }


    @PostMapping("/login")
    @ResponseBody
    public ResponseEntity<?> login(@RequestBody LoginRequest request, HttpServletRequest httpRequest) {

        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getUsername(), request.getPassword()));

        UserDetails userDetails = userDetailsService.loadUserByUsername(request.getUsername());
        String role = userDetails.getAuthorities().iterator().next().getAuthority();

        String accessToken = jwtUtils.generateAccessToken(userDetails.getUsername(), role);
        String refreshToken = jwtUtils.generateRefreshToken(userDetails.getUsername(),role);

//        tokenService.deleteTokensByUsername(userDetails.getUsername());

        tokenService.saveRefreshToken(new RefreshToken(null, userDetails.getUsername(), refreshToken,
                jwtUtils.getExpiration(refreshToken)));

        String clientIp = getClientIp(httpRequest);

        System.out.println(userDetails.getAuthorities());

        UserLoginLog log = UserLoginLog.builder()
                .username(userDetails.getUsername())
                .loginIp(clientIp)
                .build();
        userLoginLogRepository.save(log);

        return ResponseEntity.ok(Map.of(
                "accessToken", accessToken,
                "refreshToken", refreshToken
        ));
    }

    private String getClientIp(HttpServletRequest request) {
        String remoteAddr = "";

        if (request != null) {
            remoteAddr = request.getHeader("X-Forwarded-For");
            if (remoteAddr == null || "".equals(remoteAddr) || "unknown".equalsIgnoreCase(remoteAddr)) {
                remoteAddr = request.getHeader("Proxy-Client-IP");
            }
            if (remoteAddr == null || "".equals(remoteAddr) || "unknown".equalsIgnoreCase(remoteAddr)) {
                remoteAddr = request.getHeader("WL-Proxy-Client-IP");
            }
            if (remoteAddr == null || "".equals(remoteAddr) || "unknown".equalsIgnoreCase(remoteAddr)) {
                remoteAddr = request.getRemoteAddr();
            }
        }

        // If there are multiple IPs in X-Forwarded-For (comma separated), take the first one
        if (remoteAddr != null && remoteAddr.contains(",")) {
            return remoteAddr.split(",")[0].trim();
        }

        return remoteAddr;
    }


    @PostMapping("/refresh")
    @ResponseBody
    public ResponseEntity<?> refresh(@RequestBody Map<String, String> body) {

        String refreshToken = body.get("refreshToken");

        RefreshToken tokenEntity = refreshRepo.findByToken(refreshToken)
                .orElseThrow(() -> new RuntimeException("Invalid refresh token"));

        if (!jwtUtils.isValid(refreshToken)) {
            throw new RuntimeException("Expired refresh token");
        }

        UserDetails userDetails = userDetailsService.loadUserByUsername(tokenEntity.getUsername());
        String role = userDetails.getAuthorities().iterator().next().getAuthority();

        String newAccessToken = jwtUtils.generateAccessToken(userDetails.getUsername(), role);

        return ResponseEntity.ok(Map.of("accessToken", newAccessToken));
    }

    @PostMapping("/logout")
    @ResponseBody
    @Transactional
    public ResponseEntity<?> logout(HttpServletRequest request, HttpServletResponse response) {

        String header = request.getHeader("Authorization");

        if (header != null && header.startsWith("Bearer ")) {
            String token = header.substring(7);
//            blacklistRepo.save(new BlacklistedToken(null, token, jwtUtils.getExpiration(token)));

            long expiry = jwtUtils.getExpiration(token).getTime();
            redisBlacklistService.blackListToken(token, expiry);

            Cookie cookie = new Cookie("accessToken", null);
            cookie.setPath("/");
            cookie.setHttpOnly(true);
            cookie.setMaxAge(0);
            response.addCookie(cookie);

            String username = jwtUtils.extractUsername(token);
            tokenService.deleteTokensByUsername(username);
            tokenService.deleteTokensByTokenName(token);

            return ResponseEntity.ok("Logged out successfully");
        }

        return ResponseEntity.status(400).body("Logged out failed");
    }
}

