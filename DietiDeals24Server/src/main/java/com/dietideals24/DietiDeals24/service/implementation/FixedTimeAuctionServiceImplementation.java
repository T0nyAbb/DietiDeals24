package com.dietideals24.DietiDeals24.service.implementation;

import com.dietideals24.DietiDeals24.entity.FixedTimeAuction;
import com.dietideals24.DietiDeals24.repository.FixedTimeAuctionRepository;
import com.dietideals24.DietiDeals24.service.FixedTimeAuctionService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("mainFixedTimeAuctionService")
@AllArgsConstructor
public class FixedTimeAuctionServiceImplementation implements FixedTimeAuctionService {

    private FixedTimeAuctionRepository fixedTimeAuctionRepository;

    @Override
    public FixedTimeAuction createFixedTimeAuction(FixedTimeAuction fixedTimeAuction) {
        return fixedTimeAuctionRepository.save(fixedTimeAuction);
    }

    @Override
    public List<FixedTimeAuction> getAllFixedTimeAuctions() {
        return fixedTimeAuctionRepository.findAll();
    }

    @Override
    public FixedTimeAuction getFixedTimeAuctionById(Long id) {
        return fixedTimeAuctionRepository.getFixedTimeAuctionById(id);
    }
}
