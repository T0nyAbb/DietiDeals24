package com.dietideals24.DietiDeals24.controller;

import com.dietideals24.DietiDeals24.entity.FixedTimeAuction;
import com.dietideals24.DietiDeals24.service.AuctionService;
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
    @Autowired
    private AuctionService auctionService;

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

    //Modifica un'asta a tempo fisso esistente
    @PutMapping("/api/fixed_time_auction/{id}")
    public ResponseEntity<FixedTimeAuction> updateFixedTimeAuction (@PathVariable ("id") Long id,
                                                                    @RequestBody FixedTimeAuction fixedTimeAuction){

        FixedTimeAuction checkExists = (FixedTimeAuction) auctionService.getAuctionById(id);
        if(checkExists == null)
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);

        fixedTimeAuction.setId(id);
        fixedTimeAuction = fixedTimeAuctionService.updateFixedTimeAuction(fixedTimeAuction);

        return new ResponseEntity<>(fixedTimeAuction, HttpStatus.OK);
    }
}
