package com.dietideals24.DietiDeals24.service;

import com.dietideals24.DietiDeals24.entity.Auction;
import com.dietideals24.DietiDeals24.entity.Notification;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface NotificationService {

    Notification sendNotifications (Auction auction);

    List<Notification> getNotificationsByRecieverId(Long userId);

    Notification getNotificationByNotificationId (Long id);

    void deleteNotification(Long id);
}
