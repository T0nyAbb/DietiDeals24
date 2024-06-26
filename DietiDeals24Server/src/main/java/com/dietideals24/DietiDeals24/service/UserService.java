package com.dietideals24.DietiDeals24.service;

import com.dietideals24.DietiDeals24.entity.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public interface UserService {

    User getUserById (Long id);

    Optional<User> getUserByUsername(String username);

    List<User> getAllUsers();

    User updateUser(User user);

    void deleteUser(Long userId);

    UserDetails loadUserByUsername (String username) throws UsernameNotFoundException;
}
