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

public class EnglishAuction extends Auction{

    @Column(nullable = false)
    private int startingPrice;

    @Column
    private int timer;

    @Column
    private int rise;
}
