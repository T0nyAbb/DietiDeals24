package com.dietideals24.DietiDeals24.repository;

import com.dietideals24.DietiDeals24.entity.DescendingPriceAuction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DescendingPriceAuctionRepository extends JpaRepository<DescendingPriceAuction, Long> {
}
