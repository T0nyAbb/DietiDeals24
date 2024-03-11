package com.dietideals24.DietiDeals24.service.implementation;

import com.dietideals24.DietiDeals24.entity.Offer;
import com.dietideals24.DietiDeals24.repository.OfferRepository;
import com.dietideals24.DietiDeals24.service.OfferService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service("mainOfferService")
@AllArgsConstructor
public class OfferServiceImplementation implements OfferService {

    @Autowired
    private OfferRepository offerRepository;

    @Override
    public Offer makeOffer(Offer offer) {
        return offerRepository.save(offer);
    }

    @Override
    public Offer getOfferById(Long id) {
        return offerRepository.getOfferByOfferId(id);
    }
}
