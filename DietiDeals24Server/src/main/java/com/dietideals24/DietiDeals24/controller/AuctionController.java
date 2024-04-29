package com.dietideals24.DietiDeals24.controller;

import com.dietideals24.DietiDeals24.entity.Auction;
import com.dietideals24.DietiDeals24.service.AuctionService;
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
public class AuctionController {

    @Autowired
    @Qualifier("mainAuctionService")
    private AuctionService auctionService;

    //Ottiene tutte le aste
    @GetMapping("/api/auctions")
    public ResponseEntity<List<Auction>> getAllAuctions () {
        List<Auction> auctions = auctionService.getAllAuctions();
        if(auctions == null)
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);

        return new ResponseEntity<>(auctions, HttpStatus.OK);
    }

    //Ottiene una singola asta in base all'id specificato
    @GetMapping("/api/auction/{id}")
    public ResponseEntity<Auction> getAuctionById (@PathVariable Long id) {
        Auction auction = auctionService.getAuctionById(id);
        if(auction == null)
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);

        return new ResponseEntity<>(auction, HttpStatus.OK);
    }

    //Ottiene tutte le aste di uno specifico sellerId
    @GetMapping("/api/auctions/{sellerId}")
    public ResponseEntity<List<Auction>> getAuctionsBySellerId (@PathVariable Long sellerId) {
        List<Auction> auctions = auctionService.getAllAuctionsById(sellerId);
        if(auctions.isEmpty())
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);

        return new ResponseEntity<>(auctions, HttpStatus.OK);
    }

    //Effettua la ricerca delle aste utilizzando la parola chiave fornita
    @GetMapping("/api/filter_by_keyword")
    public ResponseEntity<List<Auction>> searchByKeyword(@RequestParam("keyword") String keyword) {
        List<Auction> auctions = auctionService.searchByKeyword(keyword);

        if(auctions.isEmpty())
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);

        return new ResponseEntity<>(auctions, HttpStatus.OK);
    }

    //Effettua la ricerca delle aste utilizzando la categoria
    @GetMapping("/api/filter_by_category")
    public ResponseEntity<List<Auction>> searchByCategory(@RequestParam("category") String category) {
        List<Auction> auctions =  auctionService.searchByCategory(category);

        if(auctions.isEmpty())
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);

        return new ResponseEntity<>(auctions, HttpStatus.OK);
    }

    //Elimina un'asta in base all'id
    @DeleteMapping("/api/delete_auction/{id}")
    public ResponseEntity<String> deleteAuction (@PathVariable("id") Long id){
        Auction auction = auctionService.getAuctionById(id);

        if(auction == null)
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);

        auctionService.deleteAuction(id);
        return new ResponseEntity<>("Auction with id:" + id + " deleted successfully.", HttpStatus.OK);
    }
}
