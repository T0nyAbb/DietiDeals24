package com.dietideals24.DietiDeals24.configuration;

import com.dietideals24.DietiDeals24.entity.*;
import com.dietideals24.DietiDeals24.repository.DescendingPriceAuctionRepository;
import com.dietideals24.DietiDeals24.repository.EnglishAuctionRepository;
import com.dietideals24.DietiDeals24.repository.FixedTimeAuctionRepository;
import com.dietideals24.DietiDeals24.repository.InverseAuctionRepository;
import com.dietideals24.DietiDeals24.service.NotificationService;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Configuration
@EnableScheduling
public class SpringConfig {

    @Autowired
    private DescendingPriceAuctionRepository descendingPriceAuctionRepository;
    @Autowired
    private EnglishAuctionRepository englishAuctionRepository;
    @Autowired
    private FixedTimeAuctionRepository fixedTimeAuctionRepository;
    @Autowired
    private InverseAuctionRepository inverseAuctionRepository;
    @Autowired
    private NotificationService notificationService;

    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern = "dd-MM-yyyy'T'HH:mm:ss[.SSS][.SS][.S]")
    private LocalDateTime currentTime;

    @Scheduled(fixedDelay = 1000)
    public void updateTimer(){

        currentTime = LocalDateTime.now();

        List<DescendingPriceAuction> descendingPriceAuctions = descendingPriceAuctionRepository.findAll();
        for (DescendingPriceAuction iterator : descendingPriceAuctions)
            if (iterator.isActive() && iterator.getStartingDate().isBefore(currentTime)) {
                iterator.setTimer(iterator.getTimer() - 1);
                if(iterator.getTimer() == 0) {
                    iterator.setCurrentPrice(iterator.getCurrentPrice() - iterator.getReduction());
                    iterator.setTimer(iterator.getTimerAmount());
                }
                descendingPriceAuctionRepository.save(iterator);
            }

        List<EnglishAuction> englishAuctions = englishAuctionRepository.findAll();
        for (EnglishAuction iterator : englishAuctions)
            if (iterator.isActive() && iterator.getStartingDate().isBefore(currentTime)) {
                iterator.setTimer(iterator.getTimer() - 1);
                englishAuctionRepository.save(iterator);
            }
    }

    //Controllo ogni secondo della validità delle aste a ribasso
    @Scheduled(fixedDelay = 1000)
    public void descendingPriceAuctionValidity(){
        List<DescendingPriceAuction> descendingPriceAuctions = new ArrayList<>(descendingPriceAuctionRepository.findAll());
        currentTime = LocalDateTime.now();
        for (DescendingPriceAuction iterator : descendingPriceAuctions){
            if(iterator.getCurrentPrice() != 0 || iterator.getCurrentPrice() < iterator.getMinimumPrice() && iterator.isActive() && iterator.getStartingDate().isBefore(currentTime)){
                iterator.setActive(false);
                if(iterator.getCurrentPrice() < iterator.getMinimumPrice())
                    iterator.setFailed(true);
                descendingPriceAuctionRepository.save(iterator);
                notificationService.sendNotifications(iterator); //Manda le notifiche
            }
        }
    }

    //Controllo ogni secondo della validità delle aste inglesi
    @Scheduled(fixedDelay = 1000)
    public void englishAuctionValidity(){
        List<EnglishAuction> englishAuctions = new ArrayList<>(englishAuctionRepository.findAll());
        currentTime = LocalDateTime.now();
        for (EnglishAuction iterator : englishAuctions){
            if(iterator.getTimer() <= 0 && iterator.isActive() && iterator.getStartingDate().isBefore(currentTime)) {
                iterator.setActive(false);
                if(iterator.getCurrentPrice() == 0)
                    iterator.setFailed(true);
                englishAuctionRepository.save(iterator);
                notificationService.sendNotifications(iterator); //Manda le notifiche
            }
        }
    }

    //Controllo ogni secondo della validità delle aste a tempo fisso
    @Scheduled(fixedDelay = 1000)
    public void fixedTimeAuctionValidity(){
        List<FixedTimeAuction> fixedTimeAuctions = new ArrayList<>(fixedTimeAuctionRepository.findAll());
        currentTime = LocalDateTime.now();
        for (FixedTimeAuction iterator : fixedTimeAuctions) {
            if ((((iterator.getExpiryDate()).isBefore(currentTime)) && iterator.isActive())) {
                iterator.setActive(false);
                if (iterator.getCurrentPrice() < iterator.getMinimumPrice())
                    iterator.setFailed(true);

                fixedTimeAuctionRepository.save(iterator);
                notificationService.sendNotifications(iterator); //Manda le notifiche
            }
        }
    }

    //Controllo ogni secondo della validità delle aste inverse
    @Scheduled(fixedDelay = 1000)
    public void inverseAuctionValidity(){
        List<InverseAuction> inverseAuctions = new ArrayList<>(inverseAuctionRepository.findAll());
        currentTime = LocalDateTime.now();
        for (InverseAuction iterator : inverseAuctions) {
            if ((iterator.getExpiryDate()).isBefore(currentTime) && iterator.isActive()) {
                iterator.setActive(false);
                if(iterator.getCurrentPrice() == 0)
                    iterator.setFailed(true);

                inverseAuctionRepository.save(iterator);
                notificationService.sendNotifications(iterator); //Manda le notifiche
            }
        }
    }
}