package com.dietideals24.DietiDeals24.controller;

import com.dietideals24.DietiDeals24.entity.EnglishAuction;
import com.dietideals24.DietiDeals24.service.EnglishAuctionService;
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
public class EnglishAuctionController {

    @Autowired
    @Qualifier("mainEnglishAuctionService")
    private EnglishAuctionService englishAuctionService;

    //Posta un'asta all'inglese
    @PostMapping("/api/english_auction")
    public ResponseEntity<EnglishAuction> createEnglishAuction (@RequestBody EnglishAuction englishAuction){
        EnglishAuction savedEnglishAuction = englishAuctionService.createEnglishAuction(englishAuction);
        return new ResponseEntity<>(savedEnglishAuction, HttpStatus.CREATED);
    }

    //Ottiene una lista di tutte le aste all'inglese
    @GetMapping("/api/english_auctions")
    public ResponseEntity<List<EnglishAuction>> getAllEnglishAuctions() {
        List<EnglishAuction> englishAuctions = englishAuctionService.getAllEnglishAuctions();
        return new ResponseEntity<>(englishAuctions, HttpStatus.OK);
    }

    //Ottiene una singola asta all'inglese in base all'id specificato
    @GetMapping("/api/english_auction/{id}")
    public ResponseEntity<EnglishAuction> getEnglishAuctionById(@PathVariable Long id) {
        EnglishAuction englishAuction = englishAuctionService.getEnglishAuctionById(id);
        if(englishAuction == null)
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);

        return new ResponseEntity<>(englishAuction, HttpStatus.OK);
    }
}