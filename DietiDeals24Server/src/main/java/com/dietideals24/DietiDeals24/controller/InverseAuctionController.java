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
@RequestMapping
public class InverseAuctionController {

    @Autowired
    @Qualifier("mainInverseAuctionService")
    private InverseAuctionService inverseAuctionService;

    //Posta un'asta inversa
    @PostMapping("/api/inverse_auction")
    public ResponseEntity<InverseAuction> createInverseAuction (@RequestBody InverseAuction inverseAuction){
        InverseAuction savedInverseAuction = inverseAuctionService.createInverseAuction(inverseAuction);
        return new ResponseEntity<>(savedInverseAuction, HttpStatus.CREATED);
    }

    //Ottiene una lista di tutte le aste inverse
    @GetMapping("/api/inverse_auctions")
    public ResponseEntity<List<InverseAuction>> getAllInverseAuctions() {
        List<InverseAuction> inverseAuctions = inverseAuctionService.getAllInverseAuctions();
        return new ResponseEntity<>(inverseAuctions, HttpStatus.OK);
    }

    //Ottiene una singola asta inversa in base all'id specificato
    @GetMapping ("/api/inverse_auction/{id}")
    public ResponseEntity<InverseAuction> getInverseAuctionById(@PathVariable Long id) {
        InverseAuction inverseAuction = inverseAuctionService.getInverseAuctionById(id);
        if(inverseAuction == null)
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);

        return new ResponseEntity<>(inverseAuction, HttpStatus.OK);
    }

}
