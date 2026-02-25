package com.monarch.monarcherp.service;

import com.monarch.monarcherp.model.Product;
import com.monarch.monarcherp.model.User;
import com.monarch.monarcherp.repository.UserRepository;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;
@Service
public class UserService {

    private final PasswordEncoder passwordEncoder;
    private final UserRepository userRepository;

    public UserService(UserRepository userRepository, @Lazy PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public User saveUser(User user) {
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        return userRepository.save(user);
    }

    public Optional<User> getUser(User user) {
        return userRepository.findById(user.getUserId());
    }

    public List<User> getAllUser() {
        return userRepository.findAll();
    }

    public void deleteUser(Long id) {
        userRepository.deleteById(id);
    }

    public long getTotalUser() {
        return userRepository.count();
    }

    public Optional<User> userExists(String userName) {
        return userRepository.findByUserName(userName);
    }

    public User updateUser(User user) {
        User updateUser = userRepository.findById(user.getUserId()).orElse(null);
        if (updateUser != null) {
            return userRepository.save(updateUser);
        }
        return null;
    }

}
