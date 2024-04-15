package com.dietideals24.DietiDeals24.repository;

import com.dietideals24.DietiDeals24.entity.Auction;
import com.dietideals24.DietiDeals24.entity.FixedTimeAuction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Collection;
import java.util.List;

@Repository
public interface FixedTimeAuctionRepository extends JpaRepository<FixedTimeAuction, Long> {
    FixedTimeAuction getFixedTimeAuctionById(Long id);

    List<Auction> getByTitleContaining(String keyword);

    List<Auction> getByCategoryEquals(String category);

    List<Auction> findAllBySellerId(Long sellerId);
}
