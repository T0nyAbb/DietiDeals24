package com.dietideals24.DietiDeals24.service;

import com.dietideals24.DietiDeals24.entity.DescendingPriceAuction;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface DescendingPriceAuctionService {

    DescendingPriceAuction createDescendingPriceAuction (DescendingPriceAuction descendingPriceAuction);

    List<DescendingPriceAuction> getAllDescendingPriceAuctions();

    DescendingPriceAuction updateDescendingPriceAuction(DescendingPriceAuction descendingPriceAuction);
}
