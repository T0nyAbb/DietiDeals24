package com.dietideals24.DietiDeals24.controller;

import com.dietideals24.DietiDeals24.entity.*;
import com.dietideals24.DietiDeals24.service.*;
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
public class OfferController {

    @Autowired
    @Qualifier("mainOfferService")
    private OfferService offerService;
    @Autowired
    private AuctionService auctionService;

    //Posta un'offerta per un'asta
    @PostMapping("/api/offer")
    public ResponseEntity<Offer> makeOffer(@RequestBody Offer offer) {
        Auction auction = auctionService.getAuctionById(offer.getAuctionId());
        if(!auction.isActive())
            return new ResponseEntity<>(HttpStatus.NOT_ACCEPTABLE);
        if(offer.getBidAmount() <= auction.getCurrentPrice() && !(auction instanceof DescendingPriceAuction))
            return new ResponseEntity<>(HttpStatus.CONFLICT);
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
    public ResponseEntity<Auction> getAuctionByOfferId(@PathVariable("id") Long id){
        Offer offer = offerService.getOfferById(id);

        if (offer == null)
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);

        Auction auction = auctionService.getAuctionById(offer.getAuctionId());
        return new ResponseEntity<>(auction, HttpStatus.OK);
    }
}
