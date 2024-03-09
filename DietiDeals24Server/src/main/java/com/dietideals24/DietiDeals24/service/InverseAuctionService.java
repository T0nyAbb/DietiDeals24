package com.dietideals24.DietiDeals24.service;

import com.dietideals24.DietiDeals24.entity.InverseAuction;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface InverseAuctionService {

    InverseAuction createInverseAuction (InverseAuction inverseauction);

    List<InverseAuction> getAllInverseAuctions();

    InverseAuction getInverseAuctionById(Long id);
}
