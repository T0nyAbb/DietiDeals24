package com.dietideals24.DietiDeals24.repository;

import com.dietideals24.DietiDeals24.entity.InverseAuction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface InverseAuctionRepository extends JpaRepository <InverseAuction, Long> {
    InverseAuction getInverseAuctionById(Long id);
}
