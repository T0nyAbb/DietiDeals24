package com.dietideals24.DietiDeals24.controller;

import com.dietideals24.DietiDeals24.entity.InverseAuction;
import com.dietideals24.DietiDeals24.service.AuctionService;
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
    @Autowired
    private AuctionService auctionService;

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

    //Modifica un'asta inversa esistente
    @PutMapping("/api/inverse_auction/{id}")
    public ResponseEntity<InverseAuction> updateInverseAuction (@PathVariable ("id") Long id,
                                                                @RequestBody InverseAuction inverseAuction){

        InverseAuction checkExists = (InverseAuction) auctionService.getAuctionById(id);
        if(checkExists == null)
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);

        inverseAuction.setId(id);
        inverseAuction = inverseAuctionService.updateInverseAuction(inverseAuction);

        return new ResponseEntity<>(inverseAuction, HttpStatus.OK);
    }
}
