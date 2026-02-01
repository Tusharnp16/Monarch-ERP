package com.monarch.monarcherp.service;

import com.monarch.monarcherp.model.RefreshToken;
import com.monarch.monarcherp.repository.RefreshTokenRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class TokenService {

    @Autowired
    private RefreshTokenRepository refreshTokenRepository;

    @Transactional
    public void deleteTokensByUsername(String username) {
        refreshTokenRepository.deleteByUsername(username);
    }

    @Transactional
    public void saveRefreshToken(RefreshToken token) {
        refreshTokenRepository.save(token);
    }
}
