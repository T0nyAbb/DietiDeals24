package com.dietideals24.DietiDeals24.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@MappedSuperclass
@Getter
@Setter
public abstract class Auction {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    @Column(length = 4096, nullable = false)
    private String title;
    @Column(length = 4096)
    private String description;
    @Column
    private String category;
    @Column(nullable = false)
    private long sellerId;
    @Column(length = 4096)
    private String urlPicture;
    @Column(nullable = false)
    private boolean isActive = true;
    @Column(nullable = false)
    private boolean isFailed = false;
    @Column(nullable = false)
    private double currentPrice = 0;
}