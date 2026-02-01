package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.model.BlacklistedToken;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BlacklistRepository extends JpaRepository<BlacklistedToken, Long> {
    boolean existsByToken(String token);
}
