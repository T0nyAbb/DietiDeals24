package com.dietideals24.DietiDeals24.service.implementation;

import com.dietideals24.DietiDeals24.entity.User;
import com.dietideals24.DietiDeals24.repository.UserRepository;
import com.dietideals24.DietiDeals24.service.UserService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service("mainUserService")
@AllArgsConstructor
public class UserServiceImplementation implements UserService {

    @Autowired
    private UserRepository userRepository;

    @Override
    public User createUser(User user) {
        return userRepository.save(user);
    }

    @Override
    public Optional<User> getUserById(Long userId) {
        return userRepository.findById(userId);
    }

    @Override
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    @Override
    public User updateUser(User user) {
        User existingUser = userRepository.findById(user.getId()).get();
        existingUser.setFirstName(user.getFirstName());
        existingUser.setLastName(user.getLastName());
        existingUser.setEmail(user.getEmail());
        User updatedUser = userRepository.save(existingUser);
        return updatedUser;
    }

    @Override
    public void deleteUser(Long userId) {
        userRepository.deleteById(userId);
    }

    @Override
    public User login(String email, String password) {
        List<User> list = getAllUsers();
        User optionalUser = null;
        for(User user: list){
            if(user.getEmail().equals(email) && user.getPassword().equals(password)) {
                optionalUser = user;
                System.out.println("dentro l'if");
            }
        }
        return optionalUser;
    }


}
