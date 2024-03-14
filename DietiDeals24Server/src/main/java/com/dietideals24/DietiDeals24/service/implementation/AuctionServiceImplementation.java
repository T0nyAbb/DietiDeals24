package com.dietideals24.DietiDeals24.service.implementation;

import com.dietideals24.DietiDeals24.entity.Auction;
import com.dietideals24.DietiDeals24.repository.DescendingPriceAuctionRepository;
import com.dietideals24.DietiDeals24.repository.EnglishAuctionRepository;
import com.dietideals24.DietiDeals24.repository.FixedTimeAuctionRepository;
import com.dietideals24.DietiDeals24.repository.InverseAuctionRepository;
import com.dietideals24.DietiDeals24.service.AuctionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
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
    public List<Auction> getAllAuctions() {
        ArrayList<Auction> auctions = new ArrayList<>(descendingPriceAuctionRepository.findAll());
        auctions.addAll(englishAuctionRepository.findAll());
        auctions.addAll(fixedTimeAuctionRepository.findAll());
        auctions.addAll(inverseAuctionRepository.findAll());

        return auctions;
    }

    @Override
    public List<Auction> getAllAuctionsById(Long sellerId) {
        ArrayList<Auction> auctions = new ArrayList<>(descendingPriceAuctionRepository.findAllBySellerId(sellerId));
        auctions.addAll(englishAuctionRepository.findAllBySellerId(sellerId));
        auctions.addAll(fixedTimeAuctionRepository.findAllBySellerId(sellerId));
        auctions.addAll(inverseAuctionRepository.findAllBySellerId(sellerId));

        return auctions;
    }

    @Override
    public void deleteAuction(Long id) {
        Auction auction = descendingPriceAuctionRepository.getDescendingPriceAuctionById(id);
        if (auction != null) {
            descendingPriceAuctionRepository.deleteById(id);
            return;
        }

        auction = englishAuctionRepository.getEnglishAuctionById(id);
        if (auction != null) {
            englishAuctionRepository.deleteById(id);
            return;
        }

        auction = fixedTimeAuctionRepository.getFixedTimeAuctionById(id);
        if (auction != null) {
            fixedTimeAuctionRepository.deleteById(id);
            return;
        }

        auction = inverseAuctionRepository.getInverseAuctionById(id);
        if (auction != null)
            inverseAuctionRepository.deleteById(id);
    }

    @Override
    public Auction getAuctionById(Long id) {

        Auction auction = descendingPriceAuctionRepository.getDescendingPriceAuctionById(id);
        if (auction != null)
            return auction;

        auction = englishAuctionRepository.getEnglishAuctionById(id);
        if (auction != null)
            return auction;

        auction = fixedTimeAuctionRepository.getFixedTimeAuctionById(id);
        if (auction != null)
            return auction;

        auction = inverseAuctionRepository.getInverseAuctionById(id);
        return auction;
    }

    @Override
    public List<Auction> searchByKeyword(String keyword) {
        List<Auction> results = (descendingPriceAuctionRepository.getByTitleContaining(keyword));
        results.addAll(englishAuctionRepository.getByTitleContaining(keyword));
        results.addAll(fixedTimeAuctionRepository.getByTitleContaining(keyword));
        results.addAll(inverseAuctionRepository.getByTitleContaining(keyword));

        return results;
    }

    @Override
    public List<Auction> searchByCategory(String category) {
        List<Auction> results = (englishAuctionRepository.getByCategoryEquals(category));
        results.addAll(descendingPriceAuctionRepository.getByCategoryEquals(category));
        results.addAll(fixedTimeAuctionRepository.getByCategoryEquals(category));
        results.addAll(inverseAuctionRepository.getByCategoryEquals(category));

        return results;
    }
}
