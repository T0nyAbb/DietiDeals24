package com.dietideals24.DietiDeals24.service.implementation;

import com.dietideals24.DietiDeals24.entity.User;
import com.dietideals24.DietiDeals24.repository.UserRepository;
import com.dietideals24.DietiDeals24.service.UserService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service("mainUserService")
@AllArgsConstructor
public class UserServiceImplementation implements UserDetailsService, UserService {

    @Autowired
    private final UserRepository userRepository;

    @Override
    public User getUserById(Long id){
        return userRepository.getUserById(id);
    }

    @Override
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    @Override
    public Optional<User> getUserByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    @Override
    public User updateUser(User user) {
        User existingUser = userRepository.findById(user.getId()).get();

        existingUser.setFirstName(user.getFirstName());
        existingUser.setLastName(user.getLastName());
        existingUser.setUsername(user.getUsername());
        existingUser.setPassword(user.getPassword());
        existingUser.setBio(user.getBio());
        existingUser.setWebsite(user.getWebsite());
        existingUser.setSocial(user.getSocial());
        existingUser.setGeographicArea(user.getGeographicArea());
        existingUser.setGoogle(user.getGoogle());
        existingUser.setFacebook(user.getFacebook());
        existingUser.setApple(user.getApple());
        existingUser.setProfilePicture(user.getProfilePicture());
        existingUser.setIban(user.getIban());
        existingUser.setVatNumber(user.getVatNumber());
        existingUser.setNationalInsuranceNumber(user.getNationalInsuranceNumber());

        User updatedUser = userRepository.save(existingUser);
        return updatedUser;
    }

    @Override
    public void deleteUser(Long userId) {
        userRepository.deleteById(userId);
    }

    @Override
    public UserDetails loadUserByUsername (String username) throws UsernameNotFoundException {
        return userRepository.findByUsername(username).orElseThrow(()-> new UsernameNotFoundException("User not found"));
    }
}
