package com.dietideals24.DietiDeals24.service;

import com.dietideals24.DietiDeals24.entity.Auction;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface AuctionService {

    Auction getAuctionById (Long id);

    List<Auction> searchByKeyword(String keyword);

    List<Auction> searchByCategory(String category);

    List<Auction> getAllAuctions();

    List<Auction> getAllAuctionsById(Long sellerId);

    void deleteAuction(Long id);
}
