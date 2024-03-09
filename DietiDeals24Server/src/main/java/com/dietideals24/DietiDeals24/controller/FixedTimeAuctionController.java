package com.dietideals24.DietiDeals24.controller;

import com.dietideals24.DietiDeals24.entity.FixedTimeAuction;
import com.dietideals24.DietiDeals24.service.FixedTimeAuctionService;
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
public class FixedTimeAuctionController {

    @Autowired
    @Qualifier("mainFixedTimeAuctionService")
    private FixedTimeAuctionService fixedTimeAuctionService;

    //Posta un'asta a tempo fisso
    @PostMapping("/api/fixed_time_auction")
    public ResponseEntity<FixedTimeAuction> createFixedTimeAuction (@RequestBody FixedTimeAuction fixedTimeAuction){
        FixedTimeAuction savedFixedTimeAuction = fixedTimeAuctionService.createFixedTimeAuction(fixedTimeAuction);
        return new ResponseEntity<>(savedFixedTimeAuction, HttpStatus.CREATED);
    }

    //Ottiene una lista di tutte le aste a tempo fisso
    @GetMapping("/api/fixed_time_auctions")
    public ResponseEntity<List<FixedTimeAuction>> getAllFixedTimeAuctions() {
        List<FixedTimeAuction> fixedTimeAuctions = fixedTimeAuctionService.getAllFixedTimeAuctions();
        return new ResponseEntity<>(fixedTimeAuctions, HttpStatus.OK);
    }

    //Ottiene una singola asta a tempo fisso in base all'id specificato
    @GetMapping("/api/fixed_time_auction/{id}")
    public ResponseEntity<FixedTimeAuction> getFixedTimeAuctionById(@PathVariable Long id) {
        FixedTimeAuction fixedTimeAuction = fixedTimeAuctionService.getFixedTimeAuctionById(id);
        if(fixedTimeAuction == null)
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);

        return new ResponseEntity<>(fixedTimeAuction, HttpStatus.OK);
    }
}
