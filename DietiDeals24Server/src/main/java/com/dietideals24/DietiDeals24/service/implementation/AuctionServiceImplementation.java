package com.dietideals24.DietiDeals24.service.implementation;

import com.dietideals24.DietiDeals24.entity.Auction;
import com.dietideals24.DietiDeals24.repository.DescendingPriceAuctionRepository;
import com.dietideals24.DietiDeals24.repository.EnglishAuctionRepository;
import com.dietideals24.DietiDeals24.repository.FixedTimeAuctionRepository;
import com.dietideals24.DietiDeals24.repository.InverseAuctionRepository;
import com.dietideals24.DietiDeals24.service.AuctionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("mainAuctionService")
public class AuctionServiceImplementation implements AuctionService {

    @Autowired
    private DescendingPriceAuctionRepository descendingPriceAuctionRepository;
    @Autowired
    private EnglishAuctionRepository englishAuctionRepository;
    @Autowired
    private FixedTimeAuctionRepository fixedTimeAuctionRepository;
    @Autowired
    private InverseAuctionRepository inverseAuctionRepository;

    @Override
    public List<Auction> searchByKeyword(String keyword) {
        List<Auction> results = (descendingPriceAuctionRepository.getByTitleContaining(keyword));
        results.addAll(englishAuctionRepository.getByTitleContaining(keyword));
        results.addAll(fixedTimeAuctionRepository.getByTitleContaining(keyword));
        results.addAll(inverseAuctionRepository.getByTitleContaining(keyword));

        return results;
    }
}
