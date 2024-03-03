package com.dietideals24.DietiDeals24.repository;

import com.dietideals24.DietiDeals24.entity.Offer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface OfferRepository extends JpaRepository<Offer, Long> {
}