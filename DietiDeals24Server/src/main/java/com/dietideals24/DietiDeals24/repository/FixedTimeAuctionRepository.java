package com.dietideals24.DietiDeals24.repository;

import com.dietideals24.DietiDeals24.entity.FixedTimeAuction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FixedTimeAuctionRepository extends JpaRepository<FixedTimeAuction, Long> {
    FixedTimeAuction getFixedTimeAuctionById(Long id);
}
