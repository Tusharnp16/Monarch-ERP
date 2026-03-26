package com.monarch.monarcherp.service;

import com.monarch.monarcherp.model.User;
import com.monarch.monarcherp.repository.UserRepository;
import org.springframework.context.annotation.Lazy;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    private final PasswordEncoder passwordEncoder;
    private final UserRepository userRepository;
    private final KafkaTemplate<String, String> kafkaTemplate;

    public UserService(UserRepository userRepository, @Lazy PasswordEncoder passwordEncoder, KafkaTemplate<String, String> kafkaTemplate) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.kafkaTemplate = kafkaTemplate;
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


    @Transactional
    public User saveAndNotify(String name, String email) {
        User user = new User();
        user.setUserName(name);
        user.setEmail(email);
        User savedUser = userRepository.save(user);

        kafkaTemplate.send("user-topic", "Created user: " + email);

        return savedUser;
    }

    public User getAuthnicatedUser(){
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        String username = auth.getName();

        return userRepository.findByUserName(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    public Long getAuthnicatedUserId(){
       return getAuthnicatedUser().getUserId();
    }

}
