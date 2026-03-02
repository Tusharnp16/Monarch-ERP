package com.monarch.monarcherp.service;

import com.monarch.monarcherp.model.User;
import com.monarch.monarcherp.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.time.Duration;

@Service
public class RedisBlacklistService {

    @Autowired
    StringRedisTemplate stringRedisTemplate;

    @Autowired
    UserRepository userRepository;

    public void blackListToken(String token, Long expireTime) {
        long ttl = expireTime - System.currentTimeMillis();

        if (ttl > 0) {
            stringRedisTemplate.opsForValue().set(token, "true", Duration.ofMillis(ttl));
        }
    }

    @Cacheable(value = "users", key = "#username")
    public User loadUserEntityByUsername(String username) throws UsernameNotFoundException {
        return userRepository.findByUserName(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));
    }

    public Boolean isBlackListed(String token) {
        return Boolean.TRUE.equals(stringRedisTemplate.hasKey(token));
    }
}
