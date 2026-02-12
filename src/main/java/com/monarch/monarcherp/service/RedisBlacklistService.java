package com.monarch.monarcherp.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;


import java.time.Duration;
import java.time.LocalTime;

@Service
public class RedisBlacklistService {

    @Autowired
    StringRedisTemplate stringRedisTemplate;

//    private RedisTemplate<Object, Object> redisTemplate;


    public void blackListToken(String token, Long expireTime){
        long ttl=expireTime-System.currentTimeMillis();

        if(ttl>0){
            stringRedisTemplate.opsForValue().set(token,"true", Duration.ofMillis(ttl));
        }
    }

    public Boolean isBlackListed(String token){
        return Boolean.TRUE.equals(stringRedisTemplate.hasKey(token));
    }
}
