package com.dietideals24.DietiDeals24.service;

import com.dietideals24.DietiDeals24.entity.User;

import java.util.List;

public interface UserService {
    User createUser(User user);

    User getUserById(Long userId);

    List<User> getAllUsers();

    User updateUser(User user);

    void deleteUser(Long userId);
}
