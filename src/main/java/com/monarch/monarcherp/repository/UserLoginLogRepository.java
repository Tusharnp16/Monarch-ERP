package com.monarch.monarcherp.repository;

import com.monarch.monarcherp.model.User;
import com.monarch.monarcherp.model.UserLoginLog;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface UserLoginLogRepository extends JpaRepository<UserLoginLog, Long> {
    List<UserLoginLog> findByUsernameOrderByLoginTimeDesc(String username);

}
