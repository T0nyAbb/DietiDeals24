package com.dietideals24.DietiDeals24.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.Instant;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "descendingpriceauction")

public class DescendingPriceAuction extends Auction{

    @Column(nullable = false)
    private long startingPrice;
    @Column(nullable = false)
    private Instant startingDate;
    @Column(nullable = false)
    private int timer = 3600;
    @Column(nullable = false)
    private int timerAmount = 3600;
    @Column(nullable = false)
    private long reduction;
    @Column(nullable = false)
    private int minimumPrice;
}
