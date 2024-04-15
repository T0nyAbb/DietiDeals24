package com.dietideals24.DietiDeals24.service.implementation;

import com.dietideals24.DietiDeals24.entity.*;
import com.dietideals24.DietiDeals24.repository.*;
import com.dietideals24.DietiDeals24.service.AuctionService;
import com.dietideals24.DietiDeals24.service.OfferService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

@Service("mainOfferService")
@AllArgsConstructor
public class OfferServiceImplementation implements OfferService {

    @Autowired
    private OfferRepository offerRepository;
    @Autowired
    private DescendingPriceAuctionRepository descendingPriceAuctionRepository;
    @Autowired
    private EnglishAuctionRepository englishAuctionRepository;
    @Autowired
    private FixedTimeAuctionRepository fixedTimeAuctionRepository;
    @Autowired
    private InverseAuctionRepository inverseAuctionRepository;
    @Autowired
    private AuctionService auctionService;

    @Override
    public Offer makeOffer(Offer offer) {

            Auction auction = auctionService.getAuctionById(offer.getAuctionId());
            auction.setCurrentPrice(offer.getBidAmount());

            if (auction instanceof DescendingPriceAuction){
                DescendingPriceAuction descendingPriceAuction = (DescendingPriceAuction) auction;
                descendingPriceAuctionRepository.save(descendingPriceAuction);
            }
            else if (auction instanceof EnglishAuction){
                EnglishAuction englishAuction = (EnglishAuction) auction;
                englishAuction.setTimer(englishAuction.getTimerAmount());
                englishAuctionRepository.save(englishAuction);
            }
            else if (auction instanceof FixedTimeAuction){
                FixedTimeAuction fixedTimeAuction = (FixedTimeAuction) auction;
                fixedTimeAuctionRepository.save(fixedTimeAuction);
            }
            else if (auction instanceof InverseAuction){
                InverseAuction inverseAuction = (InverseAuction) auction;
                inverseAuctionRepository.save(inverseAuction);
            }

        return offerRepository.save(offer);
    }

    @Override
    public Offer getOfferById(Long id) {
        return offerRepository.getOfferByOfferId(id);
    }
}
