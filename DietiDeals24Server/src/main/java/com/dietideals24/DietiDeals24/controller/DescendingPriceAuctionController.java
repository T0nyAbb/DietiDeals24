package com.dietideals24.DietiDeals24.controller;

import com.dietideals24.DietiDeals24.entity.DescendingPriceAuction;
import com.dietideals24.DietiDeals24.service.DescendingPriceAuctionService;
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
public class DescendingPriceAuctionController {
    @Autowired
    @Qualifier("mainDescendingPriceAuctionService")
    private DescendingPriceAuctionService descendingPriceAuctionService;

    //Posta un'asta a ribasso
    @PostMapping("/api/descending_price_auction")
    public ResponseEntity<DescendingPriceAuction> createDescendingPriceAuction (@RequestBody DescendingPriceAuction descendingPriceAuction){
        DescendingPriceAuction savedDescendingPriceAuction = descendingPriceAuctionService.createDescendingPriceAuction(descendingPriceAuction);
        return new ResponseEntity<>(savedDescendingPriceAuction, HttpStatus.CREATED);
    }

    //Ottiene una lista di tutte le aste a ribasso
    @GetMapping("/api/descending_price_auctions")
    public ResponseEntity<List<DescendingPriceAuction>> getAllDescendingPriceAuctions() {
        List<DescendingPriceAuction> descendingPriceAuctions = descendingPriceAuctionService.getAllDescendingPriceAuctions();
        return new ResponseEntity<>(descendingPriceAuctions, HttpStatus.OK);
    }

    //Ottiene una singola asta a ribasso in base all'id specificato
    @GetMapping("/api/descending_price_auction/{id}")
    public ResponseEntity<DescendingPriceAuction> getDescendingPriceAuctionById(@PathVariable Long id) {
        DescendingPriceAuction descendingPriceAuction = descendingPriceAuctionService.getDescendingPriceAuctionById(id);
        if(descendingPriceAuction == null)
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);

        return new ResponseEntity<>(descendingPriceAuction, HttpStatus.OK);
    }
}
