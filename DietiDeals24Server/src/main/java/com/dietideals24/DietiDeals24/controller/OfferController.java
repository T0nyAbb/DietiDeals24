package com.dietideals24.DietiDeals24.controller;

import com.dietideals24.DietiDeals24.entity.*;
import com.dietideals24.DietiDeals24.service.*;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@AllArgsConstructor
@RequestMapping
public class OfferController {

    @Autowired
    @Qualifier("mainOfferService")
    private OfferService offerService;
    private DescendingPriceAuctionService descendingPriceAuctionService;
    private EnglishAuctionService englishAuctionService;
    private FixedTimeAuctionService fixedTimeAuctionService;
    private InverseAuctionService inverseAuctionService;

    //Posta un'offerta per un'asta
    @PostMapping("/api/offer")
    public ResponseEntity<Offer> makeOffer(@RequestBody Offer offer) {
        Offer savedOffer = offerService.makeOffer(offer);
        return new ResponseEntity<>(savedOffer, HttpStatus.CREATED);
    }

    //Recupera un'offerta in base al suo offerId
    @GetMapping("/api/offer/{id}")
    public ResponseEntity<Offer> getOfferById(@PathVariable("id") Long id){
        Offer offer = offerService.getOfferById(id);

        if(offer == null)
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);

        return new ResponseEntity<>(offer, HttpStatus.OK);
    }

    //Recupera un'asta in base all'offerId
    @GetMapping("/api/auction_by_offer/{id}")
    public <T> T getAuctionByOfferId(@PathVariable("id") Long id){
        Offer offer = offerService.getOfferById(id);

        return switch (offer.getType()) {
            case DescendingPriceAuction -> {
                DescendingPriceAuction descendingPriceAuction = descendingPriceAuctionService.getDescendingPriceAuctionById(offer.getAuctionId());
                yield (T) new ResponseEntity<>(descendingPriceAuction, HttpStatus.OK);
            }
            case EnglishAuction -> {
                EnglishAuction englishAuction = englishAuctionService.getEnglishAuctionById(offer.getAuctionId());
                yield (T) new ResponseEntity<>(englishAuction, HttpStatus.OK);
            }
            case FixedTimeAuction -> {
                FixedTimeAuction fixedTimeAuction = fixedTimeAuctionService.getFixedTimeAuctionById(offer.getAuctionId());
                yield (T) new ResponseEntity<>(fixedTimeAuction, HttpStatus.OK);
            }
            case InverseAuction -> {
                InverseAuction inverseAuction = inverseAuctionService.getInverseAuctionById(offer.getAuctionId());
                yield (T) new ResponseEntity<>(inverseAuction, HttpStatus.OK);
            }
        };
    }
}
