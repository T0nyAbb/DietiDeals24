package com.dietideals24.DietiDeals24.controller;

import com.dietideals24.DietiDeals24.entity.EnglishAuction;
import com.dietideals24.DietiDeals24.service.AuctionService;
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
    @Autowired
    private AuctionService auctionService;

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

    //Modifica un'asta inglese esistente
    @PutMapping("/api/english_auction/{id}")
    public ResponseEntity<EnglishAuction> updateEnglishAuction (@PathVariable ("id") Long id,
                                                                @RequestBody EnglishAuction englishAuction){

        EnglishAuction checkExists = (EnglishAuction) auctionService.getAuctionById(id);
        if(checkExists == null)
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);

        englishAuction.setId(id);
        englishAuction = englishAuctionService.updateEnglishAuction(englishAuction);

        return new ResponseEntity<>(englishAuction, HttpStatus.OK);
    }
}