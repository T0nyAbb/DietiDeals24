package com.dietideals24.DietiDeals24.configuration;

import com.dietideals24.DietiDeals24.entity.*;
import com.dietideals24.DietiDeals24.repository.*;
import com.dietideals24.DietiDeals24.service.NotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;

import java.time.Instant;
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
    @Autowired
    private OfferRepository offerRepository;

    private Instant currentTime;

    @Scheduled(fixedDelay = 1000)
    public void updateTimer(){

        currentTime = Instant.now();

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
        List<Offer> offers = new ArrayList<>(offerRepository.findAll());
        currentTime = Instant.now();
        for (DescendingPriceAuction iterator : descendingPriceAuctions){
            //Attiva l'asta quando la data di inizio è passata e non ci sono offerte per l'asta
            if(!iterator.isActive() && !iterator.isFailed() && iterator.getCurrentPrice() == iterator.getStartingPrice() && iterator.getStartingDate().isBefore(currentTime) && offers.stream().noneMatch(offer -> offer.getAuctionId() == iterator.getId())) {
                iterator.setActive(true);
                descendingPriceAuctionRepository.save(iterator);
            }
            if(iterator.getCurrentPrice() <= 0 && iterator.isActive() || ((iterator.getCurrentPrice() < iterator.getMinimumPrice() || offers.stream().anyMatch(offer -> offer.getAuctionId() == iterator.getId())) && iterator.isActive() && iterator.getStartingDate().isBefore(currentTime))){
                iterator.setActive(false);
                if(iterator.getCurrentPrice() < iterator.getMinimumPrice() || offers.stream().noneMatch(offer -> offer.getAuctionId() == iterator.getId()))
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
        currentTime = Instant.now();
        for (EnglishAuction iterator : englishAuctions){
            //Attiva l'asta quando la data di inizio è passata e non ci sono offerte per l'asta (current price = 0)
            if(!iterator.isActive() && !iterator.isFailed() && iterator.getCurrentPrice() == 0 && iterator.getStartingDate().isBefore(currentTime)) {
                iterator.setActive(true);
                englishAuctionRepository.save(iterator);
            }

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
        currentTime = Instant.now();
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
        currentTime = Instant.now();
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