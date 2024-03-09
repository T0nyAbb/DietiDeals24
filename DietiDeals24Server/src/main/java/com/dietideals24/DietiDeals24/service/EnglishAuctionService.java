package com.dietideals24.DietiDeals24.service;

import com.dietideals24.DietiDeals24.entity.EnglishAuction;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface EnglishAuctionService {

    EnglishAuction createEnglishAuction (EnglishAuction englishAuction);

    List<EnglishAuction> getAllEnglishAuctions();

    EnglishAuction getEnglishAuctionById(Long id);
}
