package com.dietideals24.DietiDeals24.repository;

import com.dietideals24.DietiDeals24.entity.Offer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OfferRepository extends JpaRepository<Offer, Long> {

    Offer getOfferByOfferId(Long id);

    List<Offer> getAllByAuctionId(Long id);
}