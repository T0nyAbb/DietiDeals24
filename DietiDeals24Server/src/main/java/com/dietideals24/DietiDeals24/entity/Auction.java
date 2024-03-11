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
    @Column(nullable = false)
    private String title;
    @Column
    private String description;
    @Column
    private String category;
    @Column(nullable = false)
    private long sellerId;
    @Column
    private String urlPicture;

}