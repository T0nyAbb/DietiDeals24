package com.dietideals24.DietiDeals24.service;

import com.dietideals24.DietiDeals24.entity.Auction;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface AuctionService {

    List<Auction> searchByKeyword(String keyword);
}
