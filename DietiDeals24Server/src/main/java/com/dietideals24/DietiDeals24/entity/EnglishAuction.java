package com.dietideals24.DietiDeals24.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "englishauction")

public class EnglishAuction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    @Column
    private String title;
    @Column(nullable = true)
    private String description;
    @Column(nullable = true)
    private String category;
    @Column
    private long sellerId;
    @Column
    private String urlPicture;
    @Column
    private int startingPrice;
    @Column
    private int timer;
    @Column
    private int rise;
    @Column
    private String bidder;
}
