package com.dietideals24.DietiDeals24.controller;

import com.dietideals24.DietiDeals24.entity.Auction;
import com.dietideals24.DietiDeals24.entity.Notification;
import com.dietideals24.DietiDeals24.service.AuctionService;
import com.dietideals24.DietiDeals24.service.NotificationService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@AllArgsConstructor
@RequestMapping
public class NotificationController {

    @Autowired
    @Qualifier("mainNotificationService")
    private NotificationService notificationService;
    @Autowired
    private AuctionService auctionService;

    //Manda le notifiche quando un'asta viene disattivata
    @PostMapping("/api/send_notification/{id}")
    public ResponseEntity<Notification> sendingNotification(@PathVariable("id") Long id){

        Auction auction = auctionService.getAuctionById(id);

        if(auction.isActive())
            return new ResponseEntity<>(HttpStatus.NOT_ACCEPTABLE);

        Notification savedNotification = notificationService.sendNotifications(auction);
        return new ResponseEntity<>(savedNotification, HttpStatus.OK);
    }

    //Ottiene la lista di tutte le notifiche di uno specifico recieverId
    @GetMapping("/api/notification_by_reciever/{recieverId}")
    public ResponseEntity<List<Notification>> getNotificationsByRecieverId (@PathVariable("recieverId") Long recieverId){
        List<Notification> notification = notificationService.getNotificationsByRecieverId(recieverId);

        if(notification.isEmpty())
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);

        return new ResponseEntity<>(notification, HttpStatus.OK);
    }

    //Ottiene la notifica speficica in base all'id
    @GetMapping("/api/notification_by_notification/{id}")
    public ResponseEntity<Notification> getNotificationByNotificationId (@PathVariable("id") Long id){

        Notification notification = notificationService.getNotificationByNotificationId(id);

        if(notification == null)
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);

        notification = notificationService.getNotificationByNotificationId(id);
        return new ResponseEntity<>(notification, HttpStatus.OK);
    }

    //Elimina una notifica dato un'id
    @DeleteMapping("/api/delete_notification/{id}")
    public ResponseEntity<String> deleteNotification (@PathVariable("id") Long id){

        Notification notification = notificationService.getNotificationByNotificationId(id);

        if(notification == null)
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);

        notificationService.deleteNotification(id);
        return new ResponseEntity<>("Notification with id:" + id + " deleted successfully.", HttpStatus.OK);
    }
}