package com.dietideals24.DietiDeals24.service.implementation;

import com.dietideals24.DietiDeals24.entity.Auction;
import com.dietideals24.DietiDeals24.entity.Notification;
import com.dietideals24.DietiDeals24.entity.Offer;
import com.dietideals24.DietiDeals24.repository.NotificationRepository;
import com.dietideals24.DietiDeals24.repository.OfferRepository;
import com.dietideals24.DietiDeals24.service.NotificationService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

@Service("mainNotificationService")
@AllArgsConstructor
public class NotificationServiceImplementation implements NotificationService {

    @Autowired
    private NotificationRepository notificationRepository;
    @Autowired
    private OfferRepository offerRepository;

    @Override
    public Notification sendNotifications(Auction auction) {

        //Notifiche per asta FALLIMENTARE

        if (auction.isFailed()) {
            //Notifica per il venditore
            Notification notificationSeller = new Notification();

            notificationSeller.setAuctionId(auction.getId());
            notificationSeller.setReceiverId(auction.getSellerId());
            notificationSeller.setBody("Your auction \"" + auction.getTitle() + "\" is failed, no one offered!");
            notificationRepository.save(notificationSeller);

            //Notifica per tutti i partecipanti
            List<Long> bidders = new ArrayList<>();

            List<Offer> offers = offerRepository.getAllByAuctionId(auction.getId());
            for (Offer o : offers)
                bidders.add(o.getBidderId());

            Set<Long> set = new HashSet<>(bidders); //Converto lista in set per rimuovere i duplicati ed evitare notifiche duplici
            List<Long> biddersWithoutDuplicates = new ArrayList<>(set);
            biddersWithoutDuplicates.removeIf(id -> id.equals(notificationSeller.getReceiverId())); //Rimuovo l'id del venditore perchè ha già una notifica personalizzata

            for (Long l : biddersWithoutDuplicates) {
                Notification notificationBidders = new Notification();

                notificationBidders.setAuctionId(auction.getId());
                notificationBidders.setReceiverId(l);
                notificationBidders.setBody("Auction \"" + auction.getTitle() + " ended, you lost, someone else won the auction!");
                notificationRepository.save(notificationBidders);
            }
            return notificationSeller;
        }
        //FINE notifiche per asta FALLIMENTARE








        //Notifiche per asta CONCLUSA CON SUCCESSO

        //Notifica per il venditore
        Notification notificationSeller = new Notification();

        notificationSeller.setAuctionId(auction.getId());
        notificationSeller.setReceiverId(auction.getSellerId());
        notificationSeller.setBody("Your auction \"" + auction.getTitle() + "\" just ended, the highest offer was " + auction.getCurrentPrice() + " €");
        notificationRepository.save(notificationSeller);

        //Notifica per il vincitore
        Notification notificationWinner = new Notification();

        notificationWinner.setAuctionId(auction.getId());

            List<Offer> offers = offerRepository.getAllByAuctionId(auction.getId());
            double maxBidValue = 0.0;
            long bidderIDWithMaxValue = -1;

            for (Offer i : offers){
                if(i.getBidAmount() > maxBidValue){
                    maxBidValue = i.getBidAmount();
                    bidderIDWithMaxValue = i.getBidderId();
                }
            }

            //Se c'è un vincitore mando la notifica
            if (bidderIDWithMaxValue != -1) {
                notificationWinner.setReceiverId(bidderIDWithMaxValue);
                notificationWinner.setBody("YOU WON! - You just won the \"" + auction.getTitle() + "\" auction!");
                notificationRepository.save(notificationWinner);
            }


        //Notifica per tutti i partecipanti
        List<Long> bidders = new ArrayList<>();

        offers = offerRepository.getAllByAuctionId(auction.getId());
        for (Offer o : offers)
            bidders.add(o.getBidderId());

        Set<Long> set = new HashSet<>(bidders); //Converto lista in set per rimuovere i duplicati ed evitare notifiche duplici
        List<Long> biddersWithoutDuplicates = new ArrayList<>(set);
        biddersWithoutDuplicates.removeIf(id -> id.equals(notificationSeller.getReceiverId())); //Rimuovo l'id del venditore perchè ha già una notifica personalizzata
        biddersWithoutDuplicates.removeIf(id -> id.equals(notificationWinner.getReceiverId())); //Rimuovo l'id del vincitore perchè ha già una notifica personalizzata

        for (Long l : biddersWithoutDuplicates) {
            Notification notificationBidders = new Notification();

            notificationBidders.setAuctionId(auction.getId());
            notificationBidders.setReceiverId(l);
            notificationBidders.setBody("Auction \"" + auction.getTitle() + "\n ended, you lost, someone else won the auction!");

            notificationRepository.save(notificationBidders);
        }
        return notificationSeller;

        //FINE per notifiche asta CONCLUSA CON SUCCESSO
    }

    @Override
    public List<Notification> getNotificationsByRecieverId (Long userId) {
        return notificationRepository.getNotificationsByReceiverId(userId);
    }

    @Override
    public Notification getNotificationByNotificationId(Long id) {
        return notificationRepository.getNotificationByNotificationId(id);
    }

    @Override
    public void deleteNotification(Long id) {
        notificationRepository.deleteById(id);
    }
}