package com.dietideals24.DietiDeals24.service.implementation;

import com.dietideals24.DietiDeals24.entity.InverseAuction;
import com.dietideals24.DietiDeals24.entity.User;
import com.dietideals24.DietiDeals24.repository.InverseAuctionRepository;
import com.dietideals24.DietiDeals24.service.InverseAuctionService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service("mainInverseAuctionService")
@AllArgsConstructor
public class InverseAuctionServiceImplementation implements InverseAuctionService {

    private InverseAuctionRepository inverseAuctionRepository;

    @Override
    public InverseAuction createInverseAuction(InverseAuction inverseauction) {
        return inverseAuctionRepository.save(inverseauction);
    }

    @Override
    public List<InverseAuction> getAllInverseAuctions() {
        return inverseAuctionRepository.findAll();
    }

    @Override
    public InverseAuction updateInverseAuction(InverseAuction inverseAuction) {
        return inverseAuctionRepository.save(inverseAuction);
    }
}
