package com.dietideals24.DietiDeals24.controller;

import com.dietideals24.DietiDeals24.entity.Auction;
import com.dietideals24.DietiDeals24.service.AuctionService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@AllArgsConstructor
@RequestMapping
public class AuctionController {

    @Autowired
    @Qualifier("mainAuctionService")
    private AuctionService auctionService;

    //Effettua la ricerca delle aste utilizzando la parola chiave fornita
    @GetMapping("/api/search")
    public List<Auction> searchByKeyword(@RequestParam("keyword") String keyword) {
        return auctionService.searchByKeyword(keyword);
    }
}
