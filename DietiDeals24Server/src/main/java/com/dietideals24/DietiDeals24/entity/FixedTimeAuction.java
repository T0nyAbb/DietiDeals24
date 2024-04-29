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
@Table(name = "fixedtimeauction")

public class FixedTimeAuction extends Auction{

    @Column(nullable = false)
    private long minimumPrice = 0;
    @Column(nullable = false)
    private Instant expiryDate;
}
