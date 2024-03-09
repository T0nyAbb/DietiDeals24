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
    @Column(nullable = false)
    private int startingPrice;
    @Column
    private int timer;
    @Column
    private int rise;
}
