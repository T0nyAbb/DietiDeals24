package com.dietideals24.DietiDeals24.controller;

import com.dietideals24.DietiDeals24.entity.InverseAuction;
import com.dietideals24.DietiDeals24.service.InverseAuctionService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@AllArgsConstructor
@RequestMapping("api/i_auction")
public class InverseAuctionController {

    @Autowired
    @Qualifier("mainInverseAuctionService")
    private InverseAuctionService inverseAuctionService;
    //Posta un'asta inversa
    @PostMapping
    public ResponseEntity<InverseAuction> createInverseAuction (@RequestBody InverseAuction inverseAuction){
        InverseAuction savedInverseAuction = inverseAuctionService.createInverseAuction(inverseAuction);
        return new ResponseEntity<>(savedInverseAuction, HttpStatus.CREATED);
    }

    //Ottiene una lista di tutte le aste inverse
    @GetMapping
    public ResponseEntity<List<InverseAuction>> getAll() {
        List<InverseAuction> inverseAuctions = inverseAuctionService.getAllUsers();
        return new ResponseEntity<>(inverseAuctions, HttpStatus.OK);
    }

    //Ottiene una singola asta inversa in base all'id specificato
    @GetMapping ("{id}")
    public ResponseEntity<InverseAuction> getInverseAuctionById(@PathVariable Long id) {
        InverseAuction inverseAuction = inverseAuctionService.getInverseAuctionById(id);
        return new ResponseEntity<>(inverseAuction, HttpStatus.OK);
    }

}
