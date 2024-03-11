package com.dietideals24.DietiDeals24.controller;

import com.dietideals24.DietiDeals24.entity.AuthenticationResponse;
import com.dietideals24.DietiDeals24.entity.User;
import com.dietideals24.DietiDeals24.repository.UserRepository;
import com.dietideals24.DietiDeals24.service.implementation.AuthenticationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class AuthenticationController {

    private final AuthenticationService authService;
    @Autowired
    private UserRepository userRepository;
    public AuthenticationController(AuthenticationService authService) {
        this.authService = authService;
    }

    //Registra un nuovo utente
    @PostMapping("/api/register")
    public ResponseEntity<AuthenticationResponse> register(@RequestBody User request){
        if (userRepository.findByUsername(request.getUsername()).isEmpty())
            return ResponseEntity.ok(authService.register(request));

        return new ResponseEntity<>(null, HttpStatus.BAD_REQUEST);
    }

    //Effettua l'accesso per un dato utente
    @PostMapping("/api/login")
    public ResponseEntity<AuthenticationResponse> login (@RequestBody User request){
        return ResponseEntity.ok(authService.authenticate(request));
    }
}
