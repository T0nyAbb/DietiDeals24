package com.dietideals24.DietiDeals24.controller;

import com.dietideals24.DietiDeals24.service.UserService;
import com.dietideals24.DietiDeals24.entity.User;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@AllArgsConstructor
@RequestMapping
public class UserController {

    @Autowired
    @Qualifier("mainUserService")
    private UserService userService;

    //Restituisce un'utente dato un id
    @PostMapping("/api/user/id/{id}")
    public ResponseEntity<User> getUserById(@PathVariable("id") Long userId) {
        User user = userService.getUserById(userId);

        if(user == null)
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);

        return new ResponseEntity<>(user, HttpStatus.OK);
    }

    //Restituisce un'utente dato un username(email) >>[REQUISITO FRONTEND]<<
    @PostMapping("/api/user/{username}")
    public ResponseEntity<User> getUserByUsername(@PathVariable("username") String username) {
        Optional<User> optionalUser = userService.getUserByUsername(username);
        if(optionalUser.isEmpty())
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        User user = optionalUser.get();
        return new ResponseEntity<>(user, HttpStatus.OK);
    }

    //Restituisce la lista di tutti gli utenti
    @GetMapping("/api/users")
    public ResponseEntity<List<User>> getAllUsers(){
        List<User> users = userService.getAllUsers();
        if (users.isEmpty())
            return ResponseEntity.notFound().build();

        return new ResponseEntity<>(users, HttpStatus.OK);
    }

    //Aggiorna  le informazioni di un'utente dato un id
    @PutMapping("/api/user/{id}")
    public ResponseEntity<User> updateUser(@PathVariable("id") Long userId,
                                           @RequestBody User user) {
        User checkUser = userService.getUserById(userId);
        if(checkUser == null)
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        user.setId(userId);
        User updatedUser = userService.updateUser(user);
        return new ResponseEntity<>(updatedUser, HttpStatus.OK);
    }

    //Elimina un'utente dato un id
    @DeleteMapping("/api/user/{id}")
    public ResponseEntity<String> deleteUser(@PathVariable("id") Long userId) {
        userService.deleteUser(userId);
        return new ResponseEntity<>("User successfully deleted!", HttpStatus.OK);
    }
}
