package com.dietideals24.DietiDeals24.repository;

import com.dietideals24.DietiDeals24.entity.Notification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, Long> {
    List<Notification> getNotificationsByReceiverId(Long userId);

    Notification getNotificationByNotificationId(Long id);
}
