package com.dietideals24.DietiDeals24.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "inverseauction")

public class InverseAuction extends Auction{

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    private int startingPrice;
    private LocalDateTime expiryDate;
}
