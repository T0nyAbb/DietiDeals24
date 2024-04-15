package com.dietideals24.DietiDeals24.service.implementation;

import com.dietideals24.DietiDeals24.entity.EnglishAuction;
import com.dietideals24.DietiDeals24.repository.EnglishAuctionRepository;
import com.dietideals24.DietiDeals24.service.EnglishAuctionService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("mainEnglishAuctionService")
@AllArgsConstructor
public class EnglishAuctionServiceImplementation implements EnglishAuctionService {

    private EnglishAuctionRepository englishAuctionRepository;

    @Override
    public EnglishAuction createEnglishAuction(EnglishAuction englishAuction) {
        englishAuction.setTimerAmount(englishAuction.getTimer());
        return englishAuctionRepository.save(englishAuction);
    }

    @Override
    public List<EnglishAuction> getAllEnglishAuctions() {
        return englishAuctionRepository.findAll();
    }

    @Override
    public EnglishAuction updateEnglishAuction(EnglishAuction englishAuction) {
        return englishAuctionRepository.save(englishAuction);
    }
}
