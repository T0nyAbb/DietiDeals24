package com.dietideals24.DietiDeals24.service;

import com.dietideals24.DietiDeals24.entity.Offer;
import org.springframework.stereotype.Service;

@Service
public interface OfferService {

    Offer makeOffer (Offer offer);

    Offer getOfferById (Long id);
}
