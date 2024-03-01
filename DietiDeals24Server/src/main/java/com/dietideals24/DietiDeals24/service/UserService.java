package com.dietideals24.DietiDeals24.service;

import com.dietideals24.DietiDeals24.entity.User;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public interface UserService {
    User createUser(User user);

    Optional<User> getUserById(Long userId);

    List<User> getAllUsers();

    User updateUser(User user);

    void deleteUser(Long userId);

    User login(String email, String password);
}
