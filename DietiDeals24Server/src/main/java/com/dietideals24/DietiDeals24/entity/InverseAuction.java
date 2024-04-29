package com.dietideals24.DietiDeals24.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.Instant;

@Getter
@Setter
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "inverseauction")

public class InverseAuction extends Auction{

    @Column(nullable = false)
    private int startingPrice;

    @Column(nullable = false)
    private Instant expiryDate;
}
