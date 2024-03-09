package com.dietideals24.DietiDeals24.service.implementation;

import com.dietideals24.DietiDeals24.entity.DescendingPriceAuction;
import com.dietideals24.DietiDeals24.repository.DescendingPriceAuctionRepository;
import com.dietideals24.DietiDeals24.service.DescendingPriceAuctionService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("mainDescendingPriceAuctionService")
@AllArgsConstructor
public class DescendingPriceAuctionServiceImplementation implements DescendingPriceAuctionService {

    private DescendingPriceAuctionRepository descendingPriceAuctionRepository;

    @Override
    public DescendingPriceAuction createDescendingPriceAuction(DescendingPriceAuction descendingPriceAuction) {
        return descendingPriceAuctionRepository.save(descendingPriceAuction);
    }

    @Override
    public List<DescendingPriceAuction> getAllDescendingPriceAuctions() {
        return descendingPriceAuctionRepository.findAll();
    }

    @Override
    public DescendingPriceAuction getDescendingPriceAuctionById(Long id) {
        return descendingPriceAuctionRepository.getDescendingPriceAuctionById(id);
    }
}

