package com.dietideals24.DietiDeals24.service;

import com.dietideals24.DietiDeals24.entity.FixedTimeAuction;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface FixedTimeAuctionService {

    FixedTimeAuction createFixedTimeAuction (FixedTimeAuction fixedTimeAuction);

    List<FixedTimeAuction> getAllFixedTimeAuctions();

    FixedTimeAuction updateFixedTimeAuction(FixedTimeAuction fixedTimeAuction);
}
